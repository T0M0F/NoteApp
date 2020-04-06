import 'package:boostnote_mobile/business_logic/model/Folder.dart';

abstract class Note {

  String id;
  final DateTime createdAt;
  DateTime updatedAt;
  Folder folder; //im wiki nach gucken, wie wert generiert wird + evtl extra Klasse
  String title;
  List<String> tags;
  bool isStarred;
  bool isTrashed;

  Note({this.id,
        this.createdAt, 
        this.updatedAt, 
        this.folder, 
        this.title, 
        this.tags, 
        this.isStarred, 
        this.isTrashed});

}