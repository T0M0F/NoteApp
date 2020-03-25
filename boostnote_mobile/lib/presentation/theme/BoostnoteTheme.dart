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
    backgroundColor: Color(0xFFf2f2f2),
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

  static final Map<String, TextStyle> lightEditorTheme = {
    'comment': TextStyle(color: Color(0xff696969)),
    'quote': TextStyle(color: Color(0xff696969)),
    'variable': TextStyle(color: Color(0xffd91e18)),
    'template-variable': TextStyle(color: Color(0xffd91e18)),
    'tag': TextStyle(color: Color(0xffd91e18)),
    'name': TextStyle(color: Color(0xffd91e18)),
    'selector-id': TextStyle(color: Color(0xffd91e18)),
    'selector-class': TextStyle(color: Color(0xffd91e18)),
    'regexp': TextStyle(color: Color(0xffd91e18)),
    'deletion': TextStyle(color: Color(0xffd91e18)),
    'number': TextStyle(color: Color(0xffaa5d00)),
    'built_in': TextStyle(color: Color(0xffaa5d00)),
    'builtin-name': TextStyle(color: Color(0xffaa5d00)),
    'literal': TextStyle(color: Color(0xffaa5d00)),
    'type': TextStyle(color: Color(0xffaa5d00)),
    'params': TextStyle(color: Color(0xffaa5d00)),
    'meta': TextStyle(color: Color(0xffaa5d00)),
    'link': TextStyle(color: Color(0xffaa5d00)),
    'attribute': TextStyle(color: Color(0xffaa5d00)),
    'string': TextStyle(color: Color(0xff008000)),
    'symbol': TextStyle(color: Color(0xff008000)),
    'bullet': TextStyle(color: Color(0xff008000)),
    'addition': TextStyle(color: Color(0xff008000)),
    'title': TextStyle(color: Color(0xff007faa)),
    'section': TextStyle(color: Color(0xff007faa)),
    'keyword': TextStyle(color: Color(0xff7928a1)),
    'selector-tag': TextStyle(color: Color(0xff7928a1)),
    'root':
        TextStyle(backgroundColor: Color(0xFFf2f2f2), color: Color(0xff545454)),
    'emphasis': TextStyle(fontStyle: FontStyle.italic),
    'strong': TextStyle(fontWeight: FontWeight.bold),
  };

  static final Map<String, TextStyle> darkEditorTheme = {
    'comment': TextStyle(color: Color(0xffd4d0ab)),
    'quote': TextStyle(color: Color(0xffd4d0ab)),
    'variable': TextStyle(color: Color(0xffffa07a)),
    'template-variable': TextStyle(color: Color(0xffffa07a)),
    'tag': TextStyle(color: Color(0xffffa07a)),
    'name': TextStyle(color: Color(0xffffa07a)),
    'selector-id': TextStyle(color: Color(0xffffa07a)),
    'selector-class': TextStyle(color: Color(0xffffa07a)),
    'regexp': TextStyle(color: Color(0xffffa07a)),
    'deletion': TextStyle(color: Color(0xffffa07a)),
    'number': TextStyle(color: Color(0xfff5ab35)),
    'built_in': TextStyle(color: Color(0xfff5ab35)),
    'builtin-name': TextStyle(color: Color(0xfff5ab35)),
    'literal': TextStyle(color: Color(0xfff5ab35)),
    'type': TextStyle(color: Color(0xfff5ab35)),
    'params': TextStyle(color: Color(0xfff5ab35)),
    'meta': TextStyle(color: Color(0xfff5ab35)),
    'link': TextStyle(color: Color(0xfff5ab35)),
    'attribute': TextStyle(color: Color(0xffffd700)),
    'string': TextStyle(color: Color(0xffabe338)),
    'symbol': TextStyle(color: Color(0xffabe338)),
    'bullet': TextStyle(color: Color(0xffabe338)),
    'addition': TextStyle(color: Color(0xffabe338)),
    'title': TextStyle(color: Color(0xff00e0e0)),
    'section': TextStyle(color: Color(0xff00e0e0)),
    'keyword': TextStyle(color: Color(0xffdcc6e0)),
    'selector-tag': TextStyle(color: Color(0xffdcc6e0)),
    'root':
        TextStyle(backgroundColor: Color(0xFF202120), color: Color(0xfff8f8f2)),
    'emphasis': TextStyle(fontStyle: FontStyle.italic),
    'strong': TextStyle(fontWeight: FontWeight.bold),
  };

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