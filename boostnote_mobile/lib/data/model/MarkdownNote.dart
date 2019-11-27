
import 'package:boostnote_mobile/data/model/Note.dart';

class MarkdownNote extends Note{

  String content;

  MarkdownNote({DateTime createdAt, 
      DateTime updatedAt, 
      String folder, 
      String title, 
      List<String> tags, 
      bool isStarred, 
      bool isTrashed,
      this.content}) : super(createdAt: createdAt, updatedAt: updatedAt, folder: folder, title: title, tags: tags, isStarred: isStarred, isTrashed: isTrashed);
}