import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/data/CsonParser.dart';
import 'package:boostnote_mobile/data/internationalization%20%20%20%20/Translation.dart';
import 'package:boostnote_mobile/presentation/navigation/NavigationService.dart';
import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/SnippetNotifier.dart';
import 'package:boostnote_mobile/presentation/pages/NotesPage.dart';
import 'package:boostnote_mobile/presentation/pages/PageNavigator.dart';
import 'package:boostnote_mobile/presentation/screens/note_overview/Overview.dart';
import 'package:boostnote_mobile/presentation/theme/ThemeNotifier.dart';
import 'package:boostnote_mobile/presentation/widgets/appbar/CustomAppbar.dart';
import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveChild.dart';
import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:strings/strings.dart';

class BoostnoteApp extends StatefulWidget {

  @override
  _BoostnoteAppState createState() => _BoostnoteAppState();

}

class _BoostnoteAppState extends State<BoostnoteApp> {

 
  _test() {
    CsonParser csonParser = CsonParser();
    Note note = csonParser.convertToNote(csonParser.parse2(CsonParser().cson2));
  }

  @override
  Widget build(BuildContext context) {

    _test();
    return null;
    
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
            return WillPopScope(
              child: NotesPage(pageTitle: AppLocalizations.of(context).translate('all_notes')),
              onWillPop: () {
               // return Future.value(true);
                NoteNotifier _noteNotifier = Provider.of<NoteNotifier>(context);
                SnippetNotifier snippetNotifier = Provider.of<SnippetNotifier>(context);
                if(_noteNotifier.note != null){
                  _noteNotifier.note = null;
                  snippetNotifier.selectedCodeSnippet = null;
                } else if(PageNavigator().pageNavigatorState == PageNavigatorState.ALL_NOTES){
                  SystemNavigator.pop();
                } else {
                  PageNavigator().navigateBack();
                  Navigator.of(context).pop();
                }
              },
            );
          },
        },
    );
  }
}