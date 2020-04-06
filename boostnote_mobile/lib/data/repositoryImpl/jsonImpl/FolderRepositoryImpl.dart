import 'dart:convert';
import 'dart:io';

import 'package:boostnote_mobile/business_logic/model/Folder.dart';
import 'package:boostnote_mobile/business_logic/repository/FolderRepository.dart';
import 'package:boostnote_mobile/data/IdGenerator.dart';
import 'package:boostnote_mobile/data/entity/BoostnoteEntity.dart';
import 'package:boostnote_mobile/data/entity/FolderEntity.dart';
import 'package:path_provider/path_provider.dart';

class FolderRepositoryImpl extends FolderRepository {

   Future<Directory> get directory async {
    final Directory dir = await getExternalStorageDirectory();
    return dir;
  }
  
  Future<File> get localFile async {
    final Directory dir = await directory;
    File file = File(dir.path + '/boostnote.json');
    bool fileExists = await file.exists();
    if(!fileExists){
      print('Boostnote File doesnt exist');
      file.createSync();
      BoostnoteEntity boostnoteEntity = BoostnoteEntity(folders: List());
      boostnoteEntity.tags = List();
      file.writeAsStringSync(jsonEncode(boostnoteEntity));
      await save(Folder(name: 'Default'));  //Endlos Schleife?????
      await save(Folder(name: 'Trash'));
      file = await localFile;
    }
    return file;
  }

  Future<BoostnoteEntity> get boostnoteEntity async  {
    final File file = await localFile;
    String content = file.readAsStringSync();
    print('Boostnote file content 1: ' + content);
    BoostnoteEntity boostnoteEntity = BoostnoteEntity.fromJson(jsonDecode(content));
    if(boostnoteEntity.tags == null){
      print('Tags are null');
      boostnoteEntity.tags = List();
    }
    return Future.value(boostnoteEntity);
  }


  @override    
  Future<void> delete(Folder folder) {
    if(folder.name == 'Trash') {       //TODO Trash und default als konstante
      throw Exception('Illegal Operation: Not allowed to delete Trash folder');
    } 
    if(folder.name == 'Default') {
      throw Exception('Illegal Operation: Not allowed to delete Default folder');
    }  
    return deleteById(folder.id);
  }

  @override
  Future<void> deleteAll(List<Folder> folders) async {      
   // Future.forEach(folders, (folder) => deleteById(folder.id));  //TODO return
   folders.forEach((folder) => delete(folder));
  }

  @override
  Future<void> deleteById(String id) async {
    print('deleteFolderById');       
    final File file = await localFile;
    final BoostnoteEntity bnEntity = await boostnoteEntity;
    bnEntity.folders.removeWhere((folder) => folder.id == id);
    file.writeAsString(jsonEncode(bnEntity));
  }

  @override
  Future<List<Folder>> findAll() async {
    print('findNotesAll');
    final BoostnoteEntity bnEntity = await boostnoteEntity;
    bnEntity.folders.forEach((f) => print('bn' + f.name));
    return Future.value(bnEntity.folders); 
  }

  @override
  Future<Folder> findById(String id) async {
    print('findFolderById');
    final List<Folder> folders = await findAll();
    return Future.value(folders.firstWhere((folder) => folder.id == id));
  }

  @override
  Future<void> save(Folder folder) async { 
    print('saveFolder');
    folder.id = IdGenerator().generateId();  
    final File file = await localFile;
    final BoostnoteEntity bnEntity = await boostnoteEntity;
    for(Folder currentFolder in bnEntity.folders) {
      if(currentFolder.id == folder.id){
        print('Folder already exists');
        return;
      }
    }
    folder = FolderEntity(name: folder.name, id: folder.id); //TODO ugly
    bnEntity.folders.add(folder);
    print('json folder 2: ' + jsonEncode(bnEntity));
    file.writeAsString(jsonEncode(bnEntity));
  }

  @override
  Future<void> saveAll(List<Folder> folders) async {  
    //Future.forEach(folders, (folder) => save(folder));  //TODO return
    folders.forEach((folder) => save(folder));
  }

}