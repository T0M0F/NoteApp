import 'package:flutter/material.dart';

class TagsNotifier with ChangeNotifier {

  String _currentTag;
  List<String> _tags;

  String get currentTag => _currentTag;

  List<String> get tags => _tags;

  set currentTag(String currentTag) {
    _currentTag = currentTag;
    notifyListeners();
  }

  set isEditMode(List<String> tags) {
    _tags = tags;
    notifyListeners();
  }

}