
import 'package:boostnote_mobile/data/model/Note.dart';

class SnippetNode extends Note {

  String description;
  List<CodeSnippet> codeSnippets;
    
  SnippetNode({DateTime createdAt, 
      DateTime updatedAt, 
      String folder, 
      String title, 
      List<String> tags, 
      bool isStarred, 
      bool isTrashed,
      this.description,
      this.codeSnippets}) : super(createdAt: createdAt, updatedAt: updatedAt, folder: folder, title: title, tags: tags, isStarred: isStarred, isTrashed: isTrashed);
  
}

class CodeSnippet {
  
  List<int> linesHighlighted;
  String name;
  String mode;
  String content;

  CodeSnippet({this.linesHighlighted, this.name, this.mode, this.content});
}