
import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteNotifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MarkdownBody extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _MarkdownBodyState();

}
  
class _MarkdownBodyState extends State<MarkdownBody>{

  TextEditingController _textEditingController;

  String _text;
  NoteNotifier _noteNotifier;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    _noteNotifier = Provider.of<NoteNotifier>(context);
    _text = (_noteNotifier.note as MarkdownNote).content;
    _textEditingController.text = _text;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
      child: TextField(
        autocorrect: true,
        style: Theme.of(context).textTheme.display1,
        controller: _textEditingController,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        minLines: 30, //TODO anpassen an höhe
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
            border: InputBorder.none,),
        onChanged: (String text){
          (_noteNotifier.note as MarkdownNote).content = text;
        },
      ),
    );
  }
  
}