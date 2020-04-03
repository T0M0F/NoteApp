import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:flutter/material.dart';

class NoteNotifier with ChangeNotifier {

  Note _note;

  Note get note=> _note;

  set note(Note note) {
    if(note == null && _note != null) {
      NoteService().save(_note);
    }
    _note = note;
    notifyListeners();
  }

}