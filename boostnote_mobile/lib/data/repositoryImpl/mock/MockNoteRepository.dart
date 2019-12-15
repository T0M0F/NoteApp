import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/repository/NoteRepository.dart';

class MockNoteRepository implements NoteRepository{

  List<Note> _notes;
  static final MockNoteRepository repository = new MockNoteRepository._internal();

  MockNoteRepository._internal(){
    _notes = new List();
  }

  factory MockNoteRepository(){
    return repository;
  }

  @override
  void delete(Note note) {
    _notes.remove(note);
  }

  @override
  void deleteAll(List<Note> notes) {
    for(Note note in notes){
      if(_notes.contains(note)){
        _notes.remove(note);
      }
    }
  }

  @override
  void deleteById(int id) {
    List<Note> removeNotes = new List();

    for(Note note in _notes){
      if(note.id == id){
        removeNotes.add(note);
      }
    }

    _notes.remove(removeNotes);
  }

  @override
  List<Note> findAll() {
    return _notes;
  }

  @override
  Note findById(int id) {
    for(Note note in _notes){
      if(note.id == id){
        return note;
      }
    }
    return null;
  }

  @override
  void save(Note note) {
    _notes.add(note);
  }

  @override
  void saveAll(List<Note> notes) {
    _notes.addAll(notes);
  } 

}
