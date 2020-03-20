import 'package:boostnote_mobile/presentation/navigation/NavigationService.dart';
import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:boostnote_mobile/presentation/screens/note_overview/Overview.dart';
import 'package:boostnote_mobile/presentation/theme/ThemeNotifier.dart';
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
      onWillPop: () { //TODO fix
        NavigationService().navigateBack(context);
      }
    );
  }

}