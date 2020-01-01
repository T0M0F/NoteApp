
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/presentation/screens/overview/Overview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BoostnoteApp extends StatelessWidget {
  
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
      home: Overview(generateNotes()),
    );
  }

  List<Note> generateNotes() => NoteService().generateNotes(10);
  
}