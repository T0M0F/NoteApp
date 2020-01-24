
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MarkdownEditor extends StatefulWidget{

  final String _text;
  final Function(String) onChangedCallback;

  MarkdownEditor(this._text, this.onChangedCallback); //TODO: Constructor

  @override
  State<StatefulWidget> createState() => _MarkdownEditorState();

}
  
class _MarkdownEditorState extends State<MarkdownEditor>{

  TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    _textEditingController.text = this.widget._text;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      color: Colors.red,
      child: TextField(
        autocorrect: true,
        style: TextStyle(),
        controller: _textEditingController,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
            border: InputBorder.none,
            hintText: 'Note'),
        onChanged: (String text){
              this.widget.onChangedCallback(text);
        },
      ),
    );
  }
  
}