import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/business_logic/service/TagService.dart';
import 'package:boostnote_mobile/presentation/NavigationService.dart';
import 'package:boostnote_mobile/presentation/NewNavigationService.dart';
import 'package:boostnote_mobile/presentation/screens/note_overview/Refreshable.dart';
import 'package:boostnote_mobile/presentation/widgets/AddFloatingActionButton.dart';
import 'package:boostnote_mobile/presentation/widgets/NavigationDrawer.dart';
import 'package:boostnote_mobile/presentation/widgets/appbar/TagOverviewAppbar.dart';
import 'package:boostnote_mobile/presentation/widgets/bottom_sheets/TagOverviewBottomSheet.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/CreateTagDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/NewNoteDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/RenameTagDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/taglist/TagList.dart';
import 'package:flutter/material.dart';


class TagOverview extends StatefulWidget {  

  @override
  _TagOverviewState createState() => _TagOverviewState();

}
 
class _TagOverviewState extends State<TagOverview> implements Refreshable{

 // NavigationService _navigationService;
  NewNavigationService _newNavigationService;
  NoteService _noteService;
  TagService _tagService;
  List<String> _tags;

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  void initState(){
    super.initState();

    _tags = List();
    _newNavigationService = NewNavigationService();
    //_navigationService = NavigationService();
    _noteService = NoteService();
    _tagService = TagService();

    _tagService.findAll().then((tags) {
      setState((){ 
        _tags = tags;
      });
    });
  }

  @override
  void refresh() {
    _tagService.findAll().then((tags) {
      //TODO update navigationListCahe??
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
  Widget build(BuildContext context) => Scaffold(
    key: _drawerKey,
    appBar: TagOverviewAppbar(
      onMenuClickCallback: () => _drawerKey.currentState.openDrawer(),
      onCreateTagCallback: _createTagDialog,
    ),
    drawer: NavigationDrawer(),
    body: _buildBody(context),
    floatingActionButton: AddFloatingActionButton(onPressed: () => _createNoteDialog())
  );

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
          //_navigationService.openNote(note, context, this);
          if(note is MarkdownNote) {
            _newNavigationService.navigateTo(destinationMode: NavigationMode2.MARKDOWN_NOTE, note: note);
          } else if(note is SnippetNote) {
            _newNavigationService.navigateTo(destinationMode: NavigationMode2.SNIPPET_NOTE, note: note);
          }
          
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
    //_navigationService.navigateTo(context, NavigationMode.NOTES_WITH_TAG_MODE, tag: tag);
    _newNavigationService.navigateTo(destinationMode: NavigationMode2.NOTES_WITH_TAG_MODE, tag: tag);
  }

  void _onRowLongPress(String tag) {
    showModalBottomSheet(     
      context: context,
      builder: (BuildContext buildContext){
        return TagOverviewBottomSheet(
          removeTagCallback: () {
            Navigator.of(context).pop();
            _removeTag(tag);
          } ,
          renameTagCallback: () {
            Navigator.of(context).pop();
            _renameTagDialog(tag);
          } 
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