import 'package:boostnote_mobile/business_logic/model/Folder.dart';
import 'package:boostnote_mobile/business_logic/service/FolderService.dart';
import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:boostnote_mobile/presentation/notifiers/FolderNotifier.dart';
import 'package:boostnote_mobile/presentation/widget/buttons/CancelButton.dart';
import 'package:boostnote_mobile/presentation/widgets/buttons/SaveButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RenameFolderDialog extends StatefulWidget {
  @override
  _CreateNoteDialogState createState() => _CreateNoteDialogState();
}

class _CreateNoteDialogState extends State<RenameFolderDialog> {

  final TextEditingController _textEditingController = TextEditingController();
  FolderService _folderService = FolderService();
  FolderNotifier _folderNotifier;

  @override
  Widget build(BuildContext context) {
    _folderNotifier = Provider.of<FolderNotifier>(context);

    return AlertDialog(
      title: Container( 
        alignment: Alignment.center,
        child: Text(
          AppLocalizations.of(context).translate('rename_folder') + ' ' + _folderNotifier.selectedFolder.name, 
          style: TextStyle(color: Theme.of(context).textTheme.display1.color)
        )
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: 100,
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _textEditingController,
                  style: TextStyle(color: Theme.of(context).textTheme.display1.color),
                ), 
              ],
            ),
          );
        },
      ),
      actions: <Widget>[
        CancelButton(),
        SaveButton(save: _renameFolder)
      ],
    );
  }

  void _renameFolder() {
    Navigator.of(context).pop();
    _folderService
      .renameFolder(_folderNotifier.selectedFolder, _textEditingController.text)
      .whenComplete(() => refresh());
  }

  void refresh() {
    Folder folder = _folderNotifier.selectedFolder;
    folder.name = _textEditingController.text;
    _folderNotifier.selectedFolder = folder;
  }
}