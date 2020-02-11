
import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/business_logic/service/TagService.dart';
import 'package:boostnote_mobile/presentation/NavigationService.dart';
import 'package:boostnote_mobile/presentation/screens/markdown_editor/Editor.dart';
import 'package:boostnote_mobile/presentation/screens/overview/Refreshable.dart';
import 'package:boostnote_mobile/presentation/screens/snippet_editor/SnippetTestEditor.dart';
import 'package:boostnote_mobile/presentation/widgets/AddFloatingActionButton.dart';
import 'package:boostnote_mobile/presentation/widgets/NavigationDrawer.dart';
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

  NavigationService _navigationService;
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
      });
    });
  }
  
  @override
  void initState(){
    super.initState();
    _tags = List();
    _navigationService = NavigationService();
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
    floatingActionButton: AddFloatingActionButton(onPressed: () => _createNoteDialog())
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
      child: _isTablet ? null : NavigationDrawer(),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      child: TagList(
        tags: _tags, 
        onRowTap: _onRowTap, 
        onRowLongPress: _onRowLongPress
      )
    );
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
          _createNote(note);
          _navigationService.openNote(note, context, this, _isTablet);
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

  void _onRowTap(String tag) {
    _navigationService.navigateTo(context, NavigationMode.NOTES_WITH_TAG_MODE, tag: tag);
  }

  void _onRowLongPress(String tag) {
    showModalBottomSheet(     //TODO extract widget
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
    _tagService
        .createTagIfNotExisting(tag)
        .whenComplete(() => refresh());
  }


  void _renameTag(String oldTag, String newTag) {
    _tagService
        .renameTag(oldTag, newTag)
        .whenComplete(() => refresh());
  }

  void _removeTag(String tag) {
    _tagService
        .delete(tag)
        .whenComplete(() => refresh());
  }

  void _createNote(Note note) {
    _noteService
        .createNote(note)
        .whenComplete(() => refresh());
  }
}