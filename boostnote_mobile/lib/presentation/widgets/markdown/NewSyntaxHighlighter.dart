import 'dart:ui';

import 'package:boostnote_mobile/presentation/theme/ThemeService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/a11y-light.dart';
import 'package:flutter_highlight/themes/a11y-dark.dart';
import 'package:flutter_highlight/themes/atelier-heath-dark.dart';
import 'package:flutter_highlight/themes/darcula.dart';
import 'package:flutter_highlight/themes/atelier-forest-dark.dart';
import 'package:flutter_highlight/themes/arduino-light.dart';
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
    String language = 'Dart';
    theme = ThemeService().getEditorTheme(context);

    if(languages != null && languages.isNotEmpty && languages.first.trim().isNotEmpty){
      language = languages.first;
    } 
    if(languages != null && languages.isNotEmpty) {
      languages.removeAt(0);
    }
    return TextSpan(
      style: textStyle,
      children: _convert(highlight.parse(source, language: language).nodes),
    );
  }

  
 List<TextSpan> _convert(List<Node> nodes) {
    List<TextSpan> spans = [];
    var currentSpans = spans;
    List<List<TextSpan>> stack = [];

    _traverse(Node node) {
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
          _traverse(n);
          if (n == node.children.last) {
            currentSpans = stack.isEmpty ? spans : stack.removeLast();
          }
        });
      }
    }

    for (var node in nodes) {
      _traverse(node);
    }

    return spans;
  }
}
