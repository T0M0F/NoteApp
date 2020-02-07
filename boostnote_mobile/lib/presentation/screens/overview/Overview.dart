
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

  Overview({this.notes, this.selectedFolder, this.selectedTag});   //TODO constructor

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

    _navigationService = NavigationService();

    _notes = this.widget.notes;

    //if no note list is provided, for example on StartUp when calling Overview() from BoostnoteApp or 
    //when navigating back from open note
    print('init');
    if(_notes == null) {
      _notes = List();
      switch(_navigationService.navigationMode) {
        case NavigationMode.NOTES_WITH_TAG_MODE:
          _presenter.loadNotesWithTag(this.widget.selectedTag);
          break;
        case NavigationMode.NOTES_IN_FOLDER_MODE:
          _presenter.loadNotesInFolder(this.widget.selectedFolder);
          break;
        default:
          _presenter.loadAllNotes();
          break;
      } 
  }
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
 void dispose(){
   super.dispose();

   switch(_navigationService.navigationMode) {      //TODO sucky sucky
        case NavigationMode.NOTES_IN_FOLDER_MODE:
          print('NOTES_IN_FOLDER_MODE');
          _navigationService.navigationMode = NavigationMode.FOLDERS_MODE;
          break;
        case NavigationMode.NOTES_WITH_TAG_MODE:
          print('NOTES_WITH_TAG_MODE');
          _navigationService.navigationMode = NavigationMode.TAGS_MODE;
          break;
      }
 }
  

  @override
  Widget build(BuildContext context) {

    if(_navigationService.isNotesInFolderMode()){
      _pageTitle = this.widget.selectedFolder.name;
    } else if(_navigationService.isNotesWithTagMode()) {
      _pageTitle = this.widget.selectedTag;
    } else {
      _pageTitle = _navigationService.navigationMode;
    }

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
    return (_navigationService.isNotesWithTagMode() || _navigationService.isNotesInFolderMode())
        ? IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).accentColor), 
          onPressed: () {
            _navigationService.navigateBack(context);
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
          : NavigationDrawer(overviewView: this),
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
          child: NavigationDrawer(overviewView: this)
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
      _navigationService.openNote(selectedNotes.elementAt(0), context, this, _isTablet);
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
            if(_navigationService.isNotesInFolderMode()) {
              note.folder = this.widget.selectedFolder;
            } else if(_navigationService.isNotesWithTagMode()){
              note.tags.add(this.widget.selectedTag);
            }
            _presenter.onCreateNotePressed(note);
            _navigationService.openNote(note, context, this, _isTablet);   //TODO: Presenter???
          },
        );
    });
  }

  void search() {
    //TODO: Presenter?
    NoteSearch noteSearch = NoteSearch(
      _notes, (note) {
      _navigationService.openNote(note, context, this, _isTablet);
    });

    showSearch(
      context: context,
      delegate: noteSearch
    );
  }
}

