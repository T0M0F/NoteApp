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
  });
  
}