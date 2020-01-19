
import 'package:boostnote_mobile/business_logic/model/Folder.dart';
import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/service/FolderService.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/presentation/screens/markdown_editor/Editor.dart';
import 'package:boostnote_mobile/presentation/screens/overview/Overview.dart';
import 'package:boostnote_mobile/presentation/screens/overview/Refreshable.dart';
import 'package:boostnote_mobile/presentation/screens/snippet_editor/SnippetTestEditor.dart';
import 'package:boostnote_mobile/presentation/widgets/NavigationDrawer.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/CreateFolderDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/NewNoteDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/RenameFolderDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/folderlist/FolderList.dart';
import 'package:flutter/material.dart';

class FolderOverview extends StatefulWidget {

  @override
  _FolderOverviewState createState() => _FolderOverviewState();

}

class _FolderOverviewState extends State<FolderOverview> implements Refreshable{

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  NoteService _noteService;
  FolderService _folderService;
  List<Folder> _folders;

  bool _isTablet = false;

  String _pageTitle = 'Folders';

  @override
  void refresh() {
    _folderService.findAllUntrashed().then((folders) {
      setState((){ 
        _folders = folders;
      });
    });
  }
  
  @override
  void initState(){
    super.initState();
    _folders = List();
    _noteService = NoteService();
    _folderService = FolderService();
    _folderService.findAllUntrashed().then((folders) {
      setState((){ 
        _folders = folders;
      });
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    key: _drawerKey,
    appBar: _buildAppBar(context),
    drawer: _buildDrawer(context),
    body: _buildBody(context),
    floatingActionButton: _buildFloatingActionButton(context),
  );

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(_pageTitle),
      leading: IconButton(
        icon: Icon(Icons.menu, color: Theme.of(context).accentColor), 
        onPressed: () {
          _drawerKey.currentState.openDrawer();
        },
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.create_new_folder), 
          onPressed: _createFolderDialog,
        )
      ],
    );
  }

  Theme _buildDrawer(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
               canvasColor: Theme.of(context).primaryColorLight, 
               textTheme: TextTheme(body1: TextStyle(color: Theme.of(context).primaryColorLight))
            ),
      child: _isTablet ? null : NavigationDrawer(onNavigate: (action) => _onNavigate(action), mode: _pageTitle),
    );
  }

  Widget _buildBody(BuildContext context) {
    double shortestSide = MediaQuery.of(context).size.shortestSide;
    _isTablet = shortestSide >= 600;
    
    Widget body;
    if (_isTablet) {
      body = _buildTabletLayout();
    } else {
      body = _buildMobileLayout();
    }
    return body;
  }

  Widget _buildMobileLayout(){
    return Container(
      child: FolderList(folders: _folders, onRowTap: _onFolderTap, onRowLongPress: _onFolderLongPress)
    );
  }

  Widget _buildTabletLayout(){
    return Row(
      children: <Widget>[
        Flexible(
          flex: 0,
          child: NavigationDrawer(mode: _pageTitle)
        ),
        Flexible(
          flex: 3,
          child: FolderList(folders: _folders, onRowTap: _onFolderTap, onRowLongPress: _onFolderLongPress)
        ),
      ],
    );
  }

//TODO Widget
  FloatingActionButton _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add, color: Color(0xFFF6F5F5)),
      onPressed: (){
        _createDialog(context);
      },
    );
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
          //_presenter.onCreateNotePressed(note);
          //openNote(note);   
        },
      );
    });
  }

  void _createFolderDialog() {
   showDialog(context: context, 
    builder: (context){
      return CreateFolderDialog(
        cancelCallback: () {
          Navigator.of(context).pop();
        }, 
        saveCallback: (String folderName) {
          Navigator.of(context).pop();
          _createFolder(folderName);
        },
      );
    });
  }

  void _renameFolderDialog(Folder folder) {
   showDialog(context: context, 
    builder: (context){
      return RenameFolderDialog(
        folder: folder,
        cancelCallback: () {
          Navigator.of(context).pop();
        }, 
        saveCallback: (String newFolderName) {
          Navigator.of(context).pop();
          _renameFolder(folder, newFolderName);
        },
      );
    });
  }

  void _createFolder(String folderName) {
    _folderService.createFolderIfNotExisting(Folder(name: folderName));

    refresh();
  }

  void _onFolderTap(Folder folder) {
    _noteService.findUntrashedNotesIn(folder).then((notes) {
     Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Overview(notes: notes, mode: NaviagtionDrawerAction.NOTES_IN_FOLDER, selectedFolder: folder,))
     );
   });
  }

  void _onFolderLongPress(Folder folder) {
   showModalBottomSheet(
      context: context,
      builder: (BuildContext buildContext){
        return Container(
          child: new Wrap(
          children: <Widget>[
            new ListTile(
              leading: new Icon(Icons.delete),
              title: new Text('Remove Folder'),
              onTap: () {
                Navigator.of(context).pop();
                _removeFolder(folder);
              }      
            ),
            new ListTile(
              leading: new Icon(Icons.folder),
              title: new Text('Rename Folder'),
              onTap: () {
                Navigator.of(context).pop();
                _renameFolderDialog(folder);
              }      
            ),
          ],
          ),
        );
      }
    );
  }

  void _renameFolder(Folder oldFolder, String newName) {
    _folderService.renameFolder(oldFolder, newName);
    refresh();
  }

  void _removeFolder(Folder folder) {
    _folderService.delete(folder);
    refresh();
  }

  void _openNote(Note note){
     Widget editor = note is MarkdownNote ? Editor(_isTablet, note, this) : SnippetTestEditor(note, this);
     Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => editor)
     );
  }

  _onNavigate(int action) {
    switch (action) {
      case NaviagtionDrawerAction.ALL_NOTES:
        _pageTitle = 'All Notes';
        Navigator.pushNamed(context, '/AllNotes');
        break;
      case NaviagtionDrawerAction.TRASH:
        _pageTitle = 'Trashed Notes';
         Navigator.pushNamed(context, '/TrashedNotes');
        break;
      case NaviagtionDrawerAction.STARRED:
        _pageTitle = 'Starred Notes';
         Navigator.pushNamed(context, '/StarredNotes');
        //_presenter.showStarredNotes();
       break;
      case NaviagtionDrawerAction.FOLDERS:
        Navigator.of(context).pop();
        //_presenter.showStarredNotes();
      break;
    }
  }

}