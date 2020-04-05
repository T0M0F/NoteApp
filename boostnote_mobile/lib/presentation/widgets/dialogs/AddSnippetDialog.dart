import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:boostnote_mobile/data/entity/SnippetNoteEntity.dart';
import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/SnippetNotifier.dart';
import 'package:boostnote_mobile/presentation/widgets/buttons/CancelButton.dart';
import 'package:boostnote_mobile/presentation/widgets/buttons/SaveButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class AddSnippetDialog extends StatelessWidget {  //TODO StatelessWidget or StatefulWidget?

  final TextEditingController controller = TextEditingController();
  NoteNotifier _noteNotifier;
  SnippetNotifier _snippetNotifier;

  @override
  Widget build(BuildContext context) {
    _noteNotifier = Provider.of<NoteNotifier>(context);
    _snippetNotifier = Provider.of<SnippetNotifier>(context);

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
      child: Text(
        AppLocalizations.of(context).translate('create_a_snippet'), 
        style: TextStyle(color: Theme.of(context).textTheme.display1.color),
      )
    );
  }


  Container _buildContent(BuildContext context) {
     return Container(
      height: 75,
      child: Column(
        children: <Widget>[
          TextField(
            controller: controller,
            style: TextStyle(color: Theme.of(context).textTheme.display1.color),
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context).translate('enter_name'),
              hintStyle: Theme.of(context).textTheme.display2
            ),
          ), 
        ],
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return <Widget>[
      CancelButton(),
      SaveButton(save: () {
        if(controller.text.trim().length > 0){
          _addSnippet(context);
        }
      })
    ];
  }

  void _addSnippet(BuildContext context) {
    List<String> s = controller.text.split('.');
    CodeSnippet codeSnippet = s.length > 1 
      ? CodeSnippetEntity(
            linesHighlighted: List(),  //TODO CodeSnippetEntity...
            name: s[0],
            mode: s[1],
            content: '')
      : CodeSnippetEntity(
            linesHighlighted: List(),  //TODO CodeSnippetEntity...
            name: controller.text,
            mode: '',
            content: '');
    (_noteNotifier.note as SnippetNote).codeSnippets.add(codeSnippet);
    _snippetNotifier.selectedCodeSnippet = codeSnippet;
    Navigator.of(context).pop();
  }   

}
