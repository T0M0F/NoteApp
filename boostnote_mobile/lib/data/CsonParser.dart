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
      createdAt:
      
      console.log(boostnote)
     \'''
  }
]
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
      
      List<String> splittedByDoublePoint = splittedByLine[i].split(':');  //Außer wenn : in ' ' (oder " " ? )
             
      key = splittedByDoublePoint[0];   //tags,linesHighlighted, CodeSnippets
      
      if(key.contains('linesHighlighted')) {   
        print('Skip linesHighlighted');
        continue;
      } else if(key.contains('tags')) {    
        skipLine = true;
        List<String> tags = List();
        for(int i2 = i+1; i2 < splittedByLine.length; i2++) {
          if(splittedByLine[i2].contains(']')){   //Außer wenn escaped
            skipUntilIndex = i2;
            break;
          } 
          tags.add(splittedByLine[i2]);   //remove first [ and last ]
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
         /* if(splittedByLine[i2].contains(']')){   //Außer wenn im objekt drinne         //TOOOOOOODDDDDDDDD000000000 Endet nicht, bei ]
            print(']');
            break;
          }*/
        
        }

        /*snippets.forEach((snippet) {
          print('-----------new snippet-------------');
          snippet.forEach((line) => print(line));
        });*/
        
          

        value = snippets;
      } 

      if(splittedByDoublePoint.length > 1) {
        if(value == null) {
          value = splittedByDoublePoint[1];
        } 
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
        value = null;
      }
     
    }

    return resutlMap;
  }
}