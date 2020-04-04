import 'package:boostnote_mobile/business_logic/model/Folder.dart';
import 'package:boostnote_mobile/business_logic/service/FolderService.dart';
import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:boostnote_mobile/presentation/notifiers/FolderNotifier.dart';
import 'package:boostnote_mobile/presentation/widgets/buttons/CancelButton.dart';
import 'package:boostnote_mobile/presentation/widgets/buttons/SaveButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateFolderDialog extends StatefulWidget {

  @override
  _CreateNoteDialogState createState() => _CreateNoteDialogState();
}

class _CreateNoteDialogState extends State<CreateFolderDialog> {

  final FolderService _folderService = FolderService();
  final TextEditingController _textEditingController = TextEditingController();
  FolderNotifier _folderNotifier;

  @override
  Widget build(BuildContext context) {
    _folderNotifier = Provider.of<FolderNotifier>(context);

    return AlertDialog(
      title: Container( 
        alignment: Alignment.center,
        child: Text(AppLocalizations.of(context).translate('create_folder'), style: TextStyle(color:  Theme.of(context).textTheme.display1.color))
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context).translate('enter_name'),
                    hintStyle: Theme.of(context).textTheme.display2
                  ),
                  controller: _textEditingController,
                  style: TextStyle(color:  Theme.of(context).textTheme.display1.color)
                ), 
              ],
            ),
          );
        },
      ),
      actions: <Widget>[
        CancelButton(),
        SaveButton(save: _save)
      ],
    );
  }

  void _save() {
     Navigator.of(context).pop();
      _folderService
        .createFolderIfNotExisting(Folder(name: _textEditingController.text))
        .whenComplete(_refresh);
  }

  void _refresh() {
    _folderService.findAllUntrashed().then((folders) {
       _folderNotifier.folders = folders;
    });
  }
}
