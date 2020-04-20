import 'package:boostnote_mobile/data/cson/CsonParser.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){

  CsonParser csonParser = CsonParser();

  test('Should convert cson string to map', () {
    Map<String, dynamic> result = csonParser.parseCson(csonString, 'abcde.cson');
    expect(result, expectedMap);
  });

}

Map<String, dynamic> expectedMap = {
  'id': 'abcde',
  'createdAt': '2020-01-10T08:45:20.122Z',
  'updatedAt': '2020-04-04T08:52:14.683Z',
  'type': 'MARKDOWN_NOTE',
  'folder': 'f6b3ec63a3b965e19713',
  'title': 'Welcome to Boostnote!',
  'content': 'Das ist ein Test!',
  'tags': List(),
  'isStarred': 'false',
  'isTrashed': 'false',
  'linesHighlighted': List(),
};


String csonString = '''
createdAt: "2020-01-10T08:45:20.122Z"
updatedAt: "2020-04-04T08:52:14.683Z"
type: "MARKDOWN_NOTE"
folder: "f6b3ec63a3b965e19713"
title: "Welcome to Boostnote!"
content: "Das ist ein Test!"
tags: []
isStarred: false
isTrashed: false
linesHighlighted: []
''';