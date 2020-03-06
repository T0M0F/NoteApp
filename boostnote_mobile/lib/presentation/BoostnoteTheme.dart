import 'package:flutter/material.dart';

class BoostnoteTheme {

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
    accentColor: Color(0xFF1EC38B),
    hintColor: Colors.white
  );
}