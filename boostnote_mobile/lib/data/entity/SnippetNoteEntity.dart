import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';

class SnippetNoteEntity extends SnippetNote {

    SnippetNoteEntity({int id,
      DateTime createdAt, 
      DateTime updatedAt, 
      String folder, 
      String title, 
      List<String> tags, 
      bool isStarred, 
      bool isTrashed,
      String, description,
      List<CodeSnippet> codeSnippets}) : super(id: id, createdAt: createdAt, updatedAt: updatedAt, 
      folder: folder, title: title, tags: tags, isStarred: isStarred, isTrashed: isTrashed, 
      description: description, codeSnippets: codeSnippets);
  
  factory SnippetNoteEntity.fromJson(Map<String, dynamic> json) {
    return SnippetNoteEntity(
      id: json['id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      folder: json['folder'],
      title: json['title'],
      description: json['description'],
      codeSnippets: List<CodeSnippet>.from(['codeSnippets']),
      tags: List<String>.from(json['tags']),
      isStarred: json['isStarred'],
      isTrashed: json['isTrashed'],
    );
  }
}

class CodeSnippetEntity extends CodeSnippet {

  CodeSnippetEntity({List<int> linesHighlighted, String name, String mode, String content}):
  super(linesHighlighted: linesHighlighted, name: name, mode: mode, content: content);

  factory CodeSnippetEntity.fromJson(Map<String, dynamic> json) {
    return CodeSnippetEntity(
      linesHighlighted: List<int>.from(['linesHighlighted']),
      name: json['name'],
      mode: json['mode'],
      content: json['content'],
    );
  }
}