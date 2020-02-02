
import 'dart:collection';

import 'package:boostnote_mobile/business_logic/model/Folder.dart';
import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/presentation/NavigationService.dart';
import 'package:boostnote_mobile/presentation/screens/markdown_editor/Editor.dart';
import 'package:boostnote_mobile/presentation/screens/overview/Refreshable.dart';
import 'package:boostnote_mobile/presentation/widgets/AddFloatingActionButton.dart';
import 'package:boostnote_mobile/presentation/widgets/NavigationDrawer.dart';
import 'package:boostnote_mobile/presentation/screens/overview/OverviewPresenter.dart';
import 'package:boostnote_mobile/presentation/screens/overview/OverviewView.dart';
import 'package:boostnote_mobile/presentation/screens/snippet_editor/SnippetTestEditor.dart';
import 'package:boostnote_mobile/presentation/widgets/notelist/NoteList.dart';
import 'package:boostnote_mobile/presentation/widgets/NoteSearch.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/NewNoteDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Overview extends StatefulWidget {   //TODO imutable

  final List<Note> notes;   
  final Folder selectedFolder;
  String selectedTag;
  int mode;

  Overview({this.mode, this.notes, this.selectedFolder, this.selectedTag});   //TODO constructor

  @override
  _OverviewState createState() => _OverviewState();

}

class _OverviewState extends State<Overview> implements OverviewView, Refreshable{

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  OverviewPresenter _presenter;

  List<Note> _notes;
  List<Note> _selectedNotes;
  NoteList _noteListWidget;

  bool _isTablet = false;
  bool _editMode = false;
  bool _listTilesAreExpanded = false;

  String _titleEditMode = 'Select Notes';

  static const String EDIT_ACTION = 'Edit';
  static const String EXPAND_ACTION = 'Expand';
  static const String COLLPASE_ACTION = 'Collapse';

  NavigationService _navigationService;

  String _pageTitle;
  
  @override
  void initState(){
    super.initState();

    _presenter = OverviewPresenter(this);
    _selectedNotes = List();

    _notes = this.widget.notes;
    if(_notes == null) {
      _notes = List();
      //_presenter.loadNotes(this.widget.mode);
    }

    _navigationService = NavigationService();


/*
    switch (this.widget.mode) {
      case NaviagtionDrawerAction.ALL_NOTES:
        _pageTitle = 'All Notes';
        break;
      case NaviagtionDrawerAction.TRASH:
        _pageTitle = 'Trashed Notes';
        break;
      case NaviagtionDrawerAction.STARRED:
        _pageTitle = 'Starred Notes';
        break;
      case NaviagtionDrawerAction.NOTES_IN_FOLDER:
        _pageTitle = this.widget.selectedFolder.name;
        break;
      case NaviagtionDrawerAction.NOTES_WITH_TAG:
        _pageTitle = this.widget.selectedTag;
        break;
      default:
        _pageTitle = 'All Notes';
        break;
    }*/
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
  Widget build(BuildContext context) {
     _pageTitle = _navigationService.overviewMode;
    return Scaffold(
      key: _drawerKey,
      appBar: _editMode ? _buildAppBarForEditMode() :  _buildAppBar(),
      drawer: _buildDrawer(_editMode, _isTablet),
      body: _buildBody(),
      floatingActionButton:_editMode ? null : AddFloatingActionButton(onPressed: () => _createNoteDialog()),
      bottomNavigationBar: _buildBottomNavigationBarForEditMode(_editMode)
    );
  }

  AppBar _buildAppBarForEditMode() {    //TODO extract Widget
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

  AppBar _buildAppBar() {   //TODO extract Widget
    return AppBar(
      title: Text(_pageTitle),
      leading: _buildLeadingIcon(),
      actions: _buildActions(),
    );
  }

 List<Widget> _buildActions() {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.search),
        onPressed: () => search()
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
              value: _listTilesAreExpanded ? COLLPASE_ACTION: EXPAND_ACTION,
              child: ListTile(
                title: _listTilesAreExpanded ? Text(COLLPASE_ACTION) : Text(EXPAND_ACTION)
              )
            ),
          ];
        }
      )
    ];
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
            _listTilesAreExpanded = false;
          });
        break;
      case EXPAND_ACTION:
        setState(() {
            _listTilesAreExpanded = true;
          });
        break;
    }
  }

  IconButton _buildLeadingIcon() {
    return this.widget.mode == NaviagtionDrawerAction.NOTES_IN_FOLDER 
        ? IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).accentColor), 
          onPressed: () {
            Navigator.of(context).pop();
          },
        ) : IconButton(
          icon: Icon(Icons.menu, color: Theme.of(context).accentColor), 
          onPressed: () {
            _drawerKey.currentState.openDrawer();
          },
        );
  }

  Theme _buildDrawer(bool editMode, bool isTablet) {
    return editMode ? 
      null : Theme(
        data: Theme.of(context).copyWith(
                canvasColor: Theme.of(context).primaryColorLight, 
                textTheme: TextTheme(body1: TextStyle(color: Theme.of(context).primaryColorLight))
              ),
        child: isTablet 
          ? null 
          : NavigationDrawer(
          /*  onNavigate: (action) => _onNavigate(action), */
           /* mode: _pageTitle,*/
            overviewView: this
          ),
      );
  }

  Widget _buildBody() {
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
              expandedMode: _listTilesAreExpanded,
              rowSelectedCallback: (selectedNotes){
                _rowSelectedCallback(selectedNotes, notes);
              }
      )
    );
  }

  Widget _buildTabletLayout(List<Note> notes){
    return Row(
      children: <Widget>[
        Flexible(
          flex: 0,
          child: NavigationDrawer(/*onNavigate: (action) => _onNavigate(action),*/ 
                 /* mode: _pageTitle,*/
                  overviewView: this
                 )
        ),
        Flexible(
          flex: 3,
          child: NoteList(
                  notes: notes, 
                  selectedNotes: _selectedNotes,
                  editMode: _editMode, 
                  expandedMode: _listTilesAreExpanded,
                  rowSelectedCallback: (selectedNotes){
                    _rowSelectedCallback(selectedNotes, notes);
                  }
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

  Container _buildBottomNavigationBarForEditMode(bool editMode) {  //TODO extract Widget
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
                _selectedNotes.clear();
                _selectedNotes.addAll(_notes);
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

  Future<String> _createNoteDialog() {
    return showDialog(context: context, 
      builder: (context){
        return CreateNoteDialog(
          cancelCallback: () {
            Navigator.of(context).pop();
          }, 
          saveCallback: (Note note) {
            Navigator.of(context).pop();
            if(this.widget.mode == NaviagtionDrawerAction.NOTES_IN_FOLDER) {
              note.folder = this.widget.selectedFolder;
            } 
            _presenter.onCreateNotePressed(note);
            openNote(note);   //TODO: Presenter???
          },
        );
    });
  }

  void search() {
    //TODO: Presenter?
    NoteSearch noteSearch = NoteSearch(
      Stream.value(UnmodifiableListView<Note>(_notes)).asBroadcastStream(), (note) {
      openNote(note);
    });

    showSearch(
      context: context,
      delegate: noteSearch
    );
  }

  void openNote(Note note){
     Widget editor = note is MarkdownNote ? Editor(_isTablet, note, this) : SnippetTestEditor(note, this);
     Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => editor)
     );
  }

/*
  _onNavigate(int action) {
    switch (action) {
      case NaviagtionDrawerAction.ALL_NOTES:
        this.widget.mode = NaviagtionDrawerAction.ALL_NOTES;
        _pageTitle = 'All Notes';
        _presenter.showAllNotes();
        break;
      case NaviagtionDrawerAction.TRASH:
        this.widget.mode = NaviagtionDrawerAction.TRASH;
        _pageTitle = 'Trashed Notes';
        _presenter.showTrashedNotes();
        break;
      case NaviagtionDrawerAction.STARRED:
        this.widget.mode = NaviagtionDrawerAction.STARRED;
        _pageTitle = 'Starred Notes';
        _presenter.showStarredNotes();
        break;
      case NaviagtionDrawerAction.FOLDERS:
        this.widget.mode = NaviagtionDrawerAction.FOLDERS;
        _pageTitle = 'Folders';
        /*Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FolderOverview())
        );*/
        Route route = PageRouteBuilder( 
              pageBuilder: (c, a1, a2) =>  FolderOverview(),
              transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: 0),
            );
        Navigator.of(context).pushReplacement(
          route
        );
        //Navigator.of(context).removeRouteBelow(route);
        break;
      case NaviagtionDrawerAction.TAGS:
        this.widget.mode = NaviagtionDrawerAction.TAGS;
        _pageTitle = 'Tags';
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TagOverview())
        );
        break;
    }
  }*/
}

