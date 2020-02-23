import 'dart:convert';

class CsonParser {

  String cson = '''
  updatedAt: "2020-01-10T08:53:46.162Z"
  createdAt: "2020-01-10T08:45:20.087Z"
  type: "SNIPPET_NOTE"
  folder: "6d31fec6b0e523025716"
  description: \'''
    Snippet note example
    You can store a series of snippets 
    as a single note, like Gist.
  \'''
  title: "Snippet note example"
  linesHighlighted: []
  tags: [
    "Gucci"
    "Abcd"
  ]
''';
/*
tags: [
    "Gucci"
    "Abcd"
  ]

  */

  Map<String, dynamic> parse(String cson) {

    Map<String, dynamic> resutlMap = Map();
    List<String> splittedByLine = LineSplitter.split(cson).toList();

    String key;
    dynamic value;
    bool skipLine = false;
    int skipUntilIndex;

    for(int i = 0; i < splittedByLine.length; i++) {

      print('current Line: ' + splittedByLine[i]);
      
      if(skipLine && i <= skipUntilIndex){
        print('skip line: ' + splittedByLine[i]);
        continue;
      } else if (skipLine && i > skipUntilIndex) {
        print('stop skipping in: '  + splittedByLine[i]);
        skipLine = false;
        skipUntilIndex = -1;
      }
      
      List<String> splittedByDoublePoint = splittedByLine[i].split(':');  //Außer wenn : in ' ' (oder " " ? )
             
      key = splittedByDoublePoint[0];   //tags,linesHighlighted, CodeSnippets

      print('key is ' + key);
      
      if(key.contains('linesHighlighted')) {   //wird nicht geskippt irgendwie......
        print('Skip linesHighlighted');
        continue;
      } else if(key.contains('tags')) {    //klappt nicht
        print('Tags found');
        skipLine = true;
        List<String> tags = List();
        for(int i2 = i+1; i2 < splittedByLine.length; i2++) {
          print('tag is ' + splittedByLine[i2]);
          if(splittedByLine[i2].contains(']')){   //Außer wenn escaped
            skipUntilIndex = i2;
            break;
          } 
          tags.add(splittedByLine[i2]);   //remove first [ and last ]
        }
        value = tags;

        print('tags----------------');
        tags.forEach((tag) => print(tag));
        print('--------------------');

      } else if(key.contains('snippets')) {
        //Implement
        continue;
      } 

      value = splittedByDoublePoint[1];
      
      if(splittedByLine[i].contains('\'\'\'')){   //Außer wenn escaped
          
          skipLine = true;
          for(int i2 = i+1; i2 < splittedByLine.length; i2++){
              value = value + '\n' + splittedByLine[i2];
              if(splittedByLine[i2].contains('\'\'\'')){
                  skipUntilIndex = i2;
                  break;
              }
          }
      }
      
      resutlMap[key] = value;
    }

    return resutlMap;
  }
}