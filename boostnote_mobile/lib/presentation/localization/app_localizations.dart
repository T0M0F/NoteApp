import 'dart:async';
import 'dart:convert';

import 'package:boostnote_mobile/presentation/localization/AppLocalizationsDelegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {

  //https://resocoder.com/2019/06/01/flutter-localization-the-easy-way-internationalization-with-json/

  static const LocalizationsDelegate<AppLocalizations> delegate = AppLocalizationsDelegate();

  static const List<Locale> supportedLocales =  [
    const Locale("en", "EN"),
    const Locale("de", "DE"),
  ];

  static const List<String> supportedLanguages = ['en', 'de'];

  final Locale locale;
  Map<String, String> _localizedStrings;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) => Localizations.of<AppLocalizations>(context, AppLocalizations);

  Future<bool> load() async {
    String jsonString = await rootBundle.loadString("assets/translations/${locale.languageCode}.json");
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
    return true;
  }

  String translate(String key) => _localizedStrings[key] ?? "$key not found";
}


