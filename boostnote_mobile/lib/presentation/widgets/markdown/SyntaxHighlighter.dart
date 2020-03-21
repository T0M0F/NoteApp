import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/a11y-light.dart';
import 'package:flutter_highlight/themes/darcula.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:highlight/highlight.dart';

class CustomSyntaxHighlighter extends SyntaxHighlighter{
  var theme = darculaTheme;

  @override
  TextSpan format(String source) {
  


    Highlight highlight = Highlight();
    Result result = highlight.parse(source, autoDetection: true);

    const _defaultFontFamily = 'monospace';
    const _rootKey = 'root';
   const _defaultFontColor = Color(0xff000000);
   const _defaultBackgroundColor = Color(0xffffffff);
   var textStyle = TextStyle(
                    fontFamily: 'My awesome monospace font',
                    fontSize: 16,
        );
     var _textStyle = TextStyle(
      fontFamily: _defaultFontFamily,
      color: theme[_rootKey]?.color ?? _defaultFontColor,
    );
    if (textStyle != null) {
      _textStyle = _textStyle.merge(textStyle);
    }

    return TextSpan(
      style: _textStyle,
      children: _convert(result.nodes)
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
            : TextSpan(text: node.value, style: theme[node.className])); //theme[node.className]
      } else if (node.children != null) {
        List<TextSpan> tmp = [];
        currentSpans.add(TextSpan(children: tmp, style: theme[node.className]));  //theme[node.className]
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
