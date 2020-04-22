
import 'package:boostnote_mobile/business_logic/model/Folder.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';

class MarkdownNote extends Note{

  String content;

  MarkdownNote({String id,
    DateTime createdAt, 
    DateTime updatedAt, 
    Folder folder, 
    String title, 
    List<String> tags, 
    bool isStarred, 
    bool isTrashed,
    this.content}) : super(
      id: id, 
      createdAt: createdAt, 
      updatedAt: updatedAt, 
      folder: folder, 
      title: title, 
      tags: tags, 
      isStarred: isStarred, 
      isTrashed: isTrashed
    );

  static MarkdownNote clone(MarkdownNote note) {
    return MarkdownNote(
      content: note.content,
      createdAt: note.createdAt,
      folder: Folder.clone(note.folder),
      id: note.id,
      isStarred: note.isStarred,
      isTrashed: note.isTrashed,
      tags: note.tags,
      title: note.title,
      updatedAt: note.updatedAt
    );
  }
}