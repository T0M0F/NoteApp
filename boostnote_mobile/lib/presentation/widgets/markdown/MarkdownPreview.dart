
import 'dart:convert';

import 'package:boostnote_mobile/presentation/widgets/markdown/NewSyntaxHighlighter.dart';
import 'package:boostnote_mobile/presentation/widgets/markdown/SyntaxHighlighter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart' ;
import 'package:markdown/markdown.dart';

class MarkdownPreview extends StatefulWidget {

  final String _text;
  final Function(String) launchUrlCallback;

  MarkdownPreview(this._text, this.launchUrlCallback); //TODO: Constructor

  @override
  State<StatefulWidget> createState() => MarkdownPreviewState();
  
}
  
class MarkdownPreviewState extends State<MarkdownPreview>{

  @override
  Widget build(BuildContext context) {
    List<String> languages = _detectLanguage(this.widget._text);
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
        child: MarkdownBody(
          data: this.widget._text,
          syntaxHighlighter: NewSyntaxHighlighter(
            textStyle: TextStyle(
                            fontFamily: 'My awesome monospace font',
                            fontSize: 16,
                            color: Theme.of(context).textTheme.display1.color),
            languages: languages,
            context: context
          ),
          styleSheet: MarkdownStyleSheet(
            checkbox:  TextStyle(color: Theme.of(context).textTheme.display1.color, fontSize: 19),
            p: TextStyle(color: Theme.of(context).textTheme.display1.color, fontSize: 16),
            code: TextStyle(color: Theme.of(context).textTheme.display1.color, backgroundColor: Theme.of(context).dialogBackgroundColor),
            codeblockDecoration: BoxDecoration(color: Theme.of(context).dialogBackgroundColor),
            blockquoteDecoration: BoxDecoration(color: Theme.of(context).dialogBackgroundColor),
            blockquote: TextStyle(color: Theme.of(context).textTheme.display1.color),
            tableCellsDecoration: BoxDecoration(color: Theme.of(context).dialogBackgroundColor),
            tableBorder: TableBorder(
              bottom: BorderSide(color: Theme.of(context).textTheme.display3.color),
              top: BorderSide(color: Theme.of(context).textTheme.display3.color),
              left: BorderSide(color: Theme.of(context).textTheme.display3.color),
              right: BorderSide(color: Theme.of(context).textTheme.display3.color),
              horizontalInside: BorderSide(color: Theme.of(context).textTheme.display3.color),
              verticalInside: BorderSide(color: Theme.of(context).textTheme.display3.color)
            )


            /*
            p: TextStyle(color: Theme.of(context).textTheme.display1.color, fontSize: 16),
            code: TextStyle(color: Theme.of(context).accentTextTheme.display4.color),
            codeblockDecoration: BoxDecoration(
              color: Colors.grey,
            )*/
          ),
          onTapLink: (String url){
            this.widget.launchUrlCallback(url);
          },
          extensionSet: ExtensionSet.gitHubFlavored,
         
          selectable: true,
          
        )
      )
    );
  }

  List<String> _detectLanguage(String text) {  //TODO Escaping
    List<String> languages = List();
    List<String> splittedByLine = LineSplitter.split(text).toList();
    bool nextIsStartOfCodeBlock = true;  //start of codeblock

    splittedByLine.forEach((line) {
      if(line.contains('```') && nextIsStartOfCodeBlock){
        languages.add(line.replaceAll('```', '').trim());
        nextIsStartOfCodeBlock = false;
      } else if(line.contains('```') && !nextIsStartOfCodeBlock){
        nextIsStartOfCodeBlock = true;
      }
    });

    return languages;
  }
}
