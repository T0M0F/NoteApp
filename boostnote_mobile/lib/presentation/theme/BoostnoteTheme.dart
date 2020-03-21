import 'package:flutter/material.dart';

class BoostnoteTheme {

  static final String defaultThemeName = 'boostnoteTheme';
  static final List<String> themeNames = <String>[
    'lightTheme',
    'darkTheme',
    'boostnoteTheme'
  ];

  static final ThemeData lightTheme = ThemeData(
    primaryColor: Color(0xFFF6F5F5),
    primaryColorLight: Color(0xFFf2f2f2),
    primaryColorDark:Color(0xDDF6F5F5),
    accentColor: Color(0xFF189d70),
    backgroundColor: Color(0xFFf2f2f2),
    brightness: Brightness.light,
    scaffoldBackgroundColor: Color(0xFFf2f2f2),
    accentColorBrightness: Brightness.light,
    appBarTheme: AppBarTheme(
      color: Color(0xDDF6F5F5),
      elevation: 1
    ),
    buttonColor: Color(0xFF2E3235),
    iconTheme:  IconThemeData(color: Color(0xFF2E3235)),
    primaryIconTheme: IconThemeData(color: Color(0xFFF6F5F5)),
    dividerColor: Colors.black12,
    errorColor: Colors.red,
    indicatorColor: Colors.grey,
    textTheme: TextTheme(
      display1: TextStyle(color: Colors.black, fontSize: 16),    
      display2: TextStyle(color: Colors.grey, fontSize: 16),    
      display3: TextStyle(color: Color(0xFF2E3235), fontSize: 16), 
      title: TextStyle(color: Colors.black, fontSize: 18), 
    ),
    accentTextTheme:TextTheme(
      display1: TextStyle(color: Color(0xFF2E3235), fontSize: 16),  
      title: TextStyle(color: Color(0xFF2E3235), fontSize: 18), 
      display4: TextStyle(color: Colors.black, fontSize: 16)  //used by Markdown code color
    )
  );

 static final ThemeData darkTheme = ThemeData(
    primaryColor: Color(0xFF202120),
    primaryColorLight: Color(0xFF202120),
    primaryColorDark: Colors.black87,
    accentColor: Color(0xFF1EC38B),
    backgroundColor: Color(0xFF202120),
    scaffoldBackgroundColor: Color(0xFF202120),
    dialogBackgroundColor: Color(0xFF2E3235),
    brightness: Brightness.dark,
    accentColorBrightness: Brightness.dark,
    appBarTheme: AppBarTheme(
      color: Color(0xFF202120),
      elevation: 0,
    ),
    buttonColor:  Color(0xF3F5F3F5),  
    iconTheme:  IconThemeData(color: Color(0xF3F5F3F5),  ),
    primaryIconTheme: IconThemeData(color: Colors.black87),
    dividerColor: Color(0xFFF6F5F5),
    errorColor: Colors.red,
    indicatorColor: Color(0xF3F5F3F5),
    textTheme: TextTheme(
      display1: TextStyle(color: Color(0xF3F5F3F5), fontSize: 16),  
      display2: TextStyle(color:Color(0xFFc6c4c6), fontSize: 16), 
      display3: TextStyle(color: Color(0xF3F5F3F5), fontSize: 16), 
      title: TextStyle(color: Color(0xF3F5F3F5), fontSize: 18), 
    ),
    accentTextTheme:TextTheme(
      display1: TextStyle(color: Color(0xF3F5F3F5), fontSize: 16), 
      title: TextStyle(color: Color(0xF3F5F3F5), fontSize: 18), 
      display4: TextStyle(color: Colors.black, fontSize: 16)  //used by Markdown code color
    ),
    
  );

  static final ThemeData boostnoteTheme = ThemeData(
    primaryColor: Color(0xFF202120),
    primaryColorLight: Color(0xFF2E3235),
    primaryColorDark: Colors.black87,
    accentColor: Color(0xFF1EC38B),
    backgroundColor: Colors.white24,
    accentColorBrightness: Brightness.light,
    appBarTheme: AppBarTheme(
      color: Color(0xFF202120),
    ),
    buttonColor: Color(0xFFF6F5F5),
    iconTheme:  IconThemeData(color: Color(0xFF2E3235)),
    dividerColor: Colors.black12,
    errorColor: Colors.red,
    indicatorColor: Colors.grey,
    textTheme: TextTheme(
      display1: TextStyle(color: Colors.black, fontSize: 16),   
      display2: TextStyle(color: Colors.grey, fontSize: 16),   
      display3: TextStyle(color: Color(0xFF2E3235), fontSize: 16),
      title: TextStyle(color: Colors.black, fontSize: 18)
    ),
    accentTextTheme:TextTheme(
      display1: TextStyle(color: Colors.white, fontSize: 16),  
      title: TextStyle(color: Colors.white, fontSize: 18),
      display4: TextStyle(color: Colors.black, fontSize: 16)  //used by Markdown code color
    )
  );

  static ThemeData getTheme(String themeName){
    switch(themeName){
      case 'boostnoteTheme':
        return boostnoteTheme;
      case 'darkTheme':
        return darkTheme;
      case 'lightTheme':
        return lightTheme;
      default:
        return boostnoteTheme;
    }
  }
}