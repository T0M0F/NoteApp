import 'package:flutter/material.dart';

class TagsNotifier with ChangeNotifier {

  String _selectedTag;  //selected by long press or by tap
  List<String> _tags;

  String get selectedTag => _selectedTag;

  List<String> get tags => _tags;

  set selectedTag(String currentTag) {
    _selectedTag = currentTag;
    notifyListeners();
  }

  set tags(List<String> tags) {
    _tags = tags;
    notifyListeners();
  }

}