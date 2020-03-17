import 'package:flutter/material.dart';

class BoostnoteTheme {

  static final String defaultThemeName = 'boostnoteTheme';
  static final List<String> themeNames = <String>[
    'lightTheme',
    'darkTheme',
    'boostnoteTheme'
  ];

  static final ThemeData lightTheme = ThemeData(
    primaryColor: Colors.blue,
    brightness: Brightness.light,
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: Colors.grey,
    brightness: Brightness.dark,
  );

  static final ThemeData boostnoteTheme = ThemeData(
    primaryColor: Color(0xFF202120),
    primaryColorLight: Color(0xFF2E3235),
    primaryColorDark: Colors.black,
    accentColor: Color(0xFF1EC38B),
    hintColor: Colors.white,
    buttonColor: Color(0xFFF6F5F5)
  );

  static ThemeData getTheme(String themeName){
    switch(themeName){
      case 'boostnoteTheme':
        return boostnoteTheme;
      case 'darkTheme':
        return darkTheme;
      case 'lighTheme':
        return lightTheme;
      default:
        return boostnoteTheme;
    }
  }
}