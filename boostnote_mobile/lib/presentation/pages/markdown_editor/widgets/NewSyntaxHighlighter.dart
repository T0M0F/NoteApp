import 'dart:ui';

import 'package:boostnote_mobile/presentation/themes/ThemeService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:highlight/highlight.dart';

class NewSyntaxHighlighter extends SyntaxHighlighter{

  TextStyle textStyle;
  List<String> languages;
  BuildContext context;
  var theme;

  NewSyntaxHighlighter({@required this.context, @required this.textStyle, this.languages});

  @override
  TextSpan format(String source) {
    theme = ThemeService().getEditorTheme(context);

    String language = _getLanguage();

    List<Node> nodes = highlight.parse(source, language: language).nodes;
    return TextSpan(
      style: textStyle,
      children: _convertToTextSpan(nodes),
    );
  }

  String _getLanguage() {
    String language = 'Dart';
    if(languages != null && languages.isNotEmpty && languages.first.trim().isNotEmpty){
      language = languages.first;
    } 
    if(languages != null && languages.isNotEmpty) {
      languages.removeAt(0);
    }
    return language;
  }

  List<TextSpan> _convertToTextSpan(List<Node> nodes) {   
    List<TextSpan> spans = [];
    var currentSpans = spans;
    List<List<TextSpan>> stack = [];

    nodes.forEach((node) => _traverse(node, currentSpans, stack, spans));

    return spans;
  }

  void _traverse(Node node, List<TextSpan> currentSpans, List<List<TextSpan>> stack, List<TextSpan> spans) {
    if (node.value != null) {
      currentSpans.add(node.className == null
          ? TextSpan(text: node.value)
          : TextSpan(text: node.value, style: theme[node.className]));
    } else if (node.children != null) {
      List<TextSpan> tmp = [];
      currentSpans.add(TextSpan(children: tmp, style: theme[node.className]));
      stack.add(currentSpans);
      currentSpans = tmp;
    
      node.children.forEach((n) {
        _traverse(n, currentSpans, stack, spans);
        if (n == node.children.last) {
          currentSpans = stack.isEmpty ? spans : stack.removeLast();
        }
      });
    }
  }

}
