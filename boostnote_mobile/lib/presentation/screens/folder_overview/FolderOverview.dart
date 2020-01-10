
import 'package:boostnote_mobile/business_logic/model/Folder.dart';
import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/service/FolderService.dart';
import 'package:boostnote_mobile/presentation/screens/markdown_editor/Editor.dart';
import 'package:boostnote_mobile/presentation/screens/overview/Refreshable.dart';
import 'package:boostnote_mobile/presentation/screens/snippet_editor/SnippetTestEditor.dart';
import 'package:boostnote_mobile/presentation/widgets/NavigationDrawer.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/NewNoteDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/folderlist/FolderList.dart';
import 'package:flutter/material.dart';

class FolderOverview extends StatefulWidget {

  @override
  _FolderOverviewState createState() => _FolderOverviewState();

}

class _FolderOverviewState extends State<FolderOverview> implements Refreshable{

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  FolderService _folderService;
  List<Folder> _folders;

  bool _isTablet = false;

  String _pageTitle = 'Folders';

  @override
  void refresh() {
    // TODO: implement refresh
  }
  
  @override
  void initState(){
    super.initState();
    _folders = List();
    _folderService = FolderService();
    _folderService.findAll().then((folders) {
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
          onPressed: () {},
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
      body = _buildTabletLayout(_folders);
    } else {
      body = _buildMobileLayout(_folders);
    }
    return body;
  }

  Widget _buildMobileLayout(List<Folder> folders){
    return Container(
      child: FolderList(folders: _folders, rowSelectedCallback: (folder) {},)
    );
  }

  Widget _buildTabletLayout(List<Folder> folders){
    return Row(
      children: <Widget>[
        Flexible(
          flex: 0,
          child: NavigationDrawer(mode: _pageTitle)
        ),
        Flexible(
          flex: 3,
          child: FolderList(folders: _folders, rowSelectedCallback: (folder) {},)
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
          openNote(note);   
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
        _pageTitle = 'All Notes';
        //_presenter.showAllNotes();
        break;
      case NaviagtionDrawerAction.TRASH:
        _pageTitle = 'Trashed Notes';
        //_presenter.showTrashedNotes();
        break;
      case NaviagtionDrawerAction.STARRED:
        _pageTitle = 'Starred Notes';
        //_presenter.showStarredNotes();
       break;
      case NaviagtionDrawerAction.FOLDERS:
        _pageTitle = 'Folders';
        //_presenter.showStarredNotes();
      break;
    }
  }

}