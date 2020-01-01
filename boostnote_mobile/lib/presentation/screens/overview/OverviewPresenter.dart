
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

  void init() {
    /*
    List<Note> notes = _noteService.generateNotes(10);
    _overviewView.update(notes);
    */
  }

  void onCreateNotePressed(Note note){
    _noteService.save(note);
    refresh();
  }

   void delete(List<Note> selectedNotes) {
    _noteService.deleteAll(selectedNotes);
    refresh();
  }

  void refresh() {
    List<Note> notes = _noteService.findAll();
    _overviewView.update(notes);
  }

  void showAllNotes() {
    refresh();
  }

  void showTrashedNotes() {
    List<Note> notes = _noteService.findTrashed();
    _overviewView.update(notes);
  }

  void showStarredNotes() {
    List<Note> notes = _noteService.findStarred();
    _overviewView.update(notes);
  }

}