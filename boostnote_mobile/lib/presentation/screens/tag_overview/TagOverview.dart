import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/business_logic/service/TagService.dart';
import 'package:boostnote_mobile/presentation/navigation/NavigationService.dart';
import 'package:boostnote_mobile/presentation/screens/note_overview/Refreshable.dart';
import 'package:boostnote_mobile/presentation/widgets/NavigationDrawer.dart';
import 'package:boostnote_mobile/presentation/widgets/appbar/TagOverviewAppbar.dart';
import 'package:boostnote_mobile/presentation/widgets/bottom_sheets/TagOverviewBottomSheet.dart';
import 'package:boostnote_mobile/presentation/widgets/buttons/CreateNoteFloatingActionButton.dart';
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

  NavigationService _newNavigationService;
  NoteService _noteService;
  TagServiceV2 _tagService;
  List<String> _tags;

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  void initState(){
    super.initState();

    _tags = List();
    _newNavigationService = NavigationService();
    _noteService = NoteService();
    _tagService = TagServiceV2();

    _tagService.findAll().then((tags) {
      setState((){ 
        _tags = tags;
      });
    });
  }

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
  Widget build(BuildContext context) => Scaffold(
    key: _drawerKey,
    appBar: TagOverviewAppbar(
    
    ),
    drawer: NavigationDrawer(),
    body: _buildBody(context),
    floatingActionButton: CreateNoteFloatingActionButton(onPressed: () => _createNoteDialog())
  );

  Widget _buildBody(BuildContext context) {
    return Container(
      child: TagList(
       
      )
    );
  }

  Future<String> _createNoteDialog() {
    return showDialog(context: context, 
    builder: (context){
      return CreateNoteDialog(
       );
    });
  }

/*
  void _createTagDialog() {
   showDialog(context: context, 
    builder: (context){
      return CreateTagDialog(
    
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

  
  void _onRowTap(String tag) => _newNavigationService
                                      .navigateTo(destinationMode: NavigationMode2.NOTES_WITH_TAG_MODE, tag: tag);


  void _onRowLongPress(String tag) {
    showModalBottomSheet(     
      context: context,
      builder: (BuildContext buildContext){
        return TagOverviewBottomSheet(
       
        );
      }
    );
  }

                              
  void _renameTag(String oldTag, String newTag) => _tagService
                                                      .renameTag(oldTag, newTag)
                                                      .whenComplete(() => refresh());
  
  void _removeTag(String tag) => _tagService
                                      .delete(tag)
                                      .whenComplete(() => refresh());
  
  void _createNote(Note note) => _noteService
                                      .createNote(note)
                                      .whenComplete(() => refresh());
                                      */
}