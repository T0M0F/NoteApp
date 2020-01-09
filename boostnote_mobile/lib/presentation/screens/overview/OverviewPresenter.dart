
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/presentation/screens/overview/OverviewView.dart';

class OverviewPresenter {

  OverviewView _overviewView;
  NoteService _noteService;
  
  OverviewPresenter(OverviewView _overview){
    this._overviewView = _overview;
    _noteService = NoteService();
  }

  void loadNotes() {
    Future<List<Note>> notes = NoteService().findNotTrashed();
    notes.then((result) { 
      result.forEach((note) => print('note: ' + note.title + ' ' + note.id.toString()));
      _overviewView.update(result);
    });
  }

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