import 'dart:convert';
import 'dart:core';

import 'package:boostnote_mobile/data/cson/CsonModeService.dart';
import 'package:boostnote_mobile/data/cson/ParserUtils.dart';
import 'package:boostnote_mobile/utils/StringUtils.dart';

class CsonParser {

  ParserUtils _parserUtils = ParserUtils();
  StringUtils _stringUtils = StringUtils();
  CsonModeService _csonMode = CsonModeService();

  Map<String, dynamic> parseCson(String cson, String filename) {
    Map<String, dynamic> result = _parse(cson);
    result['id'] = filename.split('.').first;
    return result;
  }

  //TODO special characters in string } ] ''' \
  Map<String, dynamic> _parse(String cson) {

    Map<String, dynamic> resultMap = Map();
    List<String> splittedByLine = LineSplitter.split(cson).toList();

    for(int i = 0; i < splittedByLine.length; i++) {
      List<String> keyValuePair = _stringUtils.splitFirst(splittedByLine[i], ':');
      if(keyValuePair.length < 2) continue; //blank line
      String key = keyValuePair[0].trim();
      dynamic value = keyValuePair[1];

      switch (_csonMode.mode(key, value)) {

        case Mode.SINGLELINE:
          resultMap[key] = _stringUtils.unescape(_parserUtils.removeQuotationMarks(value));
          break;

        case Mode.MULTILINE:
          bool multilineStringIsSingleline = 
            (value as String).replaceFirst("'''", '').endsWith(r"'''")
            && !(value as String).replaceFirst("'''", '').endsWith(r"\'''");
          if(multilineStringIsSingleline) {
            resultMap[key] = _stringUtils.unescape(_parserUtils.removeQuotationMarks(value));
            break;
          }
          for(int i2 = i+1; i2 < splittedByLine.length; i2++) {
            value = value + '\n' + splittedByLine[i2];
            if(splittedByLine[i2].trimRight().endsWith("'''") && !(value as String).trimRight().endsWith(r"\'''")) {
              resultMap[key] = _stringUtils.unescape(_parserUtils.removeQuotationMarks(value));
              i = i2;
              break;
            }
          }
          break;

        case Mode.OBJECT_LIST:
          List<Map<String, dynamic>> list = List();
          String temp = '';
          bool inObject = false;
          for(int i2 = i+1; i2 < splittedByLine.length; i2++) {
            if(splittedByLine[i2].trimLeft().startsWith('{')) {
              inObject = true;
            }
            if(splittedByLine[i2].trimRight().endsWith(']') && inObject == false) {
              /*  Assuming that something like ]} is not legal. Instead end of object ] and end of list } must be in seperate lines.
              String tempWithoutSquareBrackets = splittedByLine[i2].trimRight().substring(0, splittedByLine[i2].trimRight().length-2).trimRight();
              if(tempWithoutSquareBrackets.endsWith('}')){
                temp = temp + '\n' + splittedByLine[i2];
                temp = _clean(temp);
                list.add(parse2(temp));
                temp = '';
              }*/
              resultMap[key] = list;
              i = i2;
              break;
            } else {
              temp = temp + '\n' + splittedByLine[i2];
              if(splittedByLine[i2].trimRight().endsWith('}')) {
                inObject = false;
                temp = _parserUtils.removeQuotationMarks(temp);
                list.add(_parse(temp));
                temp = '';
              }
            }
          }
          break;

        case Mode.SIMPLE_LIST:
          List<dynamic> list = List();
          list.add(_parserUtils.removeBrackets(value));

          bool listStartsAndEndsInSameLine = value.trimRight().endsWith(']');
          if(listStartsAndEndsInSameLine) {
            list.removeWhere((item) => (item as String).isEmpty);
            resultMap[key] = list;
            break;
          }
          
          for(int i2 = i+1; i2 < splittedByLine.length; i2++) {
            String cleanString = _parserUtils.removeQuotationMarks(_parserUtils.removeBrackets(splittedByLine[i2]));
            if(cleanString.length > 0) {
               list.add(_stringUtils.unescape(cleanString));
            }
            if(splittedByLine[i2].trimRight().endsWith(']')) {
              list.removeWhere((item) => (item as String).isEmpty);
              resultMap[key] = list;
              i = i2;
              break;
            }
          }
          break;
      }

    }

    return resultMap;
  }

}