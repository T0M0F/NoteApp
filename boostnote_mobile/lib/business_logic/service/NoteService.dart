import 'package:boostnote_mobile/business_logic/model/Folder.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/repository/NoteRepository.dart';
import 'package:boostnote_mobile/data/repositoryImpl/csonImpl/NoteRepositoryImpl.dart';

class NoteService {

  NoteRepository _noteRepository = NoteRepositoryImpl();

  Future<List<Note>> findAll() {
    return _noteRepository.findAll();
  }

  Future<List<Note>> findNotTrashed() async {
    List<Note> notes = await _noteRepository.findAll();
    List<Note> notTrashedNotes = List();
      notes.forEach((note) {
        if(!note.isTrashed) {
          notTrashedNotes.add(note);
        }
    });
    notTrashedNotes.sort((a,b) => b.updatedAt.compareTo(a.updatedAt));
    return notTrashedNotes;
  }

  Future<List<Note>> findStarred() async { 
    List<Note> notes = await _noteRepository.findAll();
    List<Note> starredNotes = List();
      notes.forEach((note) {
        if(note.isStarred) {
          starredNotes.add(note);
        }
    });
    starredNotes.sort((a,b) => b.updatedAt.compareTo(a.updatedAt));
    return starredNotes;
  }

  Future<List<Note>> findTrashed() async { 
    List<Note> notes = await _noteRepository.findAll();
    List<Note> trashedNotes = List();
      notes.forEach((note) {
        if(note.isTrashed) {
          trashedNotes.add(note);
        }
    });
    trashedNotes.sort((a,b) => b.updatedAt.compareTo(a.updatedAt));
    return trashedNotes;
  }

  Future<List<Note>> findNotesIn(Folder folder) async {  
    if(folder == null) {
      throw Exception('Folder should not be null');
    }
    List<Note> notes = await _noteRepository.findAll();
    List<Note> filteredNotes = List();
      notes.forEach((note) {
        if(note.folder.id == folder.id) {
          filteredNotes.add(note);
        }
    });
    filteredNotes.sort((a,b) => b.updatedAt.compareTo(a.updatedAt));
    return filteredNotes;
  }

  Future<List<Note>> findUntrashedNotesIn(Folder folder) async {   
    List<Note> notes = await _noteRepository.findAll();
    List<Note> filteredNotes = List();
      notes.forEach((note) {
        if(note.folder.id == folder.id && note.isTrashed == false) {
          filteredNotes.add(note);
        }
    });
    filteredNotes.sort((a,b) => b.updatedAt.compareTo(a.updatedAt));
    return filteredNotes;
  }

  findNotesByTag(String tag) async {
    if(tag == null) {
      throw Exception('Tag should not be null');
    }
    List<Note> notes = await _noteRepository.findAll();
    List<Note> filteredNotes = List();
      notes.forEach((note) {
        if(note.tags.contains(tag) && note.isTrashed == false) {
          filteredNotes.add(note);
        }
    });
    filteredNotes.sort((a,b) => b.updatedAt.compareTo(a.updatedAt));
    return filteredNotes;
  }

  Future<void> createNote(Note note) async{  
    if(note == null) {
      throw Exception('Note must not be null');
    }
    save(note);
  }

  void save(Note note) {  //TODO check if note already exists, if it doesnt exist throw exception -> use createNote method instead
    note.updatedAt = DateTime.now();
    _noteRepository.save(note);
  }

  void saveAll(List<Note> notes) {
    _noteRepository.saveAll(notes);
  }

  void restore(Note note) {
    note.isTrashed = false;
    note.folder.name = 'Default';
    save(note);
  }

  void moveToTrash(Note note) {
    note.isTrashed = true;
    note.isStarred = false;
    save(note);
  }

  void moveAllToTrash(List<Note> notes) {
    notes.forEach((note) => moveToTrash(note));
  }

  void delete(Note note) {
    _noteRepository.delete(note);
  }

  void deleteAll(List<Note> notes) {
    _noteRepository.deleteAll(notes);
  }
  
}