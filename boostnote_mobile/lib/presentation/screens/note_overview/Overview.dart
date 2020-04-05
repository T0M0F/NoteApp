import 'package:boostnote_mobile/business_logic/model/Folder.dart';
import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:boostnote_mobile/presentation/navigation/NavigationService.dart';
import 'package:boostnote_mobile/presentation/screens/ActionConstants.dart';
import 'package:boostnote_mobile/presentation/screens/note_overview/Refreshable.dart';
import 'package:boostnote_mobile/presentation/screens/note_overview/widgets/DeleteNoteBottomSheet.dart';
import 'package:boostnote_mobile/presentation/screens/note_overview/widgets/OverviewAppbar.dart';
import 'package:boostnote_mobile/presentation/screens/note_overview/widgets/TrashNoteBottomSheet.dart';
import 'package:boostnote_mobile/presentation/widgets/bottom_navigationbar/DeleteAllBottomNavigationBar.dart';
import 'package:boostnote_mobile/presentation/widgets/NavigationDrawer.dart';
import 'package:boostnote_mobile/presentation/screens/note_overview/OverviewPresenter.dart';
import 'package:boostnote_mobile/presentation/screens/note_overview/OverviewView.dart';
import 'package:boostnote_mobile/presentation/widgets/buttons/CreateNoteFloatingActionButton.dart';
import 'package:boostnote_mobile/presentation/widgets/notegrid/NoteGridTile.dart';
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
  NavigationService _newNavigationService;
  NoteService _noteService;

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  List<Note> _notes;
  List<Note> _selectedNotes;
  List<Note> _notesCopy;

  bool _tilesAreExpanded = false;
  bool _showListView = true;

  String _pageTitle;
  
  @override
  void initState(){
    super.initState();

    _presenter = OverviewPresenter(this, _updateNotesCopy);
    _newNavigationService = NavigationService();
    _noteService = NoteService();
    _selectedNotes = List();
    _notes = this.widget.notes;

    //if no note list is provided, for example on StartUp when calling Overview() from BoostnoteApp or 
    //when navigating back from open note
    if(_notes == null) {                                                  //TODO ugly
      _notes = List();
      switch(_newNavigationService.navigationModeHistory.last) {
        case NavigationMode2.NOTES_WITH_TAG_MODE:
          _presenter.loadNotesWithTag(this.widget.selectedTag);
          break;
        case NavigationMode2.NOTES_IN_FOLDER_MODE:
          _presenter.loadNotesInFolder(this.widget.selectedFolder);
          break;
        default:
          _presenter.loadAllNotes();
          break;
      } 
    } else {
       _updateNotesCopy();
    }
  }

  //is needed for search
  void _updateNotesCopy(){
    _notesCopy = List<Note>.from(_notes);
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
 void refresh() {
   _noteService.findAll().then((notes) => update(notes));
 } 

 @override
 Widget build(BuildContext context) {

    if(_newNavigationService.isNotesInFolderMode()){
      _pageTitle = this.widget.selectedFolder.name;
    } else if(_newNavigationService.isNotesWithTagMode()) {
      _pageTitle = this.widget.selectedTag;
    } else {
      _pageTitle = _newNavigationService.navigationModeHistory.last;  //TODO sucky
    }

    return Scaffold(
      key: _drawerKey,
      appBar: _buildAppBar(),
      drawer: NavigationDrawer(), 
      drawerScrimColor: Colors.transparent,
      body: _showListView ? _buildListViewBody() : _buildGridViewBody(),
      floatingActionButton: _newNavigationService.isTrashMode() ? null : CreateNoteFloatingActionButton(onPressed: () => _createNoteDialog()),
      bottomNavigationBar: _buildBottomNavigationBar() 
    );
  }

  PreferredSizeWidget _buildAppBar() { 
     return OverviewAppbar(
        pageTitle: _pageTitle,
        notes: _notesCopy,
        actions: {
          'EXPAND_ACTION': ActionConstants.EXPAND_ACTION, 
          'COLLPASE_ACTION': ActionConstants.COLLPASE_ACTION, 
          'SHOW_LISTVIEW_ACTION': ActionConstants.SHOW_LISTVIEW_ACTION, 
          'SHOW_GRIDVIEW_ACTION' : ActionConstants.SHOW_GRIDVIEW_ACTION},
       
        onSelectedActionCallback: (String action) => _selectedAction(action),
        onSearchCallback: (filteredNotes) {
          update(filteredNotes);
        },
      );
  }

  void _selectedAction(String action){
    switch (action) {
      case ActionConstants.COLLPASE_ACTION:
        setState(() {
            _tilesAreExpanded = false;
          });
        break;
      case ActionConstants.EXPAND_ACTION:
        setState(() {
            _tilesAreExpanded = true;
          });
        break;
      case ActionConstants.SHOW_GRIDVIEW_ACTION:
        setState(() {
          _showListView = false;
        });
        break;
      case ActionConstants.SHOW_LISTVIEW_ACTION:
        setState(() {
          _showListView = true;
        });
        break;
    }
  }

  Widget _buildListViewBody() {
    return Container(
      child: NoteList()
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
                 _onRowTap([_notes[index]], _notes);
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

  void _onRowLongPress(List<Note> selectedNotes) {
    if(_newNavigationService.isTrashMode()){
      showModalBottomSheet(     
        context: context,
        builder: (BuildContext buildContext){
          return DeleteNoteBottomSheet(
             );
        }
      );
    } else {
      showModalBottomSheet(     
        context: context,
        builder: (BuildContext buildContext){
          return TrashNoteBottomSheet(
          
          );
        }
      );
    }
  }

  void _onRowTap(List<Note> selectedNotes, List<Note> notes) {  
     if(selectedNotes.first is MarkdownNote) {
        NavigationService().navigateTo(destinationMode: NavigationMode2.MARKDOWN_NOTE, note: selectedNotes.first);
      } else if (selectedNotes.first is SnippetNote) {
        NavigationService().navigateTo(destinationMode: NavigationMode2.SNIPPET_NOTE, note: selectedNotes.first);
      }
  }

  Widget _buildBottomNavigationBar() {  

    print('buildBottoms');
    if(_newNavigationService.isTrashMode() && _notes.isNotEmpty) {
      print('isTrashMOde');
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
          /*cancelCallback: () {
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
           setState(() {
              _notes.add(note);
           });
           _updateNotesCopy();
            if(note is SnippetNote) {
              _newNavigationService.navigateTo(destinationMode: NavigationMode2.SNIPPET_NOTE, note: note);  
            } else if (note is MarkdownNote) {
              _newNavigationService.navigateTo(destinationMode: NavigationMode2.MARKDOWN_NOTE, note: note);   
            }
          },
       */);
    });
  }

  void search() {
    NoteSearch noteSearch = NoteSearch(
      notes:  _notes,
      itemSelectedCallback:  (note) {
        if(note is SnippetNote) {
              _newNavigationService.navigateTo(destinationMode: NavigationMode2.SNIPPET_NOTE, note: note); 
        } else if (note is MarkdownNote) {
          _newNavigationService.navigateTo(destinationMode: NavigationMode2.MARKDOWN_NOTE, note: note);   
        }
      },
      searchFieldLabel: AppLocalizations.of(context).translate('search')
    );

    showSearch(
      context: context,
      delegate: noteSearch
    );
  }

}

