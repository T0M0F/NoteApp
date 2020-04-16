import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/SnippetNotifier.dart';
import 'package:boostnote_mobile/presentation/widget/buttons/CancelButton.dart';
import 'package:boostnote_mobile/presentation/widgets/buttons/SaveButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class SnippetDescriptionDialog extends StatefulWidget { 

  @override
  _SnippetDescriptionDialogState createState() => _SnippetDescriptionDialogState();
}

class _SnippetDescriptionDialogState extends State<SnippetDescriptionDialog> {

  NoteNotifier _noteNotifier;
  TextEditingController _textEditingController;

  @override
  Widget build(BuildContext context) {
    _noteNotifier = Provider.of<NoteNotifier>(context);
    _textEditingController = TextEditingController();
    _textEditingController.text = (_noteNotifier.note as SnippetNote).description;

    return AlertDialog(
      title: _buildTitle(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: _buildContent(),
      actions: _buildActions(context),
    );
  }

  Container _buildTitle() {
    return Container( 
      alignment: Alignment.center,
      child: Text(AppLocalizations.of(context).translate('description'), style: TextStyle(color: Theme.of(context).textTheme.display1.color))
    );
  }

  StatefulBuilder _buildContent() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return TextField(
            style: Theme.of(context).textTheme.display1,
            controller: _textEditingController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(0),
              border: InputBorder.none,
              hintText: AppLocalizations.of(context).translate('note')),
              onChanged: (String text){
            },
          );
      },
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return <Widget>[
      CancelButton(),
      SaveButton(save: () {
         (_noteNotifier.note as SnippetNote).description = _textEditingController.text;
         Navigator.of(context).pop();
      })
    ];
  }
}
