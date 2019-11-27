
import 'package:boostnote_mobile/data/DummyDataGenerator.dart';
import 'package:boostnote_mobile/data/model/Note.dart';
import 'package:boostnote_mobile/ui/screens/NoteList/NoteList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  DummyDataGenerator generator = new DummyDataGenerator();
  Note _selectedNote;

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Boostnote'),
      ),
      body: Container(
        child: new NoteList(data: generator.generateNotes(10), 
                            itemSelectedCallback: (note) {
                                setState(() {
                                  _selectedNote = note;
                                });
                            }
                           ),
      ),
    );
  }
}