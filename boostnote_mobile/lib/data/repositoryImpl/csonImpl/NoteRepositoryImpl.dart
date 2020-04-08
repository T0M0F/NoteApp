import 'dart:io';

import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:boostnote_mobile/business_logic/repository/FolderRepository.dart';
import 'package:boostnote_mobile/business_logic/repository/NoteRepository.dart';
import 'package:boostnote_mobile/business_logic/service/FolderService.dart';
import 'package:boostnote_mobile/data/CsonParser.dart';
import 'package:boostnote_mobile/data/IdGenerator.dart';
import 'package:boostnote_mobile/data/repositoryImpl/jsonImpl/FolderRepositoryImpl.dart';
import 'package:path_provider/path_provider.dart';

class NoteRepositoryImpl extends NoteRepository {
 
  CsonParser csonParser = CsonParser();
  FolderRepository _folderRepository = FolderRepositoryImpl();

  Future<Directory> get directory async {     //TODO Extract
    final Directory dir = await getExternalStorageDirectory();
   
    Directory noteDirectory = Directory(dir.path + '/notes');
    bool dirExists = await noteDirectory.exists();
    if(!dirExists) {
     noteDirectory.createSync();
    }
  
    return noteDirectory;
  }

  Future<String> get localPath async {
    final Directory dir = await directory;
    return dir.path;
  }

 @override
  void delete(Note note) {
    print('delete');
    deleteById(note.id);
  }

  @override
  void deleteAll(List<Note> notes) {
    print('deleteAll');
    notes.forEach((note) => delete(note));
  }

  @override
  Future<void> deleteById(String id) async {
    print('deleteById');
    final List<Note> notes = await findAll();
    Note noteToBeRemoved = notes.firstWhere((note) => note.id == id, orElse: () => null);
    if(noteToBeRemoved != null) {
      String path = await localPath;
      File file = File(path + '/' + noteToBeRemoved.id.toString() + '.cson');
      file.exists().then((exists) {
        if(exists) {
          file.delete(); 
        }
      });
    }
  }

  @override
  Future<List<Note>> findAll() async {
    print('findAll');
    final Directory dir = await directory;

    return dir.list().toList().then((List<FileSystemEntity> list) async {
      List<String> paths = List();
      list.forEach((entity) => paths.add(entity.path));
      List<File> _files = List();
      paths.forEach((path) => _files.add(File(path)));
      print(_files.length.toString() + ' notes found');
      List<Note> notes = await _extractNotes(_files);
      return Future.value(notes);
    }); 
  }

  Future<List<Note>> _extractNotes(List<File> _files) async {
    List<Note> notes = List();
    
    await Future.forEach(_files, (file) async {
      String content = file.readAsStringSync();
      try {
        print('Reading');
        Note note = await csonParser.convertToNote(csonParser.parseCson(content, file.path.split('/').last));
        notes.add(note);
      } catch(e) {
        print(e);
      }
     
    });

    return Future.value(notes);
  }

  @override
  Future<Note> findById(String id) async {
    print('findById');
    final List<Note> notes = await findAll();
    return Future.value(notes.firstWhere((note) => note.id == id));
  }

  @override
  Future<void> save(Note note) async {
    String path = await localPath;
    if(note.folder == null || note.folder.name == null) { //Service oder Repo Ebene?
      note.folder = await FolderService().findDefaultFolder();
    } 
    if(note.isTrashed) {
      note.folder = await FolderService().findTrashFolder();
    }
    if(note.id == null) {
      note.id =  IdGenerator().generateNoteId();
    }
    File file = File(path + '/' + note.id + '.cson');
    bool fileExists = await file.exists();
    if(!fileExists) {
      print('File does not yet exist');
      print(note.createdAt);
      file.create();
    } 
    _folderRepository.save(note.folder);

    print('cson: ' + csonParser.convertToCson(note));
    file.writeAsString(csonParser.convertToCson(note));
  }

  @override
  void saveAll(List<Note> notes) {
    print('saveAll');
    print(notes.length.toString() + ' notes to save');
    notes.forEach((note) => save(note));
  }

}