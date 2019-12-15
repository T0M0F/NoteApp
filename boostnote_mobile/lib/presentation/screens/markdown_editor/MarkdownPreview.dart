
import 'package:flutter/cupertino.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

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
      child: MarkdownBody(data: this.widget._text,
      )
    );
  }
}