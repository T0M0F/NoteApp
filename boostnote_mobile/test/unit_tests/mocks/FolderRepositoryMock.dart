import 'package:boostnote_mobile/business_logic/model/Folder.dart';
import 'package:boostnote_mobile/business_logic/repository/FolderRepository.dart';
import 'package:mockito/mockito.dart';

class FolderRepositoryMock extends Mock implements FolderRepository {

  final List<Folder> folders = List();

  void save(Folder folder) => folders.add(folder);

  Future<Folder> findById(String id) {
    if(folders.isNotEmpty) {
      for(Folder folder in folders) {
        if(folder.id == id) return Future.value(folder);
      } 
    }
    return null;
  }

}