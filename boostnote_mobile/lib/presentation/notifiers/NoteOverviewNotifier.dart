import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:flutter/material.dart';

class NoteOverviewNotifier with ChangeNotifier {

  //GlobalKey<ScaffoldState> _drawerKey;
  bool _expandedTiles;
  bool _showListView;
  List<Note> _notes;
  List<Note> _notesCopy;
  Note _selectedNote; //selectecByLongPress
  String _pageTitle;

  NoteOverviewNotifier(this._expandedTiles, this._showListView);

  NoteOverviewNotifier.withNotes(this._expandedTiles, this._showListView, this._notes) {
    _notesCopy = List.from(_notes);
  }

  bool get showListView => _showListView;

  bool get expandedTiles => _expandedTiles;

  List<Note> get notes => _notes;

  List<Note> get notesCopy => _notesCopy;

  Note get selectedNote => _selectedNote;

  String get pageTitle => _pageTitle;

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

  set selectedNote(Note notes) {
    _selectedNote = notes;
    notifyListeners();
  }

  set pageTitle(String pageTitle) {
    _pageTitle = pageTitle;
    notifyListeners();
  }
}