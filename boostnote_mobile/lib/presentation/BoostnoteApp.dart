
import 'package:boostnote_mobile/presentation/NewNavigationService.dart';
import 'package:boostnote_mobile/presentation/ThemeNotifier.dart';
import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:boostnote_mobile/presentation/screens/note_overview/Overview.dart';
import 'package:boostnote_mobile/presentation/widgets/appbar/CustomAppbar.dart';
import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveChild.dart';
import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

class BoostnoteApp extends StatefulWidget {

  @override
  _BoostnoteAppState createState() => _BoostnoteAppState();

}

class _BoostnoteAppState extends State<BoostnoteApp> {

  @override
  Widget build(BuildContext context) {
    
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));

/*
    CsonParser csonParser = CsonParser();
    Map<String,dynamic> result = csonParser.parse(csonParser.cson);
    print('---------------------Result--------------------');
    result.forEach((key,value) {
      if(value is List) {
        print('key is: ' + key + ' value is List: ' );
        value.forEach((val) {
          if(val is List) {
            print('----------');
            val.forEach((item) => print(item));
          } else if(val is Map) {
            print('-------------------------------');
            val.forEach((k,v) =>  print('------key : ' + k + ' value : ' + v.toString()));
          } else {
            print(val);
          }
        });
      } else {
        print('key is: ' + key + ' value is: ' + value);
      }
    });

    Note note = csonParser.convertToNote(result);
    
    print('--------------------------------------- MarkdownNote to cson----------------------------');
    print(csonParser.convertMarkdownNoteToCson(NoteService().generateMarkdownNote()));
    print('--------------------------------------- SnippetNote to cson----------------------------');
    print(csonParser.convertSnippetNoteToCson(NoteService().generateSnippetNote()));
*/
    final ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
        title: 'Boostnote',
        debugShowCheckedModeBanner: false,
        theme: themeNotifier.getTheme(),
        /*ThemeData(
          primaryColor: Color(0xFF202120),
          primaryColorLight: Color(0xFF2E3235),
          accentColor: Color(0xFF1EC38B),
          hintColor: Colors.white,
        ),*/
        localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: AppLocalizations.supportedLanguages,
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode && supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }
          print(locale.languageCode + ' not supported. Load default: ' + supportedLocales.first.languageCode);
          return supportedLocales.first;
        },
        initialRoute: '/',
        routes: {
          '/test': (context) => Overview(),
          '/': (context) => _buildBody(),
        },
    );
  }

  Widget _buildBody() {
    return WillPopScope(
      child: ResponsiveWidget(widgets: <ResponsiveChild> [
        ResponsiveChild(
          smallFlex: 1, 
          largeFlex: 2, 
          child: Overview()
        ),
        ResponsiveChild(
          smallFlex: 0, 
          largeFlex: 3, 
          child: Scaffold(
            appBar: AppBar(),
            body: Container()
            )
        )
      ]
      ), 
      onWillPop: () {
        NewNavigationService().navigateBack(context);
      }
    );
  }

}