
import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:boostnote_mobile/presentation/screens/markdown_editor/Editor.dart';
import 'package:boostnote_mobile/presentation/screens/navigation_drawer/NavigationDrawer.dart';
import 'package:boostnote_mobile/presentation/screens/overview/OverviewPresenter.dart';
import 'package:boostnote_mobile/presentation/screens/overview/OverviewView.dart';
import 'package:boostnote_mobile/presentation/screens/snippet_editor/SnippetEditor.dart';
import 'package:boostnote_mobile/presentation/screens/snippet_editor/SnippetTestEditor.dart';
import 'package:boostnote_mobile/presentation/widgets/NoteList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Overview extends StatefulWidget {

  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> implements OverviewView{

  OverviewPresenter _presenter;
  List<Note> _notes;
  Note _selectedNote;
  bool _isTablet;

  _OverviewState(){
    _presenter = OverviewPresenter(this);
  }

  @override
  void initState(){
    super.initState();
    _presenter.init();
  }

  void update(List<Note> notes){
    setState(() {
      _notes = notes;
    });
  }

  @override
  Widget build(BuildContext context) {

    double shortestSide = MediaQuery.of(context).size.shortestSide;
    _isTablet = shortestSide >= 600;

    Widget body;
    if (shortestSide < 600) {
      body = _buildMobileLayout(_notes);
    } else {
      body = _buildTabletLayout(_notes);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('All Notes'),
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
                 textTheme: TextTheme(body1: TextStyle(color: Theme.of(context).primaryColorLight))
              ),
        child: _isTablet ? null : NavigationDrawer(),
      ),
      body: body,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Color(0xFFF6F5F5)),
        onPressed: (){
          _presenter.onCreateNotePressed();

          _createDialog(context);
        },
      ),
    );
  }

  Widget _buildMobileLayout(List<Note> notes){
    return Container(
      child: NoteList(notes: notes, 
            itemSelectedCallback: (note) {
                openNote(note);
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
          child: NoteList(notes: notes, 
            itemSelectedCallback: (note) {
             openNote(note);
            }
          ),
        ),
      ],
    );
  }

  Future<String> _createDialog(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Container( 
          alignment: Alignment.center,
          child: Text('Make a Note', style: TextStyle(color: Colors.black))
        ),
        content: Container(
          height: 170,
          child: Column(
            children: <Widget>[
              TextField(
                controller: controller,
                style: TextStyle(color: Colors.black),
              ),
              RadioListTile(
                title: Text('Markdown Note'),
                value: true,
              ),
              RadioListTile(
                title: Text('Snippet Note'),
                value: false,
                activeColor: Theme.of(context).accentColor,
              )
            ],
          ),
        ),
        actions: <Widget>[
         MaterialButton(
            minWidth:100,
            elevation: 5.0,
            color: Color(0xFFF6F5F5),
            child: Text('Cancel', style: TextStyle(color: Colors.black),),
            onPressed: (){
              Navigator.of(context).pop();
            }
          ),
          MaterialButton(
            minWidth:100,
            elevation: 5.0,
            color: Theme.of(context).accentColor,
            child: Text('Save', style: TextStyle(color: Color(0xFFF6F5F5))),
            onPressed: (){
              Note note = true ? MarkdownNote() : SnippetNote();
              openNote(note);
            }
          )
        ],
      );
    });
  }

  void openNote(Note note){
     Widget editor = note is MarkdownNote ? Editor(_isTablet, note) : SnippetTestEditor(note);
     Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => editor)
     );
  }
}