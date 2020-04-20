import 'package:boostnote_mobile/data/cson/CsonModeService.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  group('Tests for CsonModeService ', () {
    CsonModeService modeService = CsonModeService();
    test('Mode should be SINGLELINE', () {
      expect(modeService.mode('id', 'abcdedfg'), Mode.SINGLELINE);
    });
    test('Mode should be MULTILINE', () {
      String value = '''\'''
        This is a
        multiline string!
      \'''''';
      expect(modeService.mode('content', value), Mode.MULTILINE);
    });
    test('Mode should be SIMPLE_LIST', () {
      String value = '''[
        "tag1", "tag2", "tag3"
      ]''';
      expect(modeService.mode('tags', value), Mode.SIMPLE_LIST);
    });
    test('Mode should be SIMPLE_LIST', () {
      String value = '''[1,2,3]''';
      expect(modeService.mode('linesHighlighted', value), Mode.SIMPLE_LIST);
    });
    test('Mode should be OBJECT_LIST', () {
      String value = '''[
        {
          "title"="TEST"
          "content"="TEST TEST"
        }
      ]''';
      expect(modeService.mode('snippets',value), Mode.OBJECT_LIST);
    });
  });

}