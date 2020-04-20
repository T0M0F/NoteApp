import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/SnippetNotifier.dart';
import 'package:boostnote_mobile/presentation/widgets/buttons/CancelButton.dart';
import 'package:boostnote_mobile/presentation/widgets/buttons/SaveButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class EditSnippetNameDialog extends StatefulWidget {
  @override
  _EditSnippetNameDialogState createState() => _EditSnippetNameDialogState();
}

class _EditSnippetNameDialogState extends State<EditSnippetNameDialog> {

    SnippetNotifier _snippetNotifier;
    NoteNotifier _noteNotifier;
    NoteService _noteService;
    TextEditingController _textEditingControllerForName;
    TextEditingController _textEditingControllerForMode;

    @override
    Widget build(BuildContext context) {
      _init(context);
      return _buildWidget(context);
    }

    AlertDialog _buildWidget(BuildContext context) {
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

    void _init(BuildContext context) {
      _noteService = NoteService();
      _snippetNotifier = Provider.of<SnippetNotifier>(context);
      _noteNotifier = Provider.of<NoteNotifier>(context);
      _textEditingControllerForName = TextEditingController();
      _textEditingControllerForMode = TextEditingController();
      _textEditingControllerForName.text = _snippetNotifier.selectedCodeSnippet.name;
      _textEditingControllerForMode.text = _snippetNotifier.selectedCodeSnippet.mode;
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
              controller: _textEditingControllerForName,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context).translate('enter_title'),
                hintStyle: TextStyle(color:  Theme.of(context).textTheme.display2.color),
              ),
              style: TextStyle(color:  Theme.of(context).textTheme.display1.color),
            ), 
            TextField(
              controller: _textEditingControllerForMode,
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
            if(_textEditingControllerForName.text.trim().length > 0){
                CodeSnippet codeSnippet = _snippetNotifier.selectedCodeSnippet;
                codeSnippet.name = _textEditingControllerForName.text;
                codeSnippet.mode = _textEditingControllerForMode.text;
                _snippetNotifier.selectedCodeSnippet = codeSnippet; //otherwise no rebuild
                _noteService.save(_noteNotifier.note);
                Navigator.of(context).pop();
            }
          })
        ];
    }
}
