import 'package:boostnote_mobile/business_logic/model/Folder.dart';
import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:flutter/material.dart';

class SnippetNotifier with ChangeNotifier {

  CodeSnippet _selectedCodeSnippet;
  bool _isEditMode;
  Folder _selectedDropdownFolder;
  List<Folder> _folders;

  SnippetNotifier(this._isEditMode);

  CodeSnippet get selectedCodeSnippet => _selectedCodeSnippet;

  bool get isEditMode => _isEditMode;
  
  Folder get selectedFolder => _selectedDropdownFolder;

  List<Folder> get folders => _folders;

  set selectedCodeSnippet(CodeSnippet selectedCodeSnippet) {
    _selectedCodeSnippet = selectedCodeSnippet;
    notifyListeners();
  }

  set isEditMode(bool editMode) {
    _isEditMode = editMode;
    notifyListeners();
  }

  set selectedFolder(Folder selectedDropdownFolder) {
    _selectedDropdownFolder = selectedDropdownFolder;
    notifyListeners();
  }

  set folders(List<Folder> folders) {
    _folders = folders;
    notifyListeners();
  }

}