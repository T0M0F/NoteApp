
import 'package:boostnote_mobile/business_logic/model/Note.dart';

class MarkdownNote extends Note{

  String content;

  MarkdownNote({int id,
      DateTime createdAt, 
      DateTime updatedAt, 
      String folder, 
      String title, 
      List<String> tags, 
      bool isStarred, 
      bool isTrashed,
      this.content}) : super(id: id, createdAt: createdAt, updatedAt: updatedAt, folder: folder, title: title, tags: tags, isStarred: isStarred, isTrashed: isTrashed);
}