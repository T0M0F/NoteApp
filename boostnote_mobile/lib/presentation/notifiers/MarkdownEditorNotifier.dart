import 'package:flutter/material.dart';

class MarkdownEditorNotifier with ChangeNotifier {

  bool _isPreviewMode;

  MarkdownEditorNotifier(this._isPreviewMode);

  bool get isPreviewMode => _isPreviewMode;

  set isPreviewMode(bool editMode) {
    _isPreviewMode = editMode;
    notifyListeners();
  }

}