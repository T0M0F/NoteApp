import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:boostnote_mobile/presentation/widgets/buttons/CancelButton.dart';
import 'package:boostnote_mobile/presentation/widgets/buttons/SaveButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EditSnippetNameDialog extends StatelessWidget {

  final TextEditingController textEditingController; 
  final String noteTitle;
  final Function(String) onNameChanged; //TODO Rename all Callbacks

  const EditSnippetNameDialog({Key key, this.textEditingController, this.noteTitle, this.onNameChanged}) : super(key: key); //TODO Constructor

    @override
    Widget build(BuildContext context) {

      textEditingController.text = noteTitle;

      return AlertDialog(
        title: _buildTitle(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return _buildContent(context);
          },
        ),
        actions: _buildActions(context),
      );
    }


    Container _buildTitle(BuildContext context) {
      return Container( 
        alignment: Alignment.center,
        child: Text(AppLocalizations.of(context).translate('change'), style: TextStyle(color:  Theme.of(context).textTheme.display1.color))
      );
    }


    Container _buildContent(BuildContext context) {
      return Container(
        height: 75,
        child: Column(
          children: <Widget>[
            TextField(
              controller: textEditingController,
              style: TextStyle(color:  Theme.of(context).textTheme.display1.color),
            ), 
          ],
        ),
      );
    }


    List<Widget> _buildActions(BuildContext context) {
      return <Widget>[
          CancelButton(),
          SaveButton(save: () {
            if(textEditingController.text.trim().length > 0){
                onNameChanged(textEditingController.text); 
              }
          })
        ];
    }
}
