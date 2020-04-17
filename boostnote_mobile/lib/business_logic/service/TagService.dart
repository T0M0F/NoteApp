import 'package:boostnote_mobile/data/repositoryImpl/csonImpl/TagRepositoryImpl.dart';

class TagService {
 
  TagRepositoryImpl _tagRepository = TagRepositoryImpl();

  Future<List<String>> findAll() async{
    return _tagRepository.findAll();
  }

}