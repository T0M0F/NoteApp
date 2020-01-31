
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/presentation/screens/folder_overview/FolderOverview.dart';
import 'package:boostnote_mobile/presentation/screens/overview/Overview.dart';
import 'package:boostnote_mobile/presentation/screens/tag_overview/TagOverview.dart';
import 'package:boostnote_mobile/presentation/widgets/NavigationDrawer.dart';
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
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => Overview(),
        '/AllNotes': (context) => Overview(mode: NaviagtionDrawerAction.ALL_NOTES),
        '/StarredNotes': (context) => Overview(mode: NaviagtionDrawerAction.STARRED),
        '/TrashedNotes': (context) => Overview(mode: NaviagtionDrawerAction.TRASH),
        '/Folders': (context) => FolderOverview(),
        '/Tags': (context) => TagOverview(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        //'/second': (context) => SecondScreen(),
      },
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