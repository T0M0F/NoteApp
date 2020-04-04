import 'dart:convert';
import 'dart:core';
import 'dart:core';

import 'package:boostnote_mobile/business_logic/model/Folder.dart';
import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:strings/strings.dart';

//IN Parser und Mapper unterteilen
class CsonParser {

  // Problem wenn '''''' -> multiline beginnt und endet in der selben Zeile

  //Problem, wenn ''' in einem MultiLineString am Ende der Zeile ist 
  /*
  '''
  avb
  asf'''           <---Problem
  asd
  '''
  */

  //Check for multiple escapes like \\ or \\\ in multiline strings
  //testen ob [] oder {} probleme macht
  
  String cson2 = '''
  snippets: [
      {
      name: "example.html"
      content: \'''
        <html>
              <body>
              <h1 id='hello'>Enjoy Boostnote!</h1>
              </body>
              </html>
      \'''
      mode: "HTML"
    }
    {
      name: "example.js"
      mode: "JavaScript"
      content: \'''
        var boostnote = document.getElementById('hello').innerHTML
              createdAt:
              
              console.log(boostnote)
      \'''
    }
  ]
  createdAt: "2020-04-01T19:14:14.273Z"

  updatedAt: "2020-04-04T10:52:23.733Z"
  type: "SNIPPET_NOTE"
  folder: "f6b3ec63a3b965e19713"
  title: "Tester"
  description: \'''
    Tester
    sdfsfsdfsdfsdfdsfds
    sdfdsfdsfdsdsfdfsfdsfs
  \'''
  isStarred: false
  isTrashed: false

  ''';



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
  isStarred: false
  isTrashed: false
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
    name: "example.js\'''"
    mode: "{javascript]"
    content:  \'''
      var boostnote = document.getElementById('hello').innerHTML
      createdAt:
      
      console.log(boostnote)
     \'''
  }
  {
    linesHighlighted: []
    name: "\'''example.js"
    mode: "javascript"
    content:  \'''
      var boostnote = document.getElementById('hello').innerHTML
      createdAt: ]
      
      console.log(boostnote)
     \'''
  }
]
tags: ["[Gu[cci"
"jK]"
  "A]bcd]" ] 
''';

  //TODO:
  //clean
  //parse string and num list
  // special characters in string } ] ''' \
  Map<String, dynamic> parse2(String cson) {

    Map<String, dynamic> resultMap = Map();
    List<String> splittedByLine = LineSplitter.split(cson).toList();

    for(int i = 0; i < splittedByLine.length; i++) {
      List<String> keyValuePair = splittedByLine[i].split(':');
      if(keyValuePair.length < 2) continue; //blank line
      String key = keyValuePair[0].trim();
      dynamic value = keyValuePair[1];

      switch (_mode(key, value)) {

        case Mode.SINGLELINE:
          resultMap[key] = _clean(value);
          break;

        case Mode.MULTILINE:
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
          for(int i2 = i+1; i2 < splittedByLine.length; i2++) {
            if(splittedByLine[i2].trimRight().endsWith(']')) {
              String tempWithoutSquareBrackets = splittedByLine[i2].trimRight().substring(0, splittedByLine[i2].trimRight().length-2).trimRight();
              if(tempWithoutSquareBrackets.endsWith('}')){
                temp = temp + '\n' + splittedByLine[i2];
                temp = _clean(temp);
                list.add(parse2(temp));
                temp = '';
              }
              value = list;
              resultMap[key] = value;
              i = i2;
              break;
            } else {
              temp = temp + '\n' + splittedByLine[i2];
              if(splittedByLine[i2].trimRight().endsWith('}')) {
                temp = _clean(temp);
                list.add(parse2(temp));
                temp = '';
              }
            }
          }
          break;

        case Mode.NUM_LIST:
          
          break;

        case Mode.UNKNOWN:
          continue;
          break;
      }

    }

    return resultMap;
  }

  Mode _mode(String key, String value) {
    String trimmedValue = value.trimLeft();
    if(trimmedValue.startsWith('\'\'\'')) {
      return Mode.MULTILINE;
    } else if(trimmedValue.startsWith('"')) {
      return Mode.SINGLELINE;
    } else if(key == 'snippets') {
      return Mode.OBJECT_LIST;
    } else if(key == 'linesHighlighted'){
      return Mode.NUM_LIST;
    } else {
      return Mode.UNKNOWN;
    }
  }

  String _clean(String input) {
    String cleandedInput = input.trim();
    if(cleandedInput.startsWith('\'\'\'')) {
      cleandedInput.replaceFirst('\'\'\'', '');
    } else if(cleandedInput.startsWith('"')) {
      cleandedInput.replaceFirst('"', '');
    }
    if(cleandedInput.endsWith('\'\'\'')) {
      cleandedInput.substring(0, cleandedInput.length-4);
    } else if(cleandedInput.endsWith('"')) {
      cleandedInput.substring(0, cleandedInput.length-2);
    }
    return cleandedInput;
  }



  Map<String, dynamic> parse(String cson) {

    Map<String, dynamic> resutlMap = Map();
    List<String> splittedByLine = LineSplitter.split(cson).toList();

    String key;
    dynamic value;
    bool skipLine = false;
    int skipUntilIndex;
  
    for(int i = 0; i < splittedByLine.length; i++) {
      print(skipUntilIndex);
      print(splittedByLine[i]);
      if(skipLine && i <= skipUntilIndex){    //Problem manchmal null
        continue;
      } else if (skipLine && i > skipUntilIndex) {
        skipLine = false;
        skipUntilIndex = -1;
      }print(('after'));
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

        print('contains linesHighlighted');
        String linesHighlighted = '';
        skipLine = true;
         String s = '';
        for(int i2 = i; i2 < splittedByLine.length; i2++) {
          linesHighlighted = linesHighlighted + '\n' + splittedByLine[i2];
         s= splittedByLine[i2];
          if(splittedByLine[i2].trim().endsWith(']')){   //Außer wenn escaped
            print(']');
            skipUntilIndex = i2;
            break;
          } 
        } 

        value = s;

      } else if(key.contains('tags')) {   
        skipLine = true;
        List<String> tags = List();
        for(int i2 = i; i2 < splittedByLine.length; i2++) {
          if(i2 == i){
            int index = splittedByLine[i2].indexOf('[');
            if(index > 0) {
              
              splittedByLine[i2] = splittedByLine[i2].substring(index + 1);
            }
          }
          if(splittedByLine[i2].trimRight().endsWith(']')){   //Außer wenn escaped
            splittedByLine[i2] = splittedByLine[i2].trimRight().substring(0,splittedByLine[i2].trimRight().length-1);
            //splittedByLine[i2] = splittedByLine[i2].trimLeft().substring(1);
           // splittedByLine[i2] = splittedByLine[i2].trimRight().substring(0, splittedByLine[i2].length-1);
            tags.add(splittedByLine[i2]);
            skipUntilIndex = i2;
            break;
          } 
          // splittedByLine[i2] = splittedByLine[i2].trimLeft().substring(1);
          //  splittedByLine[i2] = splittedByLine[i2].trimRight().substring(0, splittedByLine[i2].length-1);
          print('tag: ' + splittedByLine[i2].trim() + splittedByLine[i2].trim().length.toString());
          if(splittedByLine[i2].trim().length > 2){
            splittedByLine[i2] = splittedByLine[i2].trimLeft().substring(1);
            splittedByLine[i2] = splittedByLine[i2].trimRight().substring(0, splittedByLine[i2].length-1);
            if(splittedByLine[i2].trim().length > 0){
               tags.add(splittedByLine[i2]);
            }
          } 
        }
        tags.removeWhere((tag) => tag.trim().isEmpty);
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
            print(']');     //TODO so geht das nicht es kann }] vorkommen
            break;
          }
        } 

        value = snippets;
      } 

      if(splittedByDoublePoint.length > 1) {

        /*set value if not set before*/
        if(value == null) {
          
          value = splittedByDoublePoint[1];
        } 

        /*Check for multiline String*/
        //Skip until indem zählvariable von schlefe verändert wird
        if(value is String) {
          String s = value;
          if(s.trimLeft().startsWith('\'\'\'')){   //Außer wenn escaped    //IDEE: check if left getrimmter String mit ''' startet. Wenn ja dann: multiline true -> ''' als Content interpretieren else ...
            if(s.trimRight().endsWith('\'\'\'') && s.trim().length >= 6 && !s.trimRight().endsWith('\\\'\'\'')){  //Check for multiple escapes like \\ or \\\
              print('ydhfsk');
              String a = s.trimLeft().substring(3, s.trimLeft().length);
              value = a.trimRight().substring(0, a.trimRight().length-3);
            } else {
              skipLine = true;
              value = s.trimLeft().substring(3, s.trimLeft().length);
              for(int i2 = i+1; i2 < splittedByLine.length; i2++){
                  if(splittedByLine[i2].trimRight().endsWith('\'\'\'') && !splittedByLine[i2].trimRight().endsWith('\\\'\'\'')){    //Problem, wenn in Zeile am Ende ''' ist
                      value = value + '\n' + splittedByLine[i2].trimRight().substring(0, splittedByLine[i2].trimRight().length-3);
                      skipUntilIndex = i2;
                      break;
                  }
                  value = value + '\n' + splittedByLine[i2];
              }
            }
          } else {
            if(splittedByDoublePoint[1].trimLeft().startsWith('"')){
              splittedByDoublePoint[1] = splittedByDoublePoint[1].trimLeft().substring(1);
            }
            if(splittedByDoublePoint[1].trimRight().endsWith('"')){
              value = splittedByDoublePoint[1].trimRight().substring(0,splittedByDoublePoint[1].length-1);
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

    //replace ecscape chars with nothing

    if(map['type'] == 'SNIPPET_NOTE') {
      note = SnippetNote(
        createdAt:  DateTime.parse(map['createdAt']),
        updatedAt:   DateTime.parse(map['updatedAt']),
        id: DateTime.parse(map['createdAt']).hashCode,
        title: map['title'],
        description: map['description'],
        folder: Folder(name: map['folder'], id: map['folder'].hashCode),
        isStarred: 'true' == map['isStarred'],
        isTrashed: 'true' == map['isTrashed'],
        tags:  List<String>.from(map['tags']), 
        codeSnippets: List<Map<String,dynamic>>.from(map['snippets']).map((snippetMap) => CodeSnippet(
            content: snippetMap['content'],
            mode: snippetMap['mode'],
            name: snippetMap['name']
        )).toList()
      );
    } else {
      note = MarkdownNote(
        createdAt:  DateTime.parse(map['createdAt']),
        updatedAt:   DateTime.parse(map['updatedAt']),
        id: DateTime.parse(map['createdAt']).hashCode,
        title: map['title'],
        content: map['content'],
        folder: Folder(name: map['folder'], id: map['folder'].hashCode),
        isStarred: 'true' == map['isStarred'],
        isTrashed: 'true' == map['isTrashed'],
        tags:  List<String>.from(map['tags'])
      );
    }
    
    return note;
  }

  String convertToCson(Note note){
    String s = note is SnippetNote ? convertSnippetNoteToCson(note) : convertMarkdownNoteToCson(note);
      print('------------------------------------');
    print(s);
    print('------------------------------------');
    return s;
  }

  String convertMarkdownNoteToCson(MarkdownNote note){

    // note.content = note.content.replaceAll(new RegExp(r'\\'), '\\\\');
    note.content = note.content.replaceAll('\'\'\'', '\\\'\'\'');


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
    folder: "''' + note.folder.name + '''"
    content: \'\'\'''' + note.content + '''\'\'\'
    title: "''' + note.title + '''"
    tags: ''' + tagString + '''
    isStarred: ''' + note.isStarred.toString() + '''\n
    isTrashed: ''' + note.isTrashed.toString() + '''\n
    linesHighlighted: []
    ''';
  }

  String convertSnippetNoteToCson(SnippetNote note){

    note.description = note.description.replaceAll(new RegExp(r'\\'), '\\\\');
    note.description = note.description.replaceAll('\'\'\'', '\\\'\'\'');
    
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
    folder: \'\'\'''' + note.folder.name + '''\'\'\'
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
  NUM_LIST,
  UNKNOWN
}