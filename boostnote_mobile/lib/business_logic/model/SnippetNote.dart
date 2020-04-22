
import 'package:boostnote_mobile/business_logic/model/Folder.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';

class SnippetNote extends Note {

  String description;
  List<CodeSnippet> codeSnippets;
    
  SnippetNote({String id,
    DateTime createdAt, 
    DateTime updatedAt, 
    Folder folder, 
    String title, 
    List<String> tags, 
    bool isStarred, 
    bool isTrashed,
    this.description,
    this.codeSnippets}) : super(
      id: id, 
      createdAt: createdAt, 
      updatedAt: updatedAt, 
      folder: folder, 
      title: title, 
      tags: tags, 
      isStarred: isStarred, 
      isTrashed: isTrashed
    );

  static SnippetNote clone(SnippetNote note) {
    return SnippetNote(
      description: note.description,
      codeSnippets: note.codeSnippets.map((codeSnippet) => CodeSnippet.clone(codeSnippet)).toList(),
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

class CodeSnippet {
  
  List<int> linesHighlighted;
  String name;
  String mode;
  String content;

  CodeSnippet({this.linesHighlighted, this.name, this.mode, this.content});

  static CodeSnippet clone(CodeSnippet codeSnippet) {
    return CodeSnippet(
      name: codeSnippet.name,
      content: codeSnippet.content,
      mode: codeSnippet.mode,
      linesHighlighted: codeSnippet.linesHighlighted
    );
  }
}