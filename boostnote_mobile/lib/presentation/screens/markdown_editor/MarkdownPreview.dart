
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart' ;
import 'package:markdown/markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class MarkdownPreview extends StatefulWidget {

  final String _text;

  MarkdownPreview(this._text);

  @override
  State<StatefulWidget> createState() => MarkdownPreviewState();
  
  }
  
  class MarkdownPreviewState extends State<MarkdownPreview>{

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        child: MarkdownBody(
          data: this.widget._text,
          syntaxHighlighter: CustomSyntaxHighlighter(),
          styleSheet: MarkdownStyleSheet(p: TextStyle(color: Colors.black, fontSize: 16)),
          onTapLink: (String url){
            _launchURL(url);
          },
          extensionSet: ExtensionSet.gitHubFlavored,
        )
      )
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class CustomSyntaxHighlighter extends SyntaxHighlighter{

  @override
  TextSpan format(String source) {
    return TextSpan(
      style: TextStyle(color: Colors.blue),
      text: source
    );

    /* flutter_highlight 94
    TextSpan(
          style: _textStyle,
          children: _convert(highlight.parse(source, language: language).nodes),
        ),
        */
  }
}
/* _MarkdownWidgetState 195
  @override
  TextSpan formatText(MarkdownStyleSheet styleSheet, String code) {
    code = code.replaceAll(RegExp(r'\n$'), '');
    if (widget.syntaxHighlighter != null) {
      return widget.syntaxHighlighter.format(code);
    }
    return TextSpan(style: styleSheet.code, text: code);
  }
*/