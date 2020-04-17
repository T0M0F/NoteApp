import 'package:boostnote_mobile/data/SharedPrefsManager.dart';
import 'package:boostnote_mobile/presentation/themes/AppTheme.dart';
import 'package:boostnote_mobile/presentation/themes/EditorTheme.dart';
import 'package:flutter/material.dart';

class ThemeService {

  final SharedPrefsManager _sharedPrefsManager = new SharedPrefsManager();

  Future<ThemeData> getThemeData() async {
    String themeName = await _sharedPrefsManager.getThemeName();
    return AppTheme.getTheme(themeName);
  }

  Future<String> getThemeName() async {
    return _sharedPrefsManager.getThemeName();
  }

  void changeTheme(String themeName) {
    _sharedPrefsManager.changeTheme(themeName);
  }

  Map<String, TextStyle> getEditorTheme(BuildContext context) {
    return Theme.of(context).backgroundColor.value == Color(0xFF202120).value ? EditorTheme.darkEditorTheme : EditorTheme.lightEditorTheme;
  }

}