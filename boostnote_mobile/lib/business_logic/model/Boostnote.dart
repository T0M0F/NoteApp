import 'package:boostnote_mobile/business_logic/model/Folder.dart';

class Boostnote {

  final String version = '1.0'; 
  List<Folder> folders;
  List<String> tags;

  Boostnote({this.folders, this.tags});
  
}