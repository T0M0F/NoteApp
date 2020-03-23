
import 'package:boostnote_mobile/business_logic/model/Folder.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/presentation/navigation/NavigationService.dart';
import 'package:boostnote_mobile/presentation/screens/note_overview/OverviewView.dart';

class OverviewPresenter { //TODO delete?

  OverviewView _overviewView;
  NoteService _noteService;
  NavigationService _navigationService;
  Function() updateNotesCopy;
  
  OverviewPresenter(OverviewView _overview, updateNotesCopy){
    this._overviewView = _overview;
    _noteService = NoteService();
    _navigationService = NavigationService();
    this.updateNotesCopy = updateNotesCopy;
  }

  void loadAllNotes(){
    Future<List<Note>> notes = NoteService().findNotTrashed();
    notes.then((result) { 
     // _navigationService.noteListCache = result;
      _overviewView.update(result);
      updateNotesCopy();
    });
  }

  void loadNotesInFolder(Folder folder) {
    Future<List<Note>> notes = NoteService().findNotesIn(folder);
    notes.then((result) { 
      //_navigationService.noteListCache = result;
      _overviewView.update(result);
      updateNotesCopy();
    });
  }

  void loadNotesWithTag(String tag) {
    Future<List<Note>> notes = NoteService().findNotesByTag(tag);
    notes.then((result) { 
      //_navigationService.noteListCache = result;
      _overviewView.update(result);
      updateNotesCopy();
    });
  }

  void onCreateNotePressed(Note note){
    _noteService.createNote(note);
  }

  void trash(List<Note> selectedNotes) {
    _noteService.deleteAll(selectedNotes);    //TODO trash not delete
   // refresh();
  }

  void deleteForever(List<Note> selectedNotes) {
    _noteService.deleteAll(selectedNotes);
    _overviewView.update(List());
    updateNotesCopy();
  }

  /*void refresh() {
    _noteService.findNotTrashed().then((notes) {
      _overviewView.update(notes);
    });
  }*/

  void showAllNotes() {
    print('showAllNOtes');
   // refresh();
  }

  void showTrashedNotes() {
    _noteService.findTrashed().then((notes) => _overviewView.update(notes));
  }

  void showStarredNotes() {
    _noteService.findStarred().then((notes) => _overviewView.update(notes));
  }

}