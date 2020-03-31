import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:flutter/material.dart';

class NoteOverviewNotifier with ChangeNotifier {

  //GlobalKey<ScaffoldState> _drawerKey;
  bool _expandedTiles;
  bool _showListView;
  List<Note> _notes;
  List<Note> _notesCopy;
  List<Note> _selectedNotes;

  NoteOverviewNotifier(this._expandedTiles, this._showListView);

  NoteOverviewNotifier.withNotes(this._expandedTiles, this._showListView, this._notes) {
    _notesCopy = List.from(_notes);
  }

  //GlobalKey<ScaffoldState> get drawerKey => _drawerKey;

  bool get showListView => _showListView;

  bool get expandedTiles => _expandedTiles;

  List<Note> get notes => _notesCopy;

  List<Note> get notesCopy => _notesCopy;

  List<Note> get selectedNotes => _selectedNotes;

 /* set drawerKey(GlobalKey<ScaffoldState> drawerKey) {
    _drawerKey = drawerKey;
    notifyListeners();
  }*/

  set showListView(bool showListVIew) {
    _showListView = showListVIew;
    notifyListeners();
  }

  set expandedTiles(bool expandedTiles) {
    _expandedTiles = expandedTiles;
    notifyListeners();
  }

  set notes(List<Note> notes) {
    _notes = notes;
    notifyListeners();
  }

  set notesCopy(List<Note> notes) {
    _notesCopy = notes;
    notifyListeners();
  }

  set selectedNotes(List<Note> notes) {
    _selectedNotes = notes;
    notifyListeners();
  }
}