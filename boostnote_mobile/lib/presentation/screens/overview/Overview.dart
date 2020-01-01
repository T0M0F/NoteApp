
import 'dart:collection';

import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/presentation/screens/markdown_editor/Editor.dart';
import 'package:boostnote_mobile/presentation/widgets/NavigationDrawer.dart';
import 'package:boostnote_mobile/presentation/screens/overview/OverviewPresenter.dart';
import 'package:boostnote_mobile/presentation/screens/overview/OverviewView.dart';
import 'package:boostnote_mobile/presentation/screens/snippet_editor/SnippetTestEditor.dart';
import 'package:boostnote_mobile/presentation/widgets/notelist/NoteList.dart';
import 'package:boostnote_mobile/presentation/widgets/NoteSearch.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/NewNoteDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Overview extends StatefulWidget {

  final List<Note> _notes;

  Overview(this._notes);

  @override
  _OverviewState createState() => _OverviewState();

}

class _OverviewState extends State<Overview> implements OverviewView{

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  OverviewPresenter _presenter;

  List<Note> _notes;
  List<Note> _selectedNotes;
  NoteList _noteListWidget;

  bool _selectedAllNotes = false;
  bool _isTablet = false;
  bool _editMode = false;
  bool _expanded = false;

  String _titleEditMode = 'Select Notes';

  static const String EDIT_ACTION = 'Edit';
  static const String EXPAND_ACTION = 'Expand';
  static const String COLLPASE_ACTION = 'Collapse';
  
  @override
  void initState(){
    super.initState();
    _presenter = OverviewPresenter(this);
    _selectedNotes = List();
    _notes = this.widget._notes;
    _presenter.init();
  }

 @override
  void update(List<Note> notes){
    setState(() {
      if(_notes != null){
        _notes.replaceRange(0, _notes.length, notes);
      } else {
        _notes = notes;
      }
    });
  }

 @override
  void refresh() => _presenter.refresh();
  

  @override
  Widget build(BuildContext context) => Scaffold(
    key: _drawerKey,
    appBar: _editMode ? _buildAppBarForEditMode(context) :  _buildAppBar(context),
    drawer: _buildDrawer(context, _editMode, _isTablet),
    body: _buildBody(context),
    floatingActionButton: _buildFloatingActionButton(context),
    bottomNavigationBar: _buildBottomNavigationBarForEditMode(_editMode)
  );

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
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
            //TODO: Presenter?
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
                value: EDIT_ACTION,
                child: ListTile(
                  title: Text(EDIT_ACTION)
                )
              ),
              PopupMenuItem(
                value: _expanded ? COLLPASE_ACTION: EXPAND_ACTION,
                child: ListTile(
                  title: _expanded ? Text(COLLPASE_ACTION) : Text(EXPAND_ACTION)
                )
              ),
            ];
          }
        )
      ],
    );
  }

  void _selectedAction(String action){
    switch (action) {
      case EDIT_ACTION:
        setState(() {
          _editMode = true;
        });
        break;
      case COLLPASE_ACTION:
        setState(() {
            _expanded = false;
          });
        break;
      case EXPAND_ACTION:
        setState(() {
            _expanded = true;
          });
        break;
    }
  }

  AppBar _buildAppBarForEditMode(BuildContext context) {
    return AppBar(
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
    );
  }

  Theme _buildDrawer(BuildContext context, bool editMode, bool isTablet) {
    return editMode ? null : Theme(
      data: Theme.of(context).copyWith(
               canvasColor: Theme.of(context).primaryColorLight, 
               textTheme: TextTheme(body1: TextStyle(color: Theme.of(context).primaryColorLight))
            ),
      child: isTablet ? null : NavigationDrawer(createFolderCallback: (folderName) {},onNavigate: (action) => _onNavigate(action)),
    );
  }

  Widget _buildBody(BuildContext context) {
    double shortestSide = MediaQuery.of(context).size.shortestSide;
    _isTablet = shortestSide >= 600;
    
    Widget body;
    if (_isTablet) {
      body = _buildTabletLayout(_notes);
    } else {
      body = _buildMobileLayout(_notes);
    }
    return body;
  }

  Widget _buildMobileLayout(List<Note> notes){
    return Container(
      child: NoteList(
              notes: notes, 
              selectedNotes: _selectedNotes,
              editMode: _editMode, 
              expandedMode: _expanded,
              rowSelectedCallback: (selectedNotes){_rowSelectedCallback(selectedNotes, notes);}
      )
    );
  }

  Widget _buildTabletLayout(List<Note> notes){
    return Row(
      children: <Widget>[
        Flexible(
          flex: 0,
          child: NavigationDrawer(createFolderCallback: (folderName) {},)
        ),
        Flexible(
          flex: 3,
          child: NoteList(
                  notes: notes, 
                  selectedNotes: _selectedNotes,
                  editMode: _editMode, 
                  expandedMode: _expanded,
                  rowSelectedCallback: (selectedNotes){_rowSelectedCallback(selectedNotes, notes);}
          )
        ),
      ],
    );
  }

  void _rowSelectedCallback(List<Note> selectedNotes, List<Note> notes) {
    //TODO: Presenter???
    if(_editMode) {
      _selectedNotes = selectedNotes;
    
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
      openNote(selectedNotes.elementAt(0));
    }
  }

  FloatingActionButton _buildFloatingActionButton(BuildContext context) {
    return _editMode ? null : FloatingActionButton(
      child: Icon(Icons.add, color: Color(0xFFF6F5F5)),
      onPressed: (){
        _createDialog(context);
      },
    );
  }

  Container _buildBottomNavigationBarForEditMode(bool editMode) {
    return editMode ? Container(
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
                print('select all');
                _selectedNotes.clear();
                _selectedNotes.addAll(_notes);
                _selectedAllNotes = true;
                //TODO: implement select all: _selectedAll = true;
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
              //TODO: change
              _presenter.delete(_selectedNotes);
              setState(() {
                _selectedNotes.clear();
                _noteListWidget.clearSelectedElements();
                _editMode = false;
              });
            }
          ),
        ],
      ),
    ) : null;
  }

  Future<String> _createDialog(BuildContext context) {
    return showDialog(context: context, 
    builder: (context){
      return CreateNoteDialog(
        cancelCallback: () {
          Navigator.of(context).pop();
        }, 
        saveCallback: (Note note) {
          Navigator.of(context).pop();
          _presenter.onCreateNotePressed(note);
          openNote(note);   //TODO: Presenter???
        },
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

  _onNavigate(int action) {
    switch (action) {
      case NaviagtionDrawerAction.ALL_NOTES:
        _presenter.showAllNotes();
        break;
      case NaviagtionDrawerAction.TRASH:
        _presenter.showTrashedNotes();
        break;
      case NaviagtionDrawerAction.STARRED:
        _presenter.showStarredNotes();
       break;
    }
  }
}

