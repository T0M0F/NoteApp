import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:boostnote_mobile/presentation/theme/ThemeService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
 
class CodeTab extends StatefulWidget{
 
  final CodeSnippet _codeSnippet;
  bool _editMode;
  Function(String) _callback;
  Function() _modeChange;

  CodeTab(this._codeSnippet, this._editMode, this._callback, this._modeChange);

  @override
  State<StatefulWidget> createState() => CodeTabState();
  
}
  
class CodeTabState extends State<CodeTab> {

  @override
  void initState(){
    super.initState();

  }
  
  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();
    textEditingController.text = this.widget._codeSnippet.content;

    return this.widget._editMode ? 
      Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
        child: TextField(
          autofocus: true,
          autocorrect: true,
          style: Theme.of(context).textTheme.display1,
          controller: textEditingController,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          minLines: 30, //TODO anpassen an höhe
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0),
            border: InputBorder.none),
          onChanged: (String text){
            this.widget._callback(text);
          },
          onEditingComplete: (){
            print('EDITING COMPLETED');
          },
          onSubmitted: (text){
            print('SUBMITTED');
          },
        ),
      ) :
      Stack(
        children: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: (){
              setState(() {
                this.widget._editMode = !this.widget._editMode;
                this.widget._modeChange();
              });
            },
            child: FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                height: 800,   //TODO height auf bildschirm - header und appbar anpassen
              ),
            )
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: (){
              setState(() {
                this.widget._editMode = !this.widget._editMode;
                this.widget._modeChange();
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
              child: HighlightView(
                this.widget._codeSnippet.content,
                language: this.widget._codeSnippet.mode,
                theme: ThemeService().getEditorTheme(context),
                textStyle: TextStyle(
                            fontFamily: 'My awesome monospace font',
                            fontSize: 16,
                            color: Theme.of(context).textTheme.display1.color,
                )
              )
            )
          ),
        ],
      );
  }
}