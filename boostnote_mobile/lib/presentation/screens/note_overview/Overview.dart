

import 'package:boostnote_mobile/business_logic/model/Folder.dart';
import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:boostnote_mobile/presentation/NavigationService.dart';
import 'package:boostnote_mobile/presentation/NewNavigationService.dart';
import 'package:boostnote_mobile/presentation/screens/note_overview/Refreshable.dart';
import 'package:boostnote_mobile/presentation/widgets/AddFloatingActionButton.dart';
import 'package:boostnote_mobile/presentation/widgets/NavigationDrawer.dart';
import 'package:boostnote_mobile/presentation/screens/note_overview/OverviewPresenter.dart';
import 'package:boostnote_mobile/presentation/screens/note_overview/OverviewView.dart';
import 'package:boostnote_mobile/presentation/widgets/appbar/OverviewAppbar.dart';
import 'package:boostnote_mobile/presentation/widgets/appbar/OverviewEditModeAppbar.dart';
import 'package:boostnote_mobile/presentation/widgets/notegrid/NoteGridTile.dart';
import 'package:boostnote_mobile/presentation/widgets/notelist/DeleteAllBottomNavigationBar.dart';
import 'package:boostnote_mobile/presentation/widgets/notelist/EditModeBottomNavigationBar.dart';
import 'package:boostnote_mobile/presentation/widgets/notelist/NoteList.dart';
import 'package:boostnote_mobile/presentation/widgets/search/NoteSearch.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/NewNoteDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Overview extends StatefulWidget {   //TODO imutable

  final List<Note> notes;   
  final Folder selectedFolder;
  String selectedTag;
  String title; 

  Overview({this.notes, this.selectedFolder, this.selectedTag});   //TODO constructor

  @override
  _OverviewState createState() => _OverviewState();

}

class _OverviewState extends State<Overview> implements OverviewView, Refreshable{

  OverviewPresenter _presenter;
  //NavigationService _navigationService;
  NewNavigationService _newNavigationService;

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  List<Note> _notes;
  List<Note> _selectedNotes;
  NoteList _noteListWidget;

  bool _isEditMode = false;
  bool _tilesAreExpanded = false;
  bool _showListView = true;

  String _titleEditMode = 'Select Notes';

  static const String EDIT_ACTION = 'Edit';
  static const String EXPAND_ACTION = 'Expand';
  static const String COLLPASE_ACTION = 'Collapse';
  static const String SHOW_GRIDVIEW_ACTION = 'Gridview';
  static const String SHOW_LISTVIEW_ACTION = 'Listview';

  String _pageTitle;
  
  @override
  void initState(){
    super.initState();
    print('init Overview');
    _presenter = OverviewPresenter(this);
    //_navigationService = NavigationService();
    _newNavigationService = NewNavigationService();

    _selectedNotes = List();
    _notes = this.widget.notes;
   

    //if no note list is provided, for example on StartUp when calling Overview() from BoostnoteApp or 
    //when navigating back from open note
    if(_notes == null) {                                                  //TODO ugly
      _notes = List();
      switch(_newNavigationService.navigationModeHistory.last) {
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
 void refresh() {} //=> _presenter.refresh();

/*
 @override
 void dispose(){
   super.dispose();

/*
   switch( _navigationService.navigationMode) {      //TODO sucky sucky
        case NavigationMode.NOTES_IN_FOLDER_MODE:
          print('NOTES_IN_FOLDER_MODE');
          _navigationService.navigationMode = NavigationMode.FOLDERS_MODE;
          break;
        case NavigationMode.NOTES_WITH_TAG_MODE:
          print('NOTES_WITH_TAG_MODE');
          _navigationService.navigationMode = NavigationMode.TAGS_MODE;
          break;
      }
      */
 }*/

  @override
  Widget build(BuildContext context) {

    if(_newNavigationService.isNotesInFolderMode()){
      _pageTitle = this.widget.selectedFolder.name;
    } else if(_newNavigationService.isNotesWithTagMode()) {
      _pageTitle = this.widget.selectedTag;
    } else {
      _pageTitle = _newNavigationService.navigationModeHistory.last;  //TODO sucky
    }

    print('FUGGA' + _notes.length.toString());

    return Scaffold(
      key: _drawerKey,
      appBar: _buildAppBar(),
      drawer: _isEditMode ? null : NavigationDrawer(),
      body: _showListView ? _buildListViewBody() : _buildGridViewBody(),
      floatingActionButton:_isEditMode || _newNavigationService.isTrashMode() ? null : AddFloatingActionButton(onPressed: () => _createNoteDialog()),
      bottomNavigationBar: _buildBottomNavigationBar(_isEditMode)
    );
  }

  PreferredSizeWidget _buildAppBar() {   
    if(_isEditMode) {                     //TODO extract Widget
      return OverviewEditModeAppbar(
        titleEditMode: _titleEditMode,
        isEditMode: _isEditMode,
        onMenuClickCallback: () {
          Scaffold.of(context).openDrawer();
        },
        onCancelClickCallback: () {
          setState(() {
            _isEditMode = false;
          });
        });
    } else {
      return OverviewAppbar(
        pageTitle: _pageTitle,
        actions: {'EDIT_ACTION':EDIT_ACTION, 'EXPAND_ACTION':EXPAND_ACTION, 'COLLPASE_ACTION':COLLPASE_ACTION, 'SHOW_LISTVIEW_ACTION': SHOW_LISTVIEW_ACTION, 'SHOW_GRIDVIEW_ACTION' : SHOW_GRIDVIEW_ACTION},
        listTilesAreExpanded: _tilesAreExpanded,
        showListView: _showListView,
        onMenuClickCallback: () => _drawerKey.currentState.openDrawer(),
        onNaviagteBackCallback: () => _newNavigationService.navigateBack(context), //_naviagtionService.navigateBack(context)
        onSearchClickCallback: () => search(),
        onSelectedActionCallback: (String action) => _selectedAction(action)
      );
    }
  }

  void _selectedAction(String action){
    switch (action) {
      case EDIT_ACTION:
        setState(() {
          _isEditMode = true;
        });
        break;
      case COLLPASE_ACTION:
        setState(() {
            _tilesAreExpanded = false;
          });
        break;
      case EXPAND_ACTION:
        setState(() {
            _tilesAreExpanded = true;
          });
        break;
      case SHOW_GRIDVIEW_ACTION:
        setState(() {
          _showListView = false;
        });
        break;
      case SHOW_LISTVIEW_ACTION:
        setState(() {
          _showListView = true;
        });
        break;
    }
  }

  Widget _buildListViewBody() {
    return Container(
      child: NoteList(
              notes: _notes, 
              selectedNotes: _selectedNotes,
              editMode: _isEditMode, 
              expandedMode: _tilesAreExpanded,
              rowSelectedCallback: (selectedNotes){
              _rowSelectedCallback(selectedNotes, _notes);
              }
      )
    );
  }

  Widget _buildGridViewBody() {   //Todo extract widget
    double _displayWidth = MediaQuery.of(context).size.width;
    int _cardWidth = 200;
    int _axisCount = (_displayWidth/_cardWidth).round();
    return Container(
      child: StaggeredGridView.countBuilder(
        crossAxisCount: _axisCount,
        itemCount: _notes.length,
        itemBuilder: (BuildContext context, int index) => Card(
            child: GestureDetector(
              onTap: () {
                 _rowSelectedCallback([_notes[index]], _notes);
              },
              child: NoteGridTile(note: _notes[index], expanded: _tilesAreExpanded)
            )
        ),
        staggeredTileBuilder: (int index) => StaggeredTile.count(1, calculateHeightFactor(_notes[index]))
      )
    );
  }

  double calculateHeightFactor(Note note) {
    if(_tilesAreExpanded) {
      return 0.95;
    } else {
      return 0.8;
    }
  }

  void _rowSelectedCallback(List<Note> selectedNotes, List<Note> notes) {  
    //TODO: Presenter???
    if(_isEditMode) {
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
      //_navigationService.openNoteResponsive(_notes, selectedNotes.elementAt(0), context, this);
      if(selectedNotes.first is MarkdownNote) {
        NewNavigationService().navigateTo(destinationMode: NavigationMode2.MARKDOWN_NOTE, note: selectedNotes.first);
      } else if (selectedNotes.first is SnippetNote) {
        NewNavigationService().navigateTo(destinationMode: NavigationMode2.SNIPPET_NOTE, note: selectedNotes.first);
      }
     
    }
  }

  Widget _buildBottomNavigationBar(bool editMode) {  //TODO extract Widget
    if(editMode) {
      EditModeBottomNavigationBar(
        deleteCallback: () {
          //TODO: change
          _presenter.trash(_selectedNotes);
          setState(() {
            _selectedNotes.clear();
            _noteListWidget.clearSelectedElements();
            _isEditMode = false;
          });
        },
        selecetAllNotesCallback:() {
          setState(() {
                  _selectedNotes.clear();
                  _selectedNotes.addAll(_notes);
                });
        },
      );
    } else if(_newNavigationService.isTrashMode()) {
       return DeleteAllBottomNavigationBar(
         deleteAllCallback: () {
           _presenter.deleteForever(_notes);
         }
       );
    }

    return null;
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
            if(_newNavigationService.isNotesInFolderMode()) {
              note.folder = this.widget.selectedFolder;
            } else if(_newNavigationService.isNotesWithTagMode()){
              note.tags.add(this.widget.selectedTag);
            }
            _presenter.onCreateNotePressed(note);
            if(note is SnippetNote) {
              _newNavigationService.navigateTo(destinationMode: NavigationMode2.SNIPPET_NOTE, note: note);   //TODO: Presenter???
            } else if (note is MarkdownNote) {
              _newNavigationService.navigateTo(destinationMode: NavigationMode2.MARKDOWN_NOTE, note: note);   
            }
          },
        );
    });
  }

  void search() {
    //TODO: Presenter?
    NoteSearch noteSearch = NoteSearch(
      _notes, (note) {
      if(note is SnippetNote) {
            _newNavigationService.navigateTo(destinationMode: NavigationMode2.SNIPPET_NOTE, note: note);   //TODO: Presenter???
      } else if (note is MarkdownNote) {
        _newNavigationService.navigateTo(destinationMode: NavigationMode2.MARKDOWN_NOTE, note: note);   
      }
    });

    showSearch(
      context: context,
      delegate: noteSearch
    );
  }
}

