import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:flutter/material.dart';

class NoteNotifier with ChangeNotifier {

  Note _note;

  Note get note=> _note;

  set note(Note note) {
    _note = note;
    notifyListeners();
  }

}