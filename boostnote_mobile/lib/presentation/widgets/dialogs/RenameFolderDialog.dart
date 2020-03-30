import 'package:boostnote_mobile/business_logic/model/Folder.dart';
import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:boostnote_mobile/presentation/widgets/buttons/CancelButton.dart';
import 'package:boostnote_mobile/presentation/widgets/buttons/SaveButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RenameFolderDialog extends StatefulWidget {

  final Folder folder;
  final Function(String newFolderName) saveCallback;
  final Function() cancelCallback;

  const RenameFolderDialog({Key key, @required this.saveCallback, @required this.cancelCallback, @required this.folder}) : super(key: key); //TODO: Constructor

  @override
  _CreateNoteDialogState createState() => _CreateNoteDialogState();
}

class _CreateNoteDialogState extends State<RenameFolderDialog> {

  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Container( 
        alignment: Alignment.center,
        child: Text(AppLocalizations.of(context).translate('rename_folder') + ' ' + this.widget.folder.name, style: TextStyle(color: Theme.of(context).textTheme.display1.color))
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
        SaveButton(save: () {
          this.widget.saveCallback(_textEditingController.text);
        })
      ],
    );
  }
}