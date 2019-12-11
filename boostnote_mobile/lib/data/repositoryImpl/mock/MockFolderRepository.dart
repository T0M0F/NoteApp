import 'package:boostnote_mobile/business_logic/repository/FolderRepository.dart';

class MockFolderRepository implements FolderRepository{

  List<String> _folders = ['Default'];

  @override
  void delete(String entity) {
    // TODO: implement delete
  }

  @override
  void deleteAll(List<String> entities) {
    // TODO: implement deleteAll
  }

  @override
  void deleteById(int id) {
    // TODO: implement deleteById
  }

  @override
  List<String> findAll() {
    return _folders;
  }

  @override
  String findById(int id) {
    // TODO: implement findById
    return null;
  }

  @override
  void save(String entity) {
    // TODO: implement save
  }

  @override
  void saveAll(List<String> entities) {
    // TODO: implement saveAll
  }

}