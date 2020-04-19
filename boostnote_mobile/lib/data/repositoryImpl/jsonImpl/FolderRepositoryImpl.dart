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
      file.createSync();
      BoostnoteEntity boostnoteEntity = BoostnoteEntity(folders: List());
      boostnoteEntity.tags = List();
      file.writeAsStringSync(jsonEncode(boostnoteEntity));
      await save(Folder(name: 'Default'));  
      await save(Folder(name: 'Trash'));
      file = await localFile;
    }
    return file;
  }

  Future<BoostnoteEntity> get boostnoteEntity async  {
    final File file = await localFile;
    String content = file.readAsStringSync();
    BoostnoteEntity boostnoteEntity = BoostnoteEntity.fromJson(jsonDecode(content));
    if(boostnoteEntity.tags == null){
      boostnoteEntity.tags = List();
    }
    return Future.value(boostnoteEntity);
  }


  @override    
  Future<void> delete(Folder folder) {
    if(folder.name == 'Trash') {     
      throw Exception('Illegal Operation: Not allowed to delete Trash folder');
    } 
    if(folder.name == 'Default') {
      throw Exception('Illegal Operation: Not allowed to delete Default folder');
    }  
    return deleteById(folder.id);
  }

  @override
  Future<void> deleteAll(List<Folder> folders) async {      
   folders.forEach((folder) => delete(folder));
  }

  @override
  Future<void> deleteById(String id) async {  
    final File file = await localFile;
    final BoostnoteEntity bnEntity = await boostnoteEntity;
    bnEntity.folders.removeWhere((folder) => folder.id == id);
    file.writeAsString(jsonEncode(bnEntity));
  }

  @override
  Future<List<Folder>> findAll() async {
    final BoostnoteEntity bnEntity = await boostnoteEntity;
    return Future.value(bnEntity.folders); 
  }

  @override
  Future<Folder> findById(String id) async {
    final List<Folder> folders = await findAll();
    return Future.value(folders.firstWhere((folder) => folder.id == id));
  }

  @override
  Future<void> save(Folder folder) async { 
    if(folder.id == null) {
      folder.id = IdGenerator().generateFolderId();  
    }
    final File file = await localFile;
    final BoostnoteEntity bnEntity = await boostnoteEntity;
    for(Folder currentFolder in bnEntity.folders) {
      if(currentFolder.id == folder.id){
        return;
      }
    }
    folder = FolderEntity(name: folder.name, id: folder.id); 
    bnEntity.folders.add(folder);
    file.writeAsString(jsonEncode(bnEntity));
  }

  @override
  Future<void> saveAll(List<Folder> folders) async {  
    folders.forEach((folder) => save(folder));
  }

}