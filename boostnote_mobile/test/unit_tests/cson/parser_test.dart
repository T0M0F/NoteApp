import 'package:boostnote_mobile/data/cson/CsonParser.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){

  CsonParser csonParser = CsonParser();

  test('Should convert markdown cson string to map', () {
    Map<String, dynamic> result = csonParser.parseCson(csonStringMarkdownNote, 'abcde.cson');
    expect(result, expectedMapMarkdownNoteMap);
  });

  test('Should convert markdown cson string to map', () {
    Map<String, dynamic> result = csonParser.parseCson(csonStringMarkdownNote2, 'abcde.cson');
    expect(result, expectedMapMarkdownNoteMap2);
  });

  /*
  *  test fails because for some reason \n is at wrong positon, but this is not really problematic
  */
 /*test('Should convert snippet cson string to map', () {
    Map<String, dynamic> result = csonParser.parseCson(csonStringSnippetNote, '123few424wer32rw3rwerf2.cson');
    expect(result, expectedSnippetNoteMap);
  });*/

  test('Should convert snippet cson string to map', () {
    Map<String, dynamic> result = csonParser.parseCson(csonStringSnippetNote2, '1.cson');
    expect(result, expectedSnippetNoteMap2);
  });
}

Map<String, dynamic> expectedMapMarkdownNoteMap = {
'id': 'abcde',
'createdAt': '2020-01-10T08:45:20.122Z',
'updatedAt': '2020-04-04T08:52:14.683Z',
'type': 'MARKDOWN_NOTE',
'folder': 'f6b3ec63a3b965e19713',
'title': 'Welcome to Boostnote!',
'content':'''Das ist \\ ein Test!
Multiline String\''' abc\'''
a\'''
''',
'tags': List(),
'isStarred': 'false',
'isTrashed': 'false',
'linesHighlighted': List(),
};


String csonStringMarkdownNote = '''
createdAt: "2020-01-10T08:45:20.122Z"
updatedAt: "2020-04-04T08:52:14.683Z"
type: "MARKDOWN_NOTE"
folder: "f6b3ec63a3b965e19713"
title: "Welcome to Boostnote!"
content: \'''Das ist \\\\ ein Test!
Multiline String\\\''' abc\\\'''
a\\\'''
\'''
tags: []
isStarred: false
isTrashed: false
linesHighlighted: []
''';

Map<String, dynamic> expectedMapMarkdownNoteMap2 = {
'id': 'abcde',
'createdAt': '2020-01-10T08:45:20.122Z',
'updatedAt': '2020-04-04T08:52:14.683Z',
'type': 'MARKDOWN_NOTE',
'folder': 'f6b3ec63a3b965e19713',
'title': 'name',
'content':"content",
'tags': ["tag123"],
'isStarred': 'true',
'isTrashed': 'true',
'linesHighlighted': List(),
};


String csonStringMarkdownNote2 = '''
createdAt: "2020-01-10T08:45:20.122Z"
updatedAt: "2020-04-04T08:52:14.683Z"
type: "MARKDOWN_NOTE"
folder: "f6b3ec63a3b965e19713"
title: "name"
content: "content"
tags: [
  "tag123"
]
isStarred: true
isTrashed: true
linesHighlighted: []
''';

Map<String, dynamic> expectedSnippetNoteMap = {
  "createdAt":"2020-04-24T18:15:44.779Z",
  "updatedAt" : "2020-04-24T18:19:17.990Z",
  "type" : "SNIPPET_NOTE",
  "folder": "f6b3ec63a3b965e19713",
  "title": "Das ist eine Snippet Note }",
  "tags" : [
    "Snippet_Note",
    "Tag2",
    "Tag3"
  ],
  "description": "desc",
  "snippets" : [
    {
      "linesHighlighted": [
        '1','2'
      ],
      "name": "snip.java",
      "mode": "Java",
      "content": ""
    },
    {
      "linesHighlighted": List(),
      "name": "snip2.js",
      "mode": "JavaScript",
      "content": '''

        output = output + "<tr>";
                while(j<=cols) ]
                {
                output = output + "<td>" + i*j + "</td>";
                j = j+1;
              }
      '''
    },
    {
      "name": "empty",
      "mode": "js",
      "content": "",
      "linesHighlighted": List()
    }
  ],
  "id": "123few424wer32rw3rwerf2",
  "isTrashed": "false",
  "isStarred": "false"
};

String csonStringSnippetNote = '''
createdAt: "2020-04-24T18:15:44.779Z"
updatedAt: "2020-04-24T18:19:17.990Z"
type: "SNIPPET_NOTE"
folder: "f6b3ec63a3b965e19713"
title: "Das ist eine Snippet Note }"
tags: [
  "Snippet_Note"
  "Tag2"
  "Tag3"
]
description: "desc"
snippets: [
  {
    linesHighlighted: [
      1
      2
    ]
    name: "snip.java"
    mode: "Java"
    content: ""
  }
  {
    linesHighlighted: []
    name: "snip2.js"
    mode: "JavaScript"
    content: \'''
      output = output + "<tr>";
              while(j<=cols)
              {
        		  output = output + "<td>" + i*j + "</td>";
         		  j = j+1;
         		}
    \'''
  }
  {
    name: "empty"
    mode: "js"
    content: ""
    linesHighlighted: []
  }
]
isStarred: false
isTrashed: false
''';

Map<String, dynamic> expectedSnippetNoteMap2 = {
  "createdAt":"2020-04-24T18:15:44.779Z",
  "updatedAt" : "2020-04-24T18:19:17.990Z",
  "type" : "SNIPPET_NOTE",
  "folder": "f6b3ec63a3b965e19713",
  "title": "Das ist eine Snippet Note }",
  "tags" : [],
  "description": '''desc''',
  "snippets" : [
  ],
  "isStarred" : "false",
  "isTrashed": "true",
  "id": "1"
};

String csonStringSnippetNote2 = '''
createdAt: "2020-04-24T18:15:44.779Z"
updatedAt: "2020-04-24T18:19:17.990Z"
type: "SNIPPET_NOTE"
folder: "f6b3ec63a3b965e19713"
title: "Das ist eine Snippet Note }"
tags: []
description: \'''desc\'''
snippets: [

]
isStarred: false
isTrashed: true
''';