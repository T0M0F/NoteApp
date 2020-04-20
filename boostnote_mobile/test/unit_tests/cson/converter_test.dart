import 'package:boostnote_mobile/business_logic/model/Folder.dart';
import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/repository/FolderRepository.dart';
import 'package:boostnote_mobile/data/cson/CsonConverter.dart';
import 'package:boostnote_mobile/data/repositoryImpl/jsonImpl/FolderRepositoryImpl.dart';
import 'package:flutter_test/flutter_test.dart';


//TODO Mock PathProvider
void main(){
  /*
  TestWidgetsFlutterBinding.ensureInitialized();

  CsonConverter csonConverter = CsonConverter();
  FolderRepository folderRepository = FolderRepositoryImpl();
  Folder testFolder = Folder(id: 'abcde', name: 'Folder');

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
      folder: await folderRepository.findById('abcde'),
      content: 'Das ist ein Test!',
      isStarred: false,
      isTrashed: false,
      tags: List(),
    );
    expect(markdownNote, expectedMarkdownNote);
  });

  tearDown(() {
    folderRepository.delete(testFolder);
  });
*/
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
  'isTrashed': 'false',
  'linesHighlighted': List(),
};
