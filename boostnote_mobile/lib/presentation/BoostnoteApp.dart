import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/data/CsonParser.dart';
import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteOverviewNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/SnippetNotifier.dart';
import 'package:boostnote_mobile/presentation/pages/NotesPage.dart';
import 'package:boostnote_mobile/presentation/pages/PageNavigator.dart';
import 'package:boostnote_mobile/presentation/theme/ThemeNotifier.dart';
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

 
  _test() {
    CsonParser csonParser = CsonParser();
    Map<String,dynamic> map = csonParser.parse2(CsonParser().cson2);
    Note note = csonParser.convertToNote(map);
    print(note);
  }

  @override
  Widget build(BuildContext context) {

    _test();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    final ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    
    return MaterialApp(
        title: 'Boostnote',
        debugShowCheckedModeBanner: false,
        theme: themeNotifier.getTheme(),
        localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: AppLocalizations.supportedLocales,
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
          '/': (context) {
           
            return NotesPage();
            //Todo Die andederen Routes hier ergänzen
          },
        },
    );
  }
}