import 'package:flutter/material.dart';

class ThemeNotifier with ChangeNotifier {

  //https://medium.com/better-programming/how-to-create-a-dynamic-theme-in-flutter-using-provider-e6ad1f023899
  //https://rxlabz.github.io/panache_web/#/editor

  ThemeData _themeData;

  ThemeNotifier(this._themeData);

  getTheme() => _themeData;

  setTheme(ThemeData themeData) async {
    _themeData = themeData;
    notifyListeners();
  }

}