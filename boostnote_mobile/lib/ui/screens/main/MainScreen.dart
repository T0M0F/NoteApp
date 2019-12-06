
import 'package:boostnote_mobile/data/DummyDataGenerator.dart';
import 'package:boostnote_mobile/data/model/Note.dart';
import 'package:boostnote_mobile/ui/screens/main/NoteList/NoteList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'NavigationDrawer.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  DummyDataGenerator generator = new DummyDataGenerator();
  Note _selectedNote;

 @override
  Widget build(BuildContext context) {

    double shortestSide = MediaQuery.of(context).size.shortestSide;
    bool isTablet = shortestSide >= 600;
    List<Note> notes = generator.generateNotes(10);
    Widget body;

    if (shortestSide < 600) {
      body = _buildMobileLayout(notes);
    } else {
      body = _buildTabletLayout(notes);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Boostnote'),
        leading: IconButton(
          icon: Icon(Icons.menu, color: Theme.of(context).accentColor), 
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          )
        ],
      ),
      drawer: Theme(
        data: Theme.of(context).copyWith(
                 canvasColor: Theme.of(context).primaryColorLight, 
              ),
        child: isTablet ? null : NavigationDrawer(),
      ),
      body: body,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: (){
          
        },
      ),
    );
  }

  Widget _buildMobileLayout(List<Note> notes){
    return Container(
      child: new NoteList(data: notes, 
            itemSelectedCallback: (note) {
                setState(() {
                  _selectedNote = note;
                });
            }
      ),
    );
  }

  Widget _buildTabletLayout(List<Note> notes){
    return Row(
      children: <Widget>[
        Flexible(
          flex: 2,
          child: NavigationDrawer()
        ),
        Flexible(
          flex: 3,
          child: NoteList(data: notes, 
            itemSelectedCallback: (note) {
                setState(() {
                  _selectedNote = note;
                });
            }
          ),
        ),
      ],
    );
  }
}