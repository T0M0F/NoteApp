import 'package:boostnote_mobile/data/internationalization%20%20%20%20/Translation.dart';
import 'package:boostnote_mobile/presentation/navigation/NavigationService.dart';
import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
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

  @override
  void initState() {
    super.initState();

    
  }

  @override
  Widget build(BuildContext context) {

    String text = '''
  sdsd
  '
  affsa
  \'''
  sadfsdf
  \''' sdaf \'''
  
  \\
  \\\\
''';
  String text2 = text.replaceAll("\\\\", '');



    String s = 'kfljsk\\asidfjksdlf';
    String b;
    
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
        initialRoute: 'abc',
        routes: {
          'abc': (context) => Scaffold(
            body: Padding(
              padding: EdgeInsets.only(top: 100),
              child: Column(children: <Widget>[
              MarkdownBody(data:text),
              MarkdownBody(data:text2),
              TextField(
                
               maxLines: null,
                onChanged: (a) {
                  setState(() {
                    s = escape(a);
                    b = toPrintable(s);
                  });
                })
            ],)
            )
          ),
          '/': (context) {
            return WillPopScope(
              child: NotesPage(pageTitle: AppLocalizations.of(context).translate('all_notes')),
              onWillPop: () {
                return Future.value(true);
                                /*
                PageNavigator().navigateBack();
                if(MediaQuery.of(context).size.width > 1200) {
                  if(PageNavigator().pageNavigatorState == PageNavigatorState.ALL_NOTES) {
                    //Kill app
                  } else {
                    Navigator.of(context).pop();
                  }
                } else {
                  if(NoteIsOpen){
                    note == null
                  } else if(PageNavigator().pageNavigatorState == PageNavigatorState.ALL_NOTES){
                    //Kill app
                  } else {
                    Navigator.of(context).pop();
                  }
                }
                */
              },
            );
          },
        },
    );
  }

  Widget _buildBody2() {
    return WillPopScope(
      child: Scaffold(
        appBar: CustomAppbar(),
        body: ResponsiveWidget(widgets: <ResponsiveChild> [
            ResponsiveChild(
              smallFlex: 1, 
              largeFlex: 1, 
              child: Container(color: Colors.red)
            ),
            ResponsiveChild(
              smallFlex: 0, 
              largeFlex: 1, 
              child: Container(color: Colors.green)
            )
          ]
        ), 
      ),
      onWillPop: () { //TODO fix
       
      }
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