
import 'package:boostnote_mobile/business_logic/model/Folder.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/presentation/NavigationService.dart';
import 'package:boostnote_mobile/presentation/screens/overview/OverviewView.dart';
import 'package:boostnote_mobile/presentation/widgets/NavigationDrawer.dart';

class OverviewPresenter {

  OverviewView _overviewView;
  NoteService _noteService;
  
  OverviewPresenter(OverviewView _overview){
    this._overviewView = _overview;
    _noteService = NoteService();
  }

  void loadAllNotes(){
    print('loadAllNotes');
    Future<List<Note>> notes = NoteService().findNotTrashed();
    notes.then((result) { 
      _overviewView.update(result);
    });
  }

  void loadNotesInFolder(Folder folder) {
    print('loadNotesInFolder');
    Future<List<Note>> notes = NoteService().findNotesIn(folder);
    notes.then((result) { 
      _overviewView.update(result);
    });
  }

  void loadNotesWithTag(String tag) {
    print('loadNotesWithTag');
    Future<List<Note>> notes = NoteService().findNotesByTag(tag);
    notes.then((result) { 
      _overviewView.update(result);
    });
  }

/*
  void loadNotes(int mode) {
    print('laodnotes mode: ' + mode.toString());
    switch (mode) {
      case NaviagtionDrawerAction.ALL_NOTES:
      print('ALLNOTES');
        Future<List<Note>> notes = NoteService().findNotTrashed();
        notes.then((result) { 
          result.forEach((note) => print('note: ' + note.title + ' ' + note.id.toString()));
          _overviewView.update(result);
        });
        break;
      case NaviagtionDrawerAction.TRASH:
        Future<List<Note>> notes = NoteService().findTrashed();
        notes.then((result) { 
          result.forEach((note) => print('note: ' + note.title + ' ' + note.id.toString()));
          _overviewView.update(result);
        });
        break;
      case NaviagtionDrawerAction.STARRED:
        Future<List<Note>> notes = NoteService().findStarred();
        notes.then((result) { 
          result.forEach((note) => print('note: ' + note.title + ' ' + note.id.toString()));
          _overviewView.update(result);
        });
        break;
      default:
      print('ALLNOTES');
        Future<List<Note>> notes = NoteService().findNotTrashed();
        notes.then((result) { 
          result.forEach((note) => print('note: ' + note.title + ' ' + note.id.toString()));
          _overviewView.update(result);
        });
        break;
    }
    
  }*/

  void onCreateNotePressed(Note note){
    print('Create Note');
    _noteService.createNote(note);
    refresh();
  }

   void delete(List<Note> selectedNotes) {
    _noteService.deleteAll(selectedNotes);
    refresh();
  }

  void refresh() {
    _noteService.findNotTrashed().then((notes) => _overviewView.update(notes));
  }

  void showAllNotes() {
    print('showAllNOtes');
    refresh();
  }

  void showTrashedNotes() {
     print('showTrashedNOtes');
    _noteService.findTrashed().then((notes) => _overviewView.update(notes));
  }

  void showStarredNotes() {
     print('showStarredNOtes');
    _noteService.findStarred().then((notes) => _overviewView.update(notes));
  }

}