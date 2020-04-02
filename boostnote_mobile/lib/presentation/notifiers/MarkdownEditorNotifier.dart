import 'package:boostnote_mobile/business_logic/model/Folder.dart';
import 'package:flutter/material.dart';

class MarkdownEditorNotifier with ChangeNotifier {

  bool _isPreviewMode;
  Folder _selectedDropdownFolder;
  List<Folder> _folders;

  MarkdownEditorNotifier(this._isPreviewMode);

  bool get isPreviewMode => _isPreviewMode;

  Folder get selectedFolder => _selectedDropdownFolder;

  List<Folder> get folders => _folders;

  set isPreviewMode(bool editMode) {
    _isPreviewMode = editMode;
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