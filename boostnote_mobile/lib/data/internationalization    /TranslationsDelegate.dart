import 'package:boostnote_mobile/data/internationalization%20%20%20%20/Translation.dart';
import 'package:boostnote_mobile/presentation/BoostnoteApp.dart';
import 'package:flutter/material.dart';

class TranslationsDelegate extends LocalizationsDelegate<Translation> {     //Hat nix in data zu suchen
  
  final Locale newLocale;

  const TranslationsDelegate({this.newLocale});

  @override
  bool isSupported(Locale locale) {
    //return BoostnoteApp().supportedLanguages.contains(locale.languageCode);
  }

  @override
  Future<Translation> load(Locale locale) {
    return Translation.load(newLocale ?? locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<Translation> old) {
    return true;
  }
}