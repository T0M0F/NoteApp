import 'package:boostnote_mobile/utils/StringUtils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  StringUtils stringUtils = StringUtils();
  group('Tests for StringUtils', (){
    
    test("This should split the string at the first : ", () {
      String test = 'linesHighlighted:[1]';
      List<String> expected = [
        'linesHighlighted',
        '[1]'
      ];
      expect(stringUtils.splitFirst(test, ':'), expected);
    });

    test("This should split the string at the first . ", () {
      String test = 'Splitte hier.Aber nicht hier.Verstanden?';
      List<String> expected = [
        'Splitte hier',
        'Aber nicht hier.Verstanden?'
      ];
      expect(stringUtils.splitFirst(test, '.'), expected);
    });

    test("This should escape all triple quation marks and backslashes", () {
      String test = ''' 
      Escape this \''' and this \'''
      and this \\. But not this ''
      ''';
      String expected = ''' 
      Escape this \\\''' and this \\\'''
      and this \\\\. But not this ''
      ''';
      expect(stringUtils.escape(test), expected);
    });

    test("This should escape backslash", () {
      String test = r" \ TESTTEST ";
      String expected = r" \\ TESTTEST ";
      expect(stringUtils.escape(test), expected);
    });

    test("This should unescape all triple quation marks and backslashes " , () {
      String test = ''' 
      Unescape this \\\''' and this \\\'''
      and this \\\\. But not this ''
      ''';
      String expected = ''' 
      Unescape this \''' and this \'''
      and this \\. But not this ''
      ''';
      expect(stringUtils.unescape(test), expected);
    });

    test("This should unescape triple quation marks", () {
      String test = r" \''' TESTTEST ";
      String expected = r" ''' TESTTEST ";
      expect(stringUtils.unescape(test), expected);
    });

    test("This should unescape backslash", () {
      String test = r" \\ TESTTEST ";
      String expected = r" \ TESTTEST ";
      expect(stringUtils.unescape(test), expected);
    });
  });

}