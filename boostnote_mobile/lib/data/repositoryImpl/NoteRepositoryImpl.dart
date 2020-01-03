import 'dart:convert';
import 'dart:io';

import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/repository/NoteRepository.dart';
import 'package:path_provider/path_provider.dart';

//TODO: Make functions async
class NoteRepositoryImpl extends NoteRepository {

  Directory _directory;
  List<File> _files;

  NoteRepositoryImpl() {
    getApplicationDocumentsDirectory().then((directory) {
      print('here');
      print(_directory);
      _directory = directory;
    });
  }

  @override
  void delete(Note note) {
    deleteById(note.id);
  }

  @override
  void deleteAll(List<Note> notes) {
    notes.forEach((note) => delete(note));
  }

  @override
  void deleteById(int id) {
    Note noteToBeRemoved = findAll().firstWhere((note) => note.id == id);
    File file = File(_directory.path + '/' + noteToBeRemoved.id.toString());
    file.exists().then((exists) {
      if(exists) {
       file.delete(); 
      }
    });
  }

  @override
  List<Note> findAll() {
    _directory.list().toList().then((List<FileSystemEntity> list) {
      List<String> paths = List();
      list.forEach((entity) => paths.add(entity.path));
      paths.forEach((path) => _files.add(File(path)));
      List<Note> notes = List();
      _files.forEach((file) => file.readAsString().then((content) {
        notes.add(jsonDecode(content));
     }));
     return notes;
   });
  }

  @override
  Note findById(int id) {
    return findAll().firstWhere((note) => note.id == id);
  }

  @override
  void save(Note note) {
    File file = File(_directory.path + '/' + note.id.toString());
    file.exists().then((exists){
      if(exists) {
        file.writeAsString(jsonEncode(note));
      } else {
        //TODO: Set id somewhere
        file.create();
      }
    });
  }

  @override
  void saveAll(List<Note> notes) {
    notes.forEach((note) => save(note));
  }
}