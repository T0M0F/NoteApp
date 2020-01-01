import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';

class MarkdownNoteEntity extends MarkdownNote {

  MarkdownNoteEntity({int id,
      DateTime createdAt, 
      DateTime updatedAt, 
      String folder, 
      String title, 
      List<String> tags, 
      bool isStarred, 
      bool isTrashed,
      String content}) : super(id: id, createdAt: createdAt, updatedAt: updatedAt, folder: folder, title: title, content: content, tags: tags, isStarred: isStarred, isTrashed: isTrashed);
  
  factory MarkdownNoteEntity.fromJson(Map<String, dynamic> json) {
    return MarkdownNoteEntity(
      id: json['id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      folder: json['folder'],
      title: json['title'],
      content: json['content'],
      tags: List<String>.from(json['tags']),
      isStarred: json['isStarred'],
      isTrashed: json['isTrashed'],
    );
  }
}