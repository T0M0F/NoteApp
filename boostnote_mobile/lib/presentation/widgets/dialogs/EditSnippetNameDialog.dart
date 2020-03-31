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

    @override
    Widget build(BuildContext context) {

      _snippetNotifier = Provider.of<SnippetNotifier>(context);
      _textEditingController.text = _snippetNotifier.selectedCodeSnippet.name;

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
              controller: _textEditingController,
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
                _snippetNotifier.selectedCodeSnippet.name = _textEditingController.text;
                Navigator.of(context).pop();
              }
          })
        ];
    }
}
