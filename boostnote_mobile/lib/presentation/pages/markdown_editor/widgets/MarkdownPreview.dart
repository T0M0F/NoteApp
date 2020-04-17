
import 'dart:convert';
import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteNotifier.dart';
import 'package:boostnote_mobile/presentation/pages/markdown_editor/widgets/NewSyntaxHighlighter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart' ;
import 'package:markdown/markdown.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MarkdownPreview extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MarkdownPreviewState();
}
  
class MarkdownPreviewState extends State<MarkdownPreview>{

  String _text;
  NoteNotifier _noteNotifier;

  @override
  Widget build(BuildContext context) {
    _initNotifier(context);
    return _buildWidget(context);
  }

  void _initNotifier(BuildContext context) {
    _noteNotifier = Provider.of<NoteNotifier>(context);
  }

  SingleChildScrollView _buildWidget(BuildContext context) {
    _text = (_noteNotifier.note as MarkdownNote).content;
    List<String> languages = _detectLanguage(_text);
    
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
        child: MarkdownBody(
          data: _text,
          syntaxHighlighter: NewSyntaxHighlighter(
            textStyle: TextStyle(
                            fontFamily: 'My awesome monospace font',
                            fontSize: 16,
                            color: Theme.of(context).textTheme.display1.color),
            languages: languages,
            context: context
          ),
          styleSheet: _getStyleSheet(context),
          onTapLink: (String url) => _launchURL(url),
          extensionSet: ExtensionSet.gitHubFlavored,  
        )
      )
    );
  }

  MarkdownStyleSheet _getStyleSheet(BuildContext context) {
    return MarkdownStyleSheet(
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
        );
  }

  List<String> _detectLanguage(String text) {  
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

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
