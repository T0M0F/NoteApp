import 'package:boostnote_mobile/business_logic/model/Folder.dart';

abstract class Note {

  String id;
  final DateTime createdAt;
  DateTime updatedAt;
  Folder folder; 
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

  @override
  String toString() => 'Note[id: $id, title: $title, createdAt: $createdAt]';

  @override 
  bool operator == (Object other) => 
    identical(this, other)||
    other is Note &&
    runtimeType == other.runtimeType &&
    id == other.id;

  @override
  int get hashCode => id.hashCode;
}