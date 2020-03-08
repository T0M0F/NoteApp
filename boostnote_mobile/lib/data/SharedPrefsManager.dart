import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsManager {

  Future<SharedPreferences> get sharedPrefs async {
    var sharedPrefs = await SharedPreferences.getInstance();
    return sharedPrefs;
  }

  Future<void> changeTheme(String themeName) async {
    final SharedPreferences prefs = await sharedPrefs;
    prefs.setString('theme', themeName);
  }

  Future<String> getThemeName() async {
     final SharedPreferences prefs = await sharedPrefs;
     return prefs.getString('theme');
  }
  
}