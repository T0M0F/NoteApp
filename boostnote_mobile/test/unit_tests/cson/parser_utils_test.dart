import 'package:boostnote_mobile/data/cson/ParserUtils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

group('Tests for ParserUtils', () {
  ParserUtils parserUtils = ParserUtils();
  test('Should remove square brackets at the start and end of multiline string', () {
    String test = '[test me ] ';
    expect(parserUtils.removeBrackets(test), 'test me ');
  });
  test('Should remove square brackets at the start and end of multiline string', () {
    String test = '''   [test me 
      test [] test test 
      abdefg ]
    test] ''';
    String expected = '''test me 
      test [] test test 
      abdefg ]
    test''';
    expect(parserUtils.removeBrackets(test), expected);
  });
  test('Should remove square brackets only at the start of string', () {
    String test = '''   [test ] me''';
    expect(parserUtils.removeBrackets(test), 'test ] me');
  });
  test('Should remove triple quotation marks at the start and end of multiline string', () {
    String test = '''\'''This is a test! '
    This \''' and this " should only be removed at the start
    "    and end of the multiline string!
    \'''
    remove here -> \''' ''';
    String expected = '''This is a test! '
    This \''' and this " should only be removed at the start
    "    and end of the multiline string!
    \'''
    remove here -> ''';
    expect(parserUtils.removeQuotationMarks(test), expected);
  });

  test('Should remove double quotation marks at the start of string', () {
    String test = '" Test String';
    expect(parserUtils.removeQuotationMarks(test), ' Test String');
  });
});

}