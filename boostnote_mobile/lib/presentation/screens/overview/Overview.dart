
import 'dart:collection';
import 'dart:math';

import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/presentation/screens/markdown_editor/Editor.dart';
import 'package:boostnote_mobile/presentation/screens/navigation_drawer/NavigationDrawer.dart';
import 'package:boostnote_mobile/presentation/screens/overview/OverviewPresenter.dart';
import 'package:boostnote_mobile/presentation/screens/overview/OverviewView.dart';
import 'package:boostnote_mobile/presentation/screens/snippet_editor/SnippetTestEditor.dart';
import 'package:boostnote_mobile/presentation/widgets/NoteList.dart';
import 'package:boostnote_mobile/presentation/widgets/NoteSearch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Overview extends StatefulWidget {

  _OverviewState state = _OverviewState();

  @override
  _OverviewState createState() => state;

 
 
}

class _OverviewState extends State<Overview> implements OverviewView{

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  OverviewPresenter _presenter;
  List<Note> _notes;
  List<Note> _selectedNotes;
  Note _selectedNote;
  bool _selectedAll = false;
  bool _isTablet;
  bool _editMode = false;
  bool _expanded = false;
  String _titleEditMode = 'Select Notes';

  NoteList noteList;

  _OverviewState(){
    _presenter = OverviewPresenter(this);
  }

  void _selectedAction(String action){
        switch (action) {
          case 'Edit':
            setState(() {
              _editMode = true;
            });
            break;
          case 'Collapse':
            setState(() {
                _expanded = false;
              });
            break;
          case 'Expand':
            setState(() {
                _expanded = true;
              });
            break;
        }
  }
  
  @override
  void initState(){
    super.initState();
    _selectedNotes = List();
    _presenter.init();
  }

 @override
  void update(List<Note> notes){
    print('lenght ' + notes.length.toString());
    setState(() {
      if(_notes != null){
        _notes.replaceRange(0, _notes.length, notes);
      } else {
        _notes = notes;
      }
    });
  }

 @override
  void refresh(){
    _presenter.refresh();
  }

  @override
  Widget build(BuildContext context) {

    double shortestSide = MediaQuery.of(context).size.shortestSide;
    _isTablet = shortestSide >= 600;

    Widget body;
    if (shortestSide < 400) {
      body = _buildMobileLayout(_notes);
    } else {
      body = _buildTabletLayout(_notes);
    }

    return Scaffold(
      key: _drawerKey,
      appBar: !_editMode ? AppBar(
        title: Text('All Notes'),
        leading: IconButton(
          icon: Icon(Icons.menu, color: Theme.of(context).accentColor), 
          onPressed: () {
            _drawerKey.currentState.openDrawer();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              NoteSearch noteSearch = NoteSearch(
                Stream.value(UnmodifiableListView<Note>(_notes)).asBroadcastStream(), (note) {
                openNote(note);
              });
              showSearch(
                context: context,
                delegate: noteSearch
              );
            },
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            onSelected: _selectedAction,
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                PopupMenuItem(
                  value: 'Edit',
                  child: ListTile(
                    title: Text('Edit')
                  )
                ),
                PopupMenuItem(
                  value: _expanded ? 'Collapse': 'Expand',
                  child: ListTile(
                    title: _expanded ? Text('Collapse') : Text('Expand')
                  )
                ),
              ];
            }
          )
        ],
      ) :
      AppBar(
        title: Text(_titleEditMode),
        leading: _editMode ? null : IconButton(
          icon: Icon(Icons.menu, color: Theme.of(context).accentColor), 
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.cancel),
            onPressed: () {
              setState(() {
                _editMode = false;
              });
            },
          )
        ],
      ),
      drawer: _editMode ? null : Theme(
        data: Theme.of(context).copyWith(
                 canvasColor: Theme.of(context).primaryColorLight, 
                 textTheme: TextTheme(body1: TextStyle(color: Theme.of(context).primaryColorLight))
              ),
        child: _isTablet ? null : NavigationDrawer(),
      ),
      body: body,
      floatingActionButton: _editMode ? null : FloatingActionButton(
        child: Icon(Icons.add, color: Color(0xFFF6F5F5)),
        onPressed: (){
          _createDialog(context);
        },
      ),
      bottomNavigationBar: _editMode ? Container(
        height: 50,
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            MaterialButton(
              child: Column(
                children: <Widget>[
                  Icon(Icons.check),
                  Text('Select All')
                ],
              ),
              onPressed: () {
                setState(() {
                  _selectedAll = true;
                });
              }
            ),
            MaterialButton(
              child: Column(
                children: <Widget>[
                  Icon(Icons.delete),
                  Text('Delete')
                ],
              ),
              onPressed: () {
                _presenter.delete(_selectedNotes);
                setState(() {
                  _selectedNotes.clear();
                  noteList.clearSelectedElements();
                  _editMode = false;
                });
              }
            ),
          ],
        ),
      ) : null
    );
  }

  Widget _buildMobileLayout(List<Note> notes){
   noteList =  NoteList(notes: notes, edit: _editMode, expanded: _expanded,
            itemSelectedCallback: (noteList) {
              if(_editMode) {
                _selectedNotes = noteList;
              
                setState(() {
                    if(_selectedNotes.length == 0){
                    _titleEditMode = 'Select Notes';
                  } else if (_selectedNotes.length == notes.length){
                    _titleEditMode = 'All Notes Selected';
                  } else if (_selectedNotes.length == 1) {
                    _titleEditMode = '1 Note Selected';
                  } else {
                    _titleEditMode = _selectedNotes.length.toString() + ' Notes Selected';
                  }
                });

              } else {
                openNote(noteList.elementAt(0));
              }
            }
      );
    return Container(
      child: noteList
    );
  }

  Widget _buildTabletLayout(List<Note> notes){
    noteList = NoteList(notes: notes, edit: _editMode, expanded: _expanded,
            itemSelectedCallback: (noteList) {
               if(_editMode) {
                _selectedNotes = noteList;
              
                setState(() {
                    if(_selectedNotes.length == 0){
                    _titleEditMode = 'Select Notes';
                  } else if (_selectedNotes.length == notes.length){
                    _titleEditMode = 'All Notes Selected';
                  } else if (_selectedNotes.length == 1) {
                    _titleEditMode = '1 Note Selected';
                  } else {
                    _titleEditMode = _selectedNotes.length.toString() + ' Notes Selected';
                  }
                });

              } else {
                openNote(noteList.elementAt(0));
              }
            }
          );
    return Row(
      children: <Widget>[
        Flexible(
          flex: 0,
          child: NavigationDrawer()
        ),
        Flexible(
          flex: 3,
          child: noteList
        ),
      ],
    );
  }

  Future<String> _createDialog(BuildContext context) {
    TextEditingController controller = TextEditingController();
  
    return showDialog(context: context, 
    builder: (context){
      const int MARKDOWNNOTE = 1;
      const int SNIPPETNOTE = 2;
      int groupvalue = MARKDOWNNOTE;
      return AlertDialog(
         title: Container( 
          alignment: Alignment.center,
          child: Text('Make a Note', style: TextStyle(color: Colors.black))
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: 170,
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: controller,
                    style: TextStyle(color: Colors.black),
                  ), 
                  RadioListTile(
                    title: Text('Markdown Note'),
                    value: 1,
                    groupValue: groupvalue,
                    onChanged: (int value) {
                      setState(() {
                        groupvalue = MARKDOWNNOTE;
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text('Snippet Note'),
                    groupValue: groupvalue,
                    value: 2,
                    onChanged: (int value) {
                      setState(() {
                        groupvalue = SNIPPETNOTE;
                      });
                    },
                  ),
                ],
              ),
            );
          },
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
              if(controller.text.trim().length > 0){
                Note note;
                if(groupvalue == MARKDOWNNOTE){
                  note = MarkdownNote(
                    id: 1,
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                    folder: '',
                    title: controller.text.trim(),
                    tags: [],
                    isStarred: false,
                    isTrashed: false,
                    content: ''
                  );
                } else {
                  note = SnippetNote(
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                    folder: '',
                    title: controller.text.trim(),
                    tags: [],
                    isStarred: false,
                    isTrashed: false,
                    description: '',
                    codeSnippets: []
                  );
                }
                Navigator.of(context).pop();
                _presenter.onCreateNotePressed(note);
                openNote(note);
              }
            }
          )
        ],
      );
    });
  }

  void openNote(Note note){
     Widget editor = note is MarkdownNote ? Editor(_isTablet, note, this) : SnippetTestEditor(note, this);
     Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => editor)
     );
  }
}