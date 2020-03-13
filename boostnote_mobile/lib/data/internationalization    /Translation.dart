import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class Translation {  //Hat nix in data zu suchen

  //https://www.didierboelens.com/2018/04/internationalization---make-an-flutter-application-multi-lingual/
  //https://www.developerlibs.com/2019/03/flutter-localization-or-multi-language-example.html
  
  static Map<dynamic, dynamic> _values;
  Locale locale;

  Translation(this.locale);

  static Translation of(BuildContext context) {
    return Localizations.of<Translation>(context, Translation);
  }

  static Future<Translation> load(Locale locale) async {
    Translation appTranslations = Translation(locale);
    String jsonContent = await rootBundle.loadString("assets/translations/${locale.languageCode}.json");
    _values = json.decode(jsonContent);
    return appTranslations;
  }

  get currentLanguage => locale.languageCode;

  String text(String key) => _values[key] ?? "$key not found";
}