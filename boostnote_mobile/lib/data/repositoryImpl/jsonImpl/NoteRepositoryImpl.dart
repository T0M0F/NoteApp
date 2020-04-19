import 'dart:convert';
import 'dart:io';

import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:boostnote_mobile/business_logic/repository/FolderRepository.dart';
import 'package:boostnote_mobile/business_logic/repository/NoteRepository.dart';
import 'package:boostnote_mobile/data/IdGenerator.dart';
import 'package:boostnote_mobile/data/entity/FolderEntity.dart';
import 'package:boostnote_mobile/data/entity/MarkdownNoteEntity.dart';
import 'package:boostnote_mobile/data/entity/SnippetNoteEntity.dart';
import 'package:boostnote_mobile/data/repositoryImpl/jsonImpl/FolderRepositoryImpl.dart';
import 'package:path_provider/path_provider.dart';

@Deprecated('Use NoteRepositoryImpl in csonImpl Package instead.')
class NoteRepositoryImpl extends NoteRepository {

  FolderRepository _folderRepository = FolderRepositoryImpl();

  Future<Directory> get directory async {
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
    deleteById(note.id);
  }

  @override
  void deleteAll(List<Note> notes) {
    notes.forEach((note) => delete(note));
  }

  @override
  void deleteById(String id) async {
    final List<Note> notes = await findAll();
    Note noteToBeRemoved = notes.firstWhere((note) => note.id == id, orElse: () => null);
    if(noteToBeRemoved != null) {
      String path = await localPath;
      File file = File(path + '/' + noteToBeRemoved.id.toString() + '.json');
      file.exists().then((exists) {
        if(exists) {
          file.delete(); 
        }
      });
    }
  }

  @override
  Future<List<Note>> findAll() async {
    final Directory dir = await directory;

    return dir.list().toList().then((List<FileSystemEntity> list) async {
      List<String> paths = List();
      list.forEach((entity) => paths.add(entity.path));
      List<File> _files = List();
      paths.forEach((path) => _files.add(File(path)));
      List<Note> notes = await _extractNotes(_files);
      return Future.value(notes);
    }); 
  }

  Future<List<Note>> _extractNotes(List<File> _files) async {
    List<Note> notes = List();
    _files.forEach((file) {
      String content = file.readAsStringSync();
      Map<String, dynamic> map = jsonDecode(content); 
      if(map.containsKey('codeSnippets')) {
        notes.add(SnippetNoteEntity.fromJson(map));
      } else {
        notes.add(MarkdownNoteEntity.fromJson(map));
      }
    });
    return Future.value(notes);
  }

  @override
  Future<Note> findById (String id) async {
    final List<Note> notes = await findAll();
    return Future.value(notes.firstWhere((note) => note.id == id));
  }

  @override
  void save(Note note) async {
  note.id = IdGenerator().generateNoteId();

    if(note is MarkdownNote) {
      MarkdownNote markdownNote = note;
      note = MarkdownNoteEntity(
        id: note.id,
        createdAt: note.createdAt,
        updatedAt: note.updatedAt,
        folder: FolderEntity(name: note.folder.name, id: note.folder.id),
        title: note.title,
        tags: note.tags,
        isStarred: note.isStarred,
        isTrashed: note.isTrashed,
        content: markdownNote.content
      );
    } else {

      List<CodeSnippetEntity> codeSnippetEntities = List();
      SnippetNote snippetNote = note;
      snippetNote.codeSnippets.forEach((codeSnippet) => codeSnippetEntities.add(
        CodeSnippetEntity(
          linesHighlighted: codeSnippet.linesHighlighted,
          name: codeSnippet.name,
          mode: codeSnippet.mode,
          content: codeSnippet.content
        )
      ));

      note = SnippetNoteEntity(
        id: note.id,
        createdAt: note.createdAt,
        updatedAt: note.updatedAt,
        folder: FolderEntity(name: note.folder.name, id: note.folder.id),
        title: note.title,
        tags: note.tags,
        isStarred: note.isStarred,
        isTrashed: note.isTrashed,
        description: snippetNote.description,
        codeSnippets: codeSnippetEntities
      );
    }
    
    String path = await localPath;
    File file = File(path + '/' + note.id.toString() + '.json');
    bool fileExists = await file.exists();
    if(fileExists) {
      file.writeAsString(jsonEncode(note));
    } else {
      file = File(path + '/' + note.id.toString());
      file.create();
      if(note is MarkdownNoteEntity) {
        MarkdownNoteEntity markdownNoteEntity = note;
        file.writeAsString(jsonEncode(markdownNoteEntity.toJson()));
      } else {
        SnippetNoteEntity snippetNoteEntity = note;
        file.writeAsString(jsonEncode(snippetNoteEntity.toJson()));
      }
    } 

    _folderRepository.save(note.folder);
  }

  @override
  void saveAll(List<Note> notes) {
    notes.forEach((note) => save(note));
  }
}