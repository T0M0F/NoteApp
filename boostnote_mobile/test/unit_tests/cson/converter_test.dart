import 'package:boostnote_mobile/business_logic/model/Folder.dart';
import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:boostnote_mobile/business_logic/repository/FolderRepository.dart';
import 'package:boostnote_mobile/data/cson/CsonConverter.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mocks/FolderRepositoryMock.dart';

void main(){
  
  TestWidgetsFlutterBinding.ensureInitialized();

  FolderRepository folderRepository = FolderRepositoryMock();
  CsonConverter csonConverter = CsonConverter(folderRepository: folderRepository);
  Folder testFolder = Folder(id: 'f6b3ec63a3b965e19713', name: 'Folder');

  setUp(() {
    folderRepository.save(testFolder);
  });
 
  test('Should convert map to markdown note', () async {
    MarkdownNote markdownNote = await csonConverter.convertToNote(markdownNoteMap);
    MarkdownNote expectedMarkdownNote = MarkdownNote(
      id: 'abcde',
      createdAt:  DateTime.parse('2020-01-10T08:45:20.122Z'),
      updatedAt: DateTime.parse('2020-04-04T08:52:14.683Z'),
      title: 'Welcome to Boostnote!',
      folder: await folderRepository.findById('f6b3ec63a3b965e19713'),
      content: 'Das ist ein Test!',
      isStarred: false,
      isTrashed: false,
      tags: List()
    );
    expect(markdownNote, expectedMarkdownNote);
  });

  test('Should convert map to snippet note', () async {
    SnippetNote snippetNote = await csonConverter.convertToNote(snippetNoteMap);
    SnippetNote expectedSnippetNote = SnippetNote(
      id: 'abcde',
      createdAt:  DateTime.parse('2020-01-10T08:45:20.122Z'),
      updatedAt: DateTime.parse('2020-04-04T08:52:14.683Z'),
      title: 'Welcome to Boostnote!',
      folder: await folderRepository.findById('f6b3ec63a3b965e19713'),
      description: 'Das ist ein Test!',
      isStarred: false,
      isTrashed: true,
      tags: List(),
      codeSnippets: [
        CodeSnippet(
          content: '''
            System.out.println("TEST");
          ''',
          linesHighlighted: [1,2],
          mode: 'java',
          name: 'snippet'
        ),
        CodeSnippet(
          content: r'''
            var name = 'Peter';
            print('Hello $name!)';
            while(true) {
              print('+1000\$');
            }
          ''',
          linesHighlighted: [],
          mode: 'dart',
          name: 'Snippet2'
        )
      ]
    );
    expect(snippetNote, expectedSnippetNote);
  });

}

Map<String, dynamic> markdownNoteMap = {
  'id': 'abcde',
  'createdAt': '2020-01-10T08:45:20.122Z',
  'updatedAt': '2020-04-04T08:52:14.683Z',
  'type': 'MARKDOWN_NOTE',
  'folder': 'f6b3ec63a3b965e19713',
  'title': 'Welcome to Boostnote!',
  'content': 'Das ist ein Test!',
  'tags': List(),
  'isStarred': 'false',
  'isTrashed': 'true',
  'linesHighlighted': List(),
};


Map<String, dynamic> snippetNoteMap = {
  'id': 'abcde',
  'createdAt': '2020-01-10T08:45:20.122Z',
  'updatedAt': '2020-04-04T08:52:14.683Z',
  'type': 'SNIPPET_NOTE',
  'folder': 'f6b3ec63a3b965e19713',
  'title': 'Welcome to Boostnote!',
  'description': 'Das ist ein Test!',
  'content': 'Das ist ein Test!',
  'tags': List(),
  'isStarred': 'false',
  'isTrashed': 'true',
  'snippets': [
    {
      'name':'snippet',
      'mode':'java',
      'content':'''
      System.out.println("TEST");
      ''',
      'linesHighlighted': ['1','2']
    }, 
    {
      'name':'Snippet2',
      'mode':'dart',
      'content':r'''
        var name = 'Peter';
        print('Hello $name!)';
        while(true) {
          print('+1000\$');
        }
      ''',
      'linesHighlighted': []
    }
  ],
};
