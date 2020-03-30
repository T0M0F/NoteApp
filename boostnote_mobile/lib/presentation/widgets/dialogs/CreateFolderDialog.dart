import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:boostnote_mobile/presentation/widgets/buttons/CancelButton.dart';
import 'package:boostnote_mobile/presentation/widgets/buttons/SaveButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateFolderDialog extends StatefulWidget {

  final Function(String folderName) saveCallback;
  final Function() cancelCallback;

  const CreateFolderDialog({Key key, @required this.saveCallback, @required this.cancelCallback}) : super(key: key); //TODO: Constructor

  @override
  _CreateNoteDialogState createState() => _CreateNoteDialogState();
}

class _CreateNoteDialogState extends State<CreateFolderDialog> {

  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
        SaveButton(save: () {
          this.widget.saveCallback(_textEditingController.text);
        })
      ],
    );
  }
}
