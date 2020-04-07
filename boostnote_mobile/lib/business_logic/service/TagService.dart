import 'package:boostnote_mobile/data/repositoryImpl/jsonImpl/TagRepositoryImplV2.dart';

class TagServiceV2 {
 
  TagRepositoryImplV2 _tagRepository = TagRepositoryImplV2();

  Future<List<String>> findAll() async{
    return _tagRepository.findAll();
  }

}