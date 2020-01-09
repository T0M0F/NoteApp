
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/presentation/screens/overview/Overview.dart';
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
      home: Overview(),
    );
  }

  List<Note> generateNotes() => NoteService().generateNotes(10);

/*
  Future<List<Note>> loadNotes() async { 
    Future<List<Note>> notes = NoteService().findAll();
    notes.then((result) { 
      print('-----------------------------Notes------------------------------------');
      print('-----------------------------------------------------------------');
      result.forEach((note) => print(note.title + ' ' + note.runtimeType.toString()));
      print('-----------------------------------------------------------------');
      print('-----------------------------------------------------------------');

      setState(() {
        _notes = result;
      });
    });
  }
  */

}