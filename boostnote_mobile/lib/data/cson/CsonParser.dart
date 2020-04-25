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
          resultMap[key] = _clean(value);
          break;

        case Mode.MULTILINE:
          if(_isMultiLineStringASingleLine(value)) {
            resultMap[key] = _clean(value);
            break;
          }
          for(int i2 = i+1; i2 < splittedByLine.length; i2++) {
            value = value + '\n' + splittedByLine[i2];
            bool isEndOfMultiLineString = splittedByLine[i2].trimRight().endsWith("'''") && !(value as String).trimRight().endsWith(r"\'''");
            if(isEndOfMultiLineString) {
              resultMap[key] = _stringUtils.unescape(_parserUtils.removeQuotationMarks(value));
              i = i2;
              break;
            }
          }
          break;

        case Mode.OBJECT_LIST: //Assumption: [{ or }] is not legal, instead [ and { must be in seperate lines 
          List<Map<String, dynamic>> list = List();
          String temp = '';
          bool isInMultiLine = false;
          bool inObject = false;
          for(int i2 = i+1; i2 < splittedByLine.length; i2++) {
            //isInMultiLine = _checkIfWithinMultiLineString(splittedByLine[i2], isInMultiLine);

            List<String> pair = _stringUtils.splitFirst(splittedByLine[i2], ':');
            if(pair.length >= 2) {
              String key1 = pair[0].trim();
              dynamic value1 = pair[1];
              if(!isInMultiLine) {
                isInMultiLine = _csonMode.mode(key1, value1) == Mode.MULTILINE;
                if(_isMultiLineStringASingleLine(value1)) {
                  isInMultiLine = false;
                }
              } else {
                isInMultiLine = !_isEndOfMultiLineString(value1);
              }
            } else if(isInMultiLine) {
              isInMultiLine = !_isEndOfMultiLineString(splittedByLine[i2]);
            }
              
            bool startOfObject = splittedByLine[i2].trimLeft().startsWith('{') && isInMultiLine == false;
            if(startOfObject) {
              inObject = true;
            }
            bool endOfList = splittedByLine[i2].trimRight().endsWith(']') && isInMultiLine == false && !inObject;
            if(endOfList) {
              resultMap[key] = list;
              i = i2;
              break;
            } else {
              temp = temp + '\n' + splittedByLine[i2];
              bool endOfObject = splittedByLine[i2].trimRight().endsWith('}') && isInMultiLine == false;
              if(endOfObject) { 
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

  bool _checkIfWithinMultiLineString(line, bool isInMultiLine) {
    List<String> pair = _stringUtils.splitFirst(line, ':');
    if(pair.length >= 2) {
      String key1 = pair[0].trim();
      dynamic value1 = pair[1];
      if(!isInMultiLine) {
        isInMultiLine = _csonMode.mode(key1, value1) == Mode.MULTILINE;
        isInMultiLine = !_isMultiLineStringASingleLine(value1);  //'''This is a single Line'''
      } else {
        isInMultiLine = !_isEndOfMultiLineString(value1);
      }
    } else if(isInMultiLine) {
      isInMultiLine = !_isEndOfMultiLineString(line);
    }
    return isInMultiLine;
  }

  String _clean(value) => _stringUtils.unescape(_parserUtils.removeQuotationMarks(value));

  bool _isEndOfMultiLineString(String line) {
    return line.trimRight().endsWith("'''") 
          && !line.trimRight().endsWith(r"\'''");
  }

  bool _isMultiLineStringASingleLine(String line) {
    return line.replaceFirst("'''", '').endsWith(r"'''")
          && !line.replaceFirst("'''", '').endsWith(r"\'''");
  }

}