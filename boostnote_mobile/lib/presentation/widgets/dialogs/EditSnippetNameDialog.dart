import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:boostnote_mobile/presentation/notifiers/SnippetNotifier.dart';
import 'package:boostnote_mobile/presentation/widgets/buttons/CancelButton.dart';
import 'package:boostnote_mobile/presentation/widgets/buttons/SaveButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class EditSnippetNameDialog extends StatelessWidget {

    SnippetNotifier _snippetNotifier;
    TextEditingController _textEditingController;
    TextEditingController _textEditingController2;

    @override
    Widget build(BuildContext context) {

      _snippetNotifier = Provider.of<SnippetNotifier>(context);
      _textEditingController = TextEditingController();
      _textEditingController2 = TextEditingController();
      _textEditingController.text = _snippetNotifier.selectedCodeSnippet.name;
      _textEditingController2.text = _snippetNotifier.selectedCodeSnippet.mode;

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
        height: 120,
        child: Column(
          children: <Widget>[
            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context).translate('enter_title'),
                hintStyle: TextStyle(color:  Theme.of(context).textTheme.display2.color),
              ),
              style: TextStyle(color:  Theme.of(context).textTheme.display1.color),
            ), 
            TextField(
              controller: _textEditingController2,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context).translate('mode'),
                hintStyle: TextStyle(color:  Theme.of(context).textTheme.display2.color),
              ),
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
            if(_textEditingController.text.trim().length > 0){
                CodeSnippet codeSnippet = _snippetNotifier.selectedCodeSnippet;
                codeSnippet.name = _textEditingController.text;
                _snippetNotifier.selectedCodeSnippet = codeSnippet; //otherwise no rebuild
                Navigator.of(context).pop();
            }
          })
        ];
    }
}
