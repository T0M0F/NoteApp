
import 'package:boostnote_mobile/business_logic/model/Folder.dart';
import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/business_logic/service/TagService.dart';
import 'package:boostnote_mobile/presentation/screens/markdown_editor/Editor.dart';
import 'package:boostnote_mobile/presentation/screens/overview/Overview.dart';
import 'package:boostnote_mobile/presentation/screens/overview/Refreshable.dart';
import 'package:boostnote_mobile/presentation/screens/snippet_editor/SnippetTestEditor.dart';
import 'package:boostnote_mobile/presentation/widgets/NavigationDrawer.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/CreateFolderDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/CreateTagDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/NewNoteDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/RenameTagDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/taglist/TagList.dart';
import 'package:flutter/material.dart';

class TagOverview extends StatefulWidget {  //TODO combine with folderoverview?

  @override
  _TagOverviewState createState() => _TagOverviewState();

}

class _TagOverviewState extends State<TagOverview> implements Refreshable{

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  NoteService _noteService;
  TagService _tagService;
  List<String> _tags;

  bool _isTablet = false;

  String _pageTitle = 'Tags';

  @override
  void refresh() {
    _tagService.findAll().then((tags) {
      setState((){ 
        if(_tags != null){
            _tags.replaceRange(0, _tags.length, tags);
        } else {
          _tags = tags;
        }
        _tags.forEach((t)=> print('nameT ' + t));
      });
    });
  }
  
  @override
  void initState(){
    super.initState();
    print('Init Tag Overview');
    _tags = List();
    _noteService = NoteService();
    _tagService = TagService();
    _tagService.findAll().then((tags) {
      setState((){ 
        _tags = tags;
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
          icon: Icon(Icons.label_outline), 
          onPressed: _createTagDialog,
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
      child: TagList(tags: _tags, onRowTap: _onTagTap, onRowLongPress: _onTagLongPress)
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
          child: TagList(tags: _tags, onRowTap: _onTagTap, onRowLongPress: _onTagLongPress)
        ),
      ],
    );
  }

//TODO Widget
  FloatingActionButton _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add, color: Color(0xFFF6F5F5)),
      onPressed: (){
        _createNoteDialog(context);
      },
    );
  }

  Future<String> _createNoteDialog(BuildContext context) {
    return showDialog(context: context, 
    builder: (context){
      return CreateNoteDialog(
        cancelCallback: () {
          Navigator.of(context).pop();
        }, 
        saveCallback: (Note note) {
          Navigator.of(context).pop();
          //_presenter.onCreateNotePressed(note); //TODO implement
          //openNote(note);   
        },
      );
    });
  }

  void _createTagDialog() {
   showDialog(context: context, 
    builder: (context){
      return CreateTagDialog(
        cancelCallback: () {
          Navigator.of(context).pop();
        }, 
        saveCallback: (String tag) {
          Navigator.of(context).pop();
          _createTag(tag);
        },
      );
    });
  }

  void _renameTagDialog(String tag) {
   showDialog(context: context, 
    builder: (context){
      return RenameTagDialog(
        tag: tag,
        cancelCallback: () {
          Navigator.of(context).pop();
        }, 
        saveCallback: (String newTag) {
          Navigator.of(context).pop();
          _renameTag(tag, newTag);
        },
      );
    });
  }

  void _onTagTap(String tag) {
    _noteService.findNotesByTag(tag).then((notes) {
     Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Overview(notes: notes, mode: NaviagtionDrawerAction.NOTES_WITH_TAG, selectedTag: tag,))
     );
   });
  }

  void _onTagLongPress(String tag) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext buildContext){
        return Container(
          child: new Wrap(
          children: <Widget>[
            new ListTile(
              leading: new Icon(Icons.delete),
              title: new Text('Remove Tag'),
              onTap: () {
                Navigator.of(context).pop();
                _removeTag(tag);
              }      
            ),
            new ListTile(
              leading: new Icon(Icons.folder),
              title: new Text('Rename Tag'),
              onTap: () {
                Navigator.of(context).pop();
                _renameTagDialog(tag);
              }      
            ),
          ],
          ),
        );
      }
    );
  }

  void _createTag(String tag) {
    _tagService.createTagIfNotExisting(tag)
    .then((void v) {
      refresh();
    });
  }


  void _renameTag(String oldTag, String newTag) {
    _tagService.renameTag(oldTag, newTag);
    refresh();
  }

  void _removeTag(String tag) {
    _tagService.delete(tag);
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
      case NaviagtionDrawerAction.NOTES_WITH_TAG:
        Navigator.of(context).pop();
        //_presenter.showStarredNotes();
      break;
    }
  }

}