
import 'dart:convert';
import 'dart:io';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/repository/TagRepository.dart';
import 'package:boostnote_mobile/data/entity/BoostnoteEntity.dart';
import 'package:boostnote_mobile/data/repositoryImpl/csonImpl/NoteRepositoryImpl.dart';
import 'package:path_provider/path_provider.dart';

class TagRepositoryImpl implements TagRepositoryV2{

  Future<Directory> get directory async {
    final Directory dir = await getExternalStorageDirectory();
    return dir;
  }
  
  Future<File> get localFile async {      //TODO: Merge with BN FolderRepo, weil wenn, das hier aufgerufen wird, bevor getter vom FolderRepo -> Problem
    final Directory dir = await directory;
    File file = File(dir.path + '/boostnote.json');
    bool fileExists = await file.exists();
    if(!fileExists){
      print('Boostnote File doesnt exist');
      file.createSync();
      BoostnoteEntity boostnoteEntity = BoostnoteEntity(folders: List());
      file.writeAsStringSync(jsonEncode(boostnoteEntity));
      file = await localFile;
    }
    return file;
  }

  Future<BoostnoteEntity> get boostnoteEntity async  {  //TODO move in extra class
    final File file = await localFile;
    String content = file.readAsStringSync();
    print('Boostnote file content: ' + content);
    BoostnoteEntity boostnoteEntity = BoostnoteEntity.fromJson(jsonDecode(content));
    if(boostnoteEntity.tags == null){
      print('Tags are null');
      boostnoteEntity.tags = List();
    }
    return Future.value(boostnoteEntity);
  }
  
  @override
  Future<List<String>> findAll() async {
    List<String> tags = List();
    List<Note> notes = await NoteRepositoryImpl().findAll();
    notes.forEach((note) {
      note.tags.forEach((tag) {
        if(!tags.contains(tag)) tags.add(tag);
      });
    });
    return tags;
  }

}