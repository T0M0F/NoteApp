
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MarkdownBody extends StatefulWidget{

  final String _text;
  final Function(String) onChangedCallback;

  MarkdownBody(this._text, this.onChangedCallback); //TODO: Constructor

  @override
  State<StatefulWidget> createState() => _MarkdownBodyState();

}
  
class _MarkdownBodyState extends State<MarkdownBody>{

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
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
      child: TextField(
        autocorrect: true,
        style: Theme.of(context).textTheme.display1,
        controller: _textEditingController,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        minLines: 30,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
            border: InputBorder.none,),
        onChanged: (String text){
            this.widget.onChangedCallback(text);
        },
      ),
    );
  }
  
}