import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:flutter/material.dart';

class SnippetNotifier with ChangeNotifier {

  CodeSnippet _selectedCodeSnippet;
  bool _isEditMode;

  SnippetNotifier(this._isEditMode);

  CodeSnippet get selectedCodeSnippet => _selectedCodeSnippet;

  bool get isEditMode => _isEditMode;

  set selectedCodeSnippet(CodeSnippet selectedCodeSnippet) {
    _selectedCodeSnippet = selectedCodeSnippet;
    notifyListeners();
  }

  set isEditMode(bool editMode) {
    _isEditMode = editMode;
    notifyListeners();
  }

}