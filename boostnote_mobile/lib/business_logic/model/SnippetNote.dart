
import 'package:boostnote_mobile/business_logic/model/Folder.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';

class SnippetNote extends Note {

  String description;
  List<CodeSnippet> codeSnippets;
    
  SnippetNote({int id,
      DateTime createdAt, 
      DateTime updatedAt, 
      Folder folder, 
      String title, 
      List<String> tags, 
      bool isStarred, 
      bool isTrashed,
      this.description,
      this.codeSnippets}) : super(id: id, createdAt: createdAt, updatedAt: updatedAt, folder: folder, title: title, tags: tags, isStarred: isStarred, isTrashed: isTrashed);
  
}

class CodeSnippet {
  
  String linesHighlighted;
  String name;
  String mode;
  String content;

  CodeSnippet({this.linesHighlighted, this.name, this.mode, this.content});
}