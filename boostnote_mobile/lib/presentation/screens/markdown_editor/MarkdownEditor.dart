
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MarkdownEditor extends StatefulWidget{

  final String _text;
  final Function(String) callback;

  MarkdownEditor(this._text, this.callback);

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
      child: TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            controller: _textEditingController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "INPUT TEXT" 
            ),
            onChanged: (String text){
              setState(() {
                this.widget.callback(text);
              });
            },
          ),
    );
  }
  
}