import 'package:boostnote_mobile/business_logic/model/Folder.dart';
import 'package:flutter/material.dart';

class FolderNotifier with ChangeNotifier {

  Folder _selectedFolder; //Folder selected by long press on folder list tile
  List<Folder> _folders;

  Folder get selectedFolder => _selectedFolder;

  List<Folder> get folders => _folders;

  set selectedFolder(Folder selectedFolder) {
    _selectedFolder = selectedFolder;
    notifyListeners();
  }

  set folders(List<Folder> folders) {
    _folders = folders;
    notifyListeners();
  }

}