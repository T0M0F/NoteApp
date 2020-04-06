
import 'dart:convert';
import 'dart:io';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/repository/NoteRepository.dart';
import 'package:boostnote_mobile/business_logic/repository/TagRepository.dart';
import 'package:boostnote_mobile/data/entity/BoostnoteEntity.dart';
import 'package:boostnote_mobile/data/repositoryImpl/csonImpl/NoteRepositoryImpl.dart';
import 'package:path_provider/path_provider.dart';

class TagRepositoryImpl implements TagRepository{

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
  Future<void> delete(String tag) {
     return deleteById(tag);
  }

  @override
  Future<void> deleteAll(List<String> tags) {  //TODO return
    tags.forEach((tag) => deleteById(tag));
  }

  @override
  Future<void> deleteById(String name) async {
    final File file = await localFile;
    final BoostnoteEntity bnEntity = await boostnoteEntity;
    bnEntity.tags.removeWhere((tag) => tag == name);
    file.writeAsString(jsonEncode(bnEntity));
  }

  @override
  Future<List<String>> findAll() async {
    final BoostnoteEntity bnEntity = await boostnoteEntity;
    bnEntity.tags.forEach((tag) => print('bn ' + tag));
    return Future.value(bnEntity.tags); 
  }

  @override //currently findByName
  Future<String> findById(String name) async {
    final List<String> tags = await findAll();
    return Future.value(tags.firstWhere((tag) => tag == name));
  }

  @override
  Future<void> save(String tag) async { 
    final File file = await localFile;
    final BoostnoteEntity bnEntity = await boostnoteEntity;
    for(String currentTag in bnEntity.tags) {
      if(currentTag == tag){
        print('Tag already exists');
        return;
      }
    }
    bnEntity.tags.add(tag);
    print('json tag: ' + jsonEncode(bnEntity));
    file.writeAsString(jsonEncode(bnEntity));
  }

  @override
  Future<void> saveAll(List<String> tags) {     //TODO return
    tags.forEach((tag) => save(tag));
  }

}