import 'dart:convert';
import 'dart:io';

import 'package:boostnote_mobile/business_logic/model/Folder.dart';
import 'package:boostnote_mobile/business_logic/repository/FolderRepository.dart';
import 'package:boostnote_mobile/data/entity/BoostnoteEntity.dart';
import 'package:boostnote_mobile/data/entity/FolderEntity.dart';
import 'package:path_provider/path_provider.dart';

class FolderRepositoryImpl extends FolderRepository {

   Future<Directory> get directory async {
    final Directory dir = await getApplicationDocumentsDirectory();
    return dir;
  }
  
  Future<File> get localFile async {
    final Directory dir = await directory;
    File file = File(dir.path + '/boostnote');
    bool fileExists = await file.exists();
    if(!fileExists){
      print('Boostnote File doesnt exist');
      file.createSync();
      BoostnoteEntity boostnoteEntity = BoostnoteEntity(folders: List());
      boostnoteEntity.tags = List();
      file.writeAsStringSync(jsonEncode(boostnoteEntity));
      await save(Folder(name: 'Default', id: 'Default'.hashCode));  //Endlos Schleife?????
      await save(Folder(name: 'Trash', id: 'Trash'.hashCode));
      file = await localFile;
    }
    return file;
  }

  Future<BoostnoteEntity> get boostnoteEntity async  {
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
  void delete(Folder folder) {
    deleteById(folder.id);
  }

  @override
  void deleteAll(List<Folder> folders) {
    folders.forEach((folder) => deleteById(folder.id));
  }

  @override
  Future<void> deleteById(int id) async {
    print('deleteFolderById');
    if(id == 'Trash'.hashCode) {
      throw Exception('Illegal Operation: Not allowed to delete Trash folder');
    } 
    if(id == 'Default'.hashCode) {
      throw Exception('Illegal Operation: Not allowed to delete Default folder');
    }                                 //TODO Trash und default als konstante
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
  Future<Folder> findById(int id) async {
    print('findFolderById');
    final List<Folder> folders = await findAll();
    return Future.value(folders.firstWhere((folder) => folder.id == id));
  }

  @override
  Future<void> save(Folder folder) async {  //TODO Future<void>?
    print('saveFolder');
    if(folder.id == 'Trash'.hashCode && folder.name.hashCode != 'Trash'.hashCode) {
      throw Exception('Illegal Operation: Not allowed to rename Trash folder');
    } 
    if(folder.id == 'Default'.hashCode && folder.name.hashCode != 'Default'.hashCode) {
      throw Exception('Illegal Operation: Not allowed to rename Default folder');
    }    
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
    print('json folder: ' + jsonEncode(bnEntity));
    file.writeAsString(jsonEncode(bnEntity));
  }

  @override
  void saveAll(List<Folder> folders) {
    folders.forEach((folder) => save(folder));
  }

}