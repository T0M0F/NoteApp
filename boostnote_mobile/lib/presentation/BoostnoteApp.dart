
import 'package:boostnote_mobile/presentation/screens/Splashscreen.dart';
import 'package:boostnote_mobile/presentation/screens/note_overview/Overview.dart';
import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveChild.dart';
import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BoostnoteApp extends StatefulWidget {

  @override
  _BoostnoteAppState createState() => _BoostnoteAppState();

}

class _BoostnoteAppState extends State<BoostnoteApp> {

  @override
  Widget build(BuildContext context) {
    
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return MaterialApp(
      title: 'Boostnote',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF202120),
        primaryColorLight: Color(0xFF2E3235),
        accentColor: Color(0xFF1EC38B),
        hintColor: Colors.white,
      ),
      initialRoute: '/',
      routes: {
        '/test': (context) => Overview(),
        '/': (context) => _buildBody(),
      },
    );
  }

  Widget _buildBody() {
    return ResponsiveWidget(widgets: <ResponsiveChild> [
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
    );
  }
}