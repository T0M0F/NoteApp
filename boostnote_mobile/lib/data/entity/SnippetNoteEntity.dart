import 'dart:collection';
import 'dart:convert';

import 'package:boostnote_mobile/business_logic/model/Folder.dart';
import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';

import 'FolderEntity.dart';

class SnippetNoteEntity extends SnippetNote {

    SnippetNoteEntity({int id,
      DateTime createdAt, 
      DateTime updatedAt, 
      Folder folder, 
      String title, 
      List<String> tags, 
      bool isStarred, 
      bool isTrashed,
      String description,
      List<CodeSnippet> codeSnippets}) : super(id: id, createdAt: createdAt, updatedAt: updatedAt, 
      folder: folder, title: title, tags: tags, isStarred: isStarred, isTrashed: isTrashed, 
      description: description, codeSnippets: codeSnippets);
  
  factory SnippetNoteEntity.fromJson(Map<String, dynamic> json) {
    return SnippetNoteEntity(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      folder: FolderEntity.fromJson(json['folder']),
      title: json['title'],
      description: json['description'],
      codeSnippets: (json['codeSnippets'] as List).map((i) => CodeSnippetEntity.fromJson(i)).toList(),
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
    'tags': tags,
    'isStarred': isStarred,
    'isTrashed': isTrashed,
    'description' : description,
    'codeSnippets' : codeSnippets,
  };

  List<CodeSnippetEntity> _parseCodeSnippets(String json) {
    return jsonDecode(json).cast<Map<String, dynamic>>().map<CodeSnippetEntity>((json) => CodeSnippetEntity.fromJson(json)).toList();
  }
}

class CodeSnippetEntity extends CodeSnippet {

  CodeSnippetEntity({String linesHighlighted, String name, String mode, String content}):
  super(linesHighlighted: linesHighlighted, name: name, mode: mode, content: content);

  factory CodeSnippetEntity.fromJson(Map<String, dynamic> json) {
    return CodeSnippetEntity(
      linesHighlighted: json['linesHighlighted'],    
      name: json['name'],
      mode: json['mode'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() => {
    'linesHighlighted': linesHighlighted,
    'name': name,
    'mode': mode,
    'content': content
  };
}