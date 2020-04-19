import 'dart:convert';
import 'dart:core';

import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:boostnote_mobile/data/repositoryImpl/jsonImpl/FolderRepositoryImpl.dart';

class CsonParser {

  Map<String, dynamic> parseCson(String cson, String filename) {
    Map<String, dynamic> result = _parse2(cson);
    result['id'] = filename.split('.').first;
    return result;
  }

  //TODO:
  //clean
  //parse string and num list
  // special characters in string } ] ''' \
  Map<String, dynamic> _parse2(String cson) {

    Map<String, dynamic> resultMap = Map();
    List<String> splittedByLine = LineSplitter.split(cson).toList();

    for(int i = 0; i < splittedByLine.length; i++) {
      List<String> keyValuePair = splitFirst(splittedByLine[i], ':');
      if(keyValuePair.length < 2) continue; //blank line
      String key = keyValuePair[0].trim();
      dynamic value = keyValuePair[1];

      switch (_mode(key, value)) {

        case Mode.SINGLELINE:
          resultMap[key] = _clean(value);
          break;

        case Mode.MULTILINE:
        //Annahme, dass sowas '''abc''' nicht geht, bzw in solch einem fall immer "abc" benutzt wird
          if((value as String).replaceFirst('\'\'\'', '').endsWith('\'\'\'')) {
            resultMap[key] = _clean(value);
            break;
          }
          for(int i2 = i+1; i2 < splittedByLine.length; i2++) {
            value = value + '\n' + splittedByLine[i2];
            if(splittedByLine[i2].trimRight().endsWith('\'\'\'')) {
              resultMap[key] = _clean(value);
              i = i2;
              break;
            }
          }
          break;

        case Mode.OBJECT_LIST:
          List<Map<String, dynamic>> list = List();
          String temp = '';
          bool inObject = true;
          for(int i2 = i+1; i2 < splittedByLine.length; i2++) {
            if(splittedByLine[i2].trimLeft().startsWith('{')) {
              inObject = true;
            }
            if(splittedByLine[i2].trimRight().endsWith(']') && inObject == false) {
              /*  Assuming that something like ]} is not legal. Instead end of object ] and end of list } must be in seperate lines.
              String tempWithoutSquareBrackets = splittedByLine[i2].trimRight().substring(0, splittedByLine[i2].trimRight().length-2).trimRight();
              if(tempWithoutSquareBrackets.endsWith('}')){
                temp = temp + '\n' + splittedByLine[i2];
                temp = _clean(temp);
                list.add(parse2(temp));
                temp = '';
              }*/
              value = list;
              resultMap[key] = value;
              i = i2;
              break;
            } else {
              temp = temp + '\n' + splittedByLine[i2];
              if(splittedByLine[i2].trimRight().endsWith('}')) {
                inObject = false;
                temp = _clean(temp);
                list.add(_parse2(temp));
                temp = '';
              }
            }
          }
          break;

        case Mode.SIMPLE_LIST:
          List<dynamic> list = List();
          list.add(_removeBrackets(value));
          if(value.trimRight().endsWith(']')) {
             list.removeWhere((item) => (item as String).isEmpty);
              value = list;
              resultMap[key] = value;
              break;
          }
          for(int i2 = i+1; i2 < splittedByLine.length; i2++) {
            String cleanString = _clean(_removeBrackets(splittedByLine[i2]));
            if(cleanString.length > 0) {
               list.add(cleanString);
            }
            if(splittedByLine[i2].trimRight().endsWith(']')) {
              list.removeWhere((item) => (item as String).isEmpty);
              value = list;
              resultMap[key] = value;
              i = i2;
              break;
            }
          }
          break;
      }

    }

    return resultMap;
  }

  List<String> splitFirst(String input, String pattern) {
      List<String> splitted = List();
      if(input.split(pattern).length > 1){
        int index = input.indexOf(pattern);
        splitted =  [input.substring(0,index).trim(), input.substring(index+1).trim()];
      } else {
        splitted = input.split(pattern);
      }
      return splitted;
  }

  Mode _mode(String key, String value) {
    String trimmedValue = value.trimLeft();
    if(trimmedValue.startsWith('\'\'\'')) {
      return Mode.MULTILINE;
    } else if(key == 'snippets') {
      return Mode.OBJECT_LIST;
    } else if(key == 'linesHighlighted' || key == 'tags'){
      return Mode.SIMPLE_LIST;
    } else {
       return Mode.SINGLELINE;
    }
  }

  String _removeBrackets(String input) {
    String trimmedInput = input.trim();
    //Annahme, dass sowas {[ nicht gültig ist, d.h. list start { und object start [ müssen in zwei zeilen sein
    if(trimmedInput.startsWith('[')) {
      trimmedInput = trimmedInput.replaceFirst('[', '');
    }
    //Annahme, dass sowas }] nicht gültig ist, d.h. list end } und object end } müssen in zwei zeilen sein
    if(trimmedInput.endsWith(']')) {
       if(trimmedInput.length > 1) { 
        trimmedInput = trimmedInput.substring(0, trimmedInput.length-1);
      } else {
        trimmedInput = '';
      }
    }

    return trimmedInput;
  }

  String _clean(String input) {
    String cleandedInput = input.trim();
    if(cleandedInput.startsWith('\'\'\'')) {
      cleandedInput = cleandedInput.replaceFirst('\'\'\'', '');
    } else if(cleandedInput.startsWith('"')) {
      cleandedInput = cleandedInput.replaceFirst('"', '');
    }
    if(cleandedInput.endsWith('\'\'\'')) {
      if(cleandedInput.length > 3) {
        cleandedInput = cleandedInput.substring(0, cleandedInput.length-3);
      } else {
        cleandedInput = '';
      }
    } else if(cleandedInput.endsWith('"')) {
      if(cleandedInput.length > 1) {
        cleandedInput = cleandedInput.substring(0, cleandedInput.length-1);
      } else {
        cleandedInput = '';
      }
    }
    return cleandedInput;
  }

  Future<Note> convertToNote(Map<String, dynamic> map) async {
    Note note;

    if(map['type'] == 'SNIPPET_NOTE') {
      note = SnippetNote(
        createdAt:  DateTime.parse(map['createdAt']),
        updatedAt:   DateTime.parse(map['updatedAt']),
        id: map['id'],
        title: map['title'],
        description: map['description'],
        folder: await FolderRepositoryImpl().findById(map['folder']),  
        isStarred: 'true' == map['isStarred'],
        isTrashed: 'true' == map['isTrashed'],
        tags:  List<String>.from(map['tags']), 
        codeSnippets: List<Map<String,dynamic>>.from(map['snippets']).map((snippetMap) => CodeSnippet(
            content: snippetMap['content'],
            mode: snippetMap['mode'],
            name: snippetMap['name'],
            linesHighlighted: List<String>.from(snippetMap['linesHighlighted']).map((string) => int.parse(string)).toList()
        )).toList()
      );
    } else {
      note = MarkdownNote(
        createdAt:  DateTime.parse(map['createdAt']),
        updatedAt:   DateTime.parse(map['updatedAt']),
        id: map['id'],
        title: map['title'],
        content: map['content'],
        folder: await FolderRepositoryImpl().findById(map['folder']), 
        isStarred: 'true' == map['isStarred'],
        isTrashed: 'true' == map['isTrashed'],
        tags:  List<String>.from(map['tags'])
      );
    }
    
    return note;
  }

  //TODO pretty print
  String convertToCson(Note note) => note is SnippetNote ? convertSnippetNoteToCson(note) : convertMarkdownNoteToCson(note);

  String convertMarkdownNoteToCson(MarkdownNote note){
    //note.content = note.content.replaceAll(new RegExp(r'\\'), '\\\\');
    //note.content = note.content.replaceAll('\'\'\'', '\\\'\'\'');

    String tagString;
    if(note.tags.isEmpty){
      tagString = '[]\n';
    } else {
      tagString = '[';
      note.tags.forEach((tag) => tagString = tagString + '\n"' + tag + '"');
      tagString = tagString + '\n]\n';
    }

    return
    '''
    createdAt: "''' + note.createdAt.toString() + '''"
    updatedAt: "''' + note.updatedAt.toString() + '''"
    type: "''' + (note is SnippetNote ? 'SNIPPET_NOTE' : 'MARKDOWN_NOTE') + '''"
    folder: "''' + note.folder.id + '''"
    content: \'\'\'''' + note.content + '''\'\'\'
    title: "''' + note.title + '''"
    tags: ''' + tagString + '''
    isStarred: ''' + note.isStarred.toString() + '''\n
    isTrashed: ''' + note.isTrashed.toString() + '''\n
    linesHighlighted: []
    ''';
  }

  String convertSnippetNoteToCson(SnippetNote note){
    //note.description = note.description.replaceAll(new RegExp(r'\\'), '\\\\');
    //note.description = note.description.replaceAll('\'\'\'', '\\\'\'\'');
    
    String tagString;
    if(note.tags.isEmpty){
      tagString = '[]';
    } else {
      tagString = '[';
      note.tags.forEach((tag) => tagString = tagString + '\n"' + tag + '"');
      tagString = tagString + '\n]';
    }

    String snippets = '';
    note.codeSnippets.forEach((snippet) {

       snippet.content = snippet.content.replaceAll(new RegExp(r'\\'), '\\\\');
       snippet.content = snippet.content.replaceAll('\'\'\'', '\\\'\'\'');

      snippets = snippets + '''\n
                          {
                            linesHighlighted: []
                            name: "''' + snippet.name + '''"
                            mode: "''' + snippet.mode + '''"
                            content: \'\'\'''' + snippet.content + '''\'\'\'
                          }
                            ''';
    });

    return
    '''
    createdAt: "''' + note.createdAt.toString() + '''"
    updatedAt: "''' + note.updatedAt.toString() + '''"
    type: "''' + (note is SnippetNote ? 'SNIPPET_NOTE' : 'MARKDOWN_NOTE') + '''"
    folder: "''' + note.folder.id + '''"
    description: \'\'\'''' + note.description + '''\'\'\'
    snippets: [
      ''' + snippets + '''
    ]
    title: "''' + note.title + '''"
    tags: ''' + tagString + '''\n
    isStarred: ''' + note.isStarred.toString() + '''\n
    isTrashed: ''' + note.isTrashed.toString() + '''\n
    ''';
  }
}

enum Mode {
  SINGLELINE,
  MULTILINE,
  OBJECT_LIST,
  SIMPLE_LIST
}