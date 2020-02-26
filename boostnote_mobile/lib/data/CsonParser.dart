import 'dart:convert';

import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';

class CsonParser {

  String cson = '''
  updatedAt: "2020-01-10T08:53:46.162Z"
  description:       \''' rfgew
  \'''Snippet note example
    You can store \''' a series of snippets 
    as a single note, like Gist.
    agse \'''   
  createdAt: "2020-01-10T08:45:20.087Z"
  type: "SNIPPET_NOTE"
  folder: "6d31fec6b0e523025716"
  title: "Snippet note example"
  linesHighlighted: []
  snippets: [
  {
    linesHighlighted: []
    name: "example.html"
    mode: "html"
    content:  \'''
      <html>
      <body>
      <h1 id='hello'>Enjoy Boostnote!</h1>
      </body>
      </html>
     \'''
  }
  {
    linesHighlighted: []
    name: "example.js"
    mode: "javascript"
    content:  \'''
      var boostnote = document.getElementById('hello').innerHTML
      createdAt:
      
      console.log(boostnote)
     \'''
  }
  {
    linesHighlighted: []
    name: "example.js"
    mode: "javascript"
    content:  \'''
      var boostnote = document.getElementById('hello').innerHTML
      createdAt: ]
      
      console.log(boostnote)
     \'''
  }
]
tags: ["Gucci"
  "Abcd" ] 
''';


  Map<String, dynamic> parse(String cson) {

    Map<String, dynamic> resutlMap = Map();
    List<String> splittedByLine = LineSplitter.split(cson).toList();

    String key;
    dynamic value;
    bool skipLine = false;
    int skipUntilIndex;

    for(int i = 0; i < splittedByLine.length; i++) {

      if(skipLine && i <= skipUntilIndex){
        continue;
      } else if (skipLine && i > skipUntilIndex) {
        skipLine = false;
        skipUntilIndex = -1;
      }
      //RegExp('[createdAt|updatedAt|type|folder|title|description|snippets|linesHighlighted|name|mode|content|tags|isStarred|isTrashed]( )*:'));  //Außer wenn : in ' ' (oder " " ? )
      //List<String> splittedByDoublePoint = splittedByLine[i].split(':');
      int index = splittedByLine[i].indexOf(":");
      List<String> splittedByDoublePoint;
      if(index > 1){
        splittedByDoublePoint =  [splittedByLine[i].substring(0,index).trim(), splittedByLine[i].substring(index+1).trim()];
      } else {
        splittedByDoublePoint = splittedByLine[i].split(':');
      }
      
      /*
      int index = splittedByLine[i].indexOf(':');
      List<String> splittedByDoublePoint = List(2);
      splittedByDoublePoint[0] = splittedByLine[i].substring(0,index-1);
      splittedByDoublePoint[1] = splittedByLine[i].substring(index+1);*/
             
      key = splittedByDoublePoint[0].trim();   //tags,linesHighlighted, CodeSnippets

      /*If line contains multiple : , line should only be seperated at first :    
      Example: date : '2019:02:01'  -> splittedByDoublePoint[0] should be date, splittedByDoublePoint[1] should be '2019:02:01'*/
      /*if(splittedByDoublePoint.length > 2) {
        for(int i = 0; i < splittedByDoublePoint.length; i++) {
          splittedByDoublePoint[1] = splittedByDoublePoint[1] + ':' + splittedByDoublePoint[i];
        }    
      } */

      /*Check for linesHighlighted, Tags and Snippets*/
      if(key.contains('linesHighlighted')) {  

        print('Skip linesHighlighted');
        continue;

      } else if(key.contains('tags')) {   
        skipLine = true;
        List<String> tags = List();
        for(int i2 = i; i2 < splittedByLine.length; i2++) {
          if(i2 == i){
            //remove [
          }
          if(splittedByLine[i2].trimRight().endsWith(']')){   //Außer wenn escaped
            tags.add(splittedByLine[i2].trimRight().substring(0,splittedByLine[i2].trimRight().length-2));
            skipUntilIndex = i2;
            break;
          } 
          tags.add(splittedByLine[i2]);
          //remove first [ and last ]
        }
        value = tags;

      } else if(key.contains('snippets')) {

        print('contains snnippets');
        List<Map<String,dynamic>> snippets = List();
        String currentSnippet = '';
        for(int i2 = i+1; i2 < splittedByLine.length; i2++) {
          if(splittedByLine[i2].contains('{')) {
            print('{');
            skipLine = true;
            currentSnippet = currentSnippet + '\n' + splittedByLine[i2];
          } else if(splittedByLine[i2].contains('}')){   //Außer wenn escaped
            print('}');
            skipUntilIndex = i2;
            currentSnippet = currentSnippet + '\n' + splittedByLine[i2];
            print('----------------------------current Snippet--------------------------------');
            print(currentSnippet);
            print('---------------------------------------------------------------------------');
            snippets.add(parse(currentSnippet));
            currentSnippet = '';
          } else {
            currentSnippet = currentSnippet + '\n' + splittedByLine[i2];
          }
          
          if(splittedByLine[i2].contains(']') && splittedByLine[i2-1].contains('}')){   //Außer wenn im objekt drinne         
            print(']');
            break;
          }
        } 

        value = snippets;
      } 

      if(splittedByDoublePoint.length > 1) {

        /*set value if not set before*/
        if(value == null) {
          if(splittedByDoublePoint[1].startsWith('"')){
            splittedByDoublePoint[1] = splittedByDoublePoint[1].substring(1,splittedByDoublePoint[1].length-1);
          }
          if(splittedByDoublePoint[1].endsWith('"')){
            splittedByDoublePoint[1] = splittedByDoublePoint[1].substring(0,splittedByDoublePoint[1].length-2);
          }
          value = splittedByDoublePoint[1];
        } 

        /*Check for multiline String*/
        if(value is String) {
          String s = value;
          if(s.trimLeft().startsWith('\'\'\'')){   //Außer wenn escaped    //IDEE: check if left getrimmter String mit ''' startet. Wenn ja dann: multiline true -> ''' als Content interpretieren else ...
            skipLine = true;
            value = s.trimLeft().substring(3, s.trimLeft().length);
            for(int i2 = i+1; i2 < splittedByLine.length; i2++){
                if(splittedByLine[i2].trimRight().endsWith('\'\'\'')){
                    value = value + splittedByLine[i2].trimRight().substring(0, splittedByLine[i2].trimRight().length-3);
                    skipUntilIndex = i2;
                    break;
                }
                value = value + '\n' + splittedByLine[i2];
            }
          }
        }
        
        resutlMap[key] = value;

        value = null;
      }
     
    }

    return resutlMap;
  }

  Note convertToNote(Map<String, dynamic> map) {
    Note note;

    if(map['type'] == 'SNIPPET_NOTE') {
      note = SnippetNote(
        createdAt:  DateTime.parse(map['createdAt']),
        updatedAt:   DateTime.parse(map['updatedAt']),
        id: 1,
        title: map['title'],
        description: map['description'],
        folder: map['folder'],
        isStarred: map['isStarred'],
        isTrashed: map['isTrashed'],
        tags:  List<String>.from(map['tags']), 
        codeSnippets: List<Map<String,dynamic>>.from(['codeSnippets']).map((snippetMap) => CodeSnippet(
            content: snippetMap['content'],
            mode: snippetMap['mode'],
            name: snippetMap['name']
        )).toList()
      );
    } else {
      note = MarkdownNote(
        createdAt:  DateTime.parse(map['createdAt']),
        updatedAt:   DateTime.parse(map['updatedAt']),
        id: 1,
        title: map['title'],
        content: map['content'],
        folder: map['folder'],
        isStarred: bool.fromEnvironment(map['isStarred']),
        isTrashed:  bool.fromEnvironment(map['isTrashed']),
        tags:  List<String>.from(map['tags'])
      );
    }
    
    return note;
  }

  String convertToCson(Note note){

    String tagString = '';
    note.tags.forEach((tag) => tagString = tagString + '\n"' + tag + '"');

    
    String result = 
  '''
  createdAt: "''' + note.createdAt.toString() + '''"
  updatedAt: "''' + note.updatedAt.toString() + '''"
  type: "''' + (note is SnippetNote ? 'SNIPPET_NOTE' : 'MARKDOWN_NOTE') + '''"
  folder: "''' + note.folder.name + '''"
  title: "''' + note.title + '''"
  tags: [''' + tagString + '''\n]
  isStarred: ''' + note.isStarred.toString() + '''
  isTrashed: ''' + note.isTrashed.toString() + ''' 
  ''';

    return result;
  }
}