import 'package:boostnote_mobile/business_logic/model/Folder.dart';
import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';

import 'FolderEntity.dart';

class MarkdownNoteEntity extends MarkdownNote {

  MarkdownNoteEntity({String id,
      DateTime createdAt, 
      DateTime updatedAt, 
      Folder folder, 
      String title, 
      List<String> tags, 
      bool isStarred, 
      bool isTrashed,
      String content}) : super(id: id, createdAt: createdAt, updatedAt: updatedAt, folder: folder, title: title, content: content, tags: tags, isStarred: isStarred, isTrashed: isTrashed);
  
  factory MarkdownNoteEntity.fromJson(Map<String, dynamic> json) {
    return MarkdownNoteEntity(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      folder: FolderEntity.fromJson(json['folder']),
      title: json['title'],
      content: json['content'],
      tags: List<String>.from(json['tags']),
      isStarred: json['isStarred'],
      isTrashed: json['isTrashed'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'createdAt': createdAt.toString(),
    'updatedAt': updatedAt.toString(),
    'folder': folder,
    'title': title,
    'content': content,
    'tags': tags,
    'isStarred': isStarred,
    'isTrashed': isTrashed,
  };
}