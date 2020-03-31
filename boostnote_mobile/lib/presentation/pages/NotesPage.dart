import 'package:boostnote_mobile/business_logic/model/Folder.dart';
import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/data/entity/SnippetNoteEntity.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteOverviewNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/SnippetNotifier.dart';
import 'package:boostnote_mobile/presentation/pages/CodeSnippetEditor.dart';
import 'package:boostnote_mobile/presentation/pages/MarkdownEditor.dart';
import 'package:boostnote_mobile/presentation/pages/Overview.dart';
import 'package:boostnote_mobile/presentation/pages/OverviewPageAppbar.dart';
import 'package:boostnote_mobile/presentation/pages/ResponsiveFloatingActionButton.dart';
import 'package:boostnote_mobile/presentation/screens/ActionConstants.dart';
import 'package:boostnote_mobile/presentation/widgets/NavigationDrawer.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/EditSnippetNameDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveChild.dart';
import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {

  String pageTitle;
  String tag;
  Folder folder;

  NotesPage({@required this.pageTitle, this.tag, this.folder});

  @override
  _NotesPageState createState() => _NotesPageState();

}

class _NotesPageState extends State<NotesPage> {

  NoteService _noteService = NoteService();

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  NoteNotifier noteNotifier;
  NoteOverviewNotifier _noteOverviewNotifier;
  SnippetNotifier _snippetNotifier;

  @override
  void initState() {
    super.initState();

    /*if(widget.note is SnippetNote) {
      selectedCodeSnippet = (widget.note as SnippetNote).codeSnippets.isNotEmpty 
        ? (widget.note as SnippetNote).codeSnippets.first
        : null;
    }*/

   /* if(widget.notes == null) {
      widget.notes = List();
      _noteService.findNotTrashed().then((result) { 
        update(result);
      });
    } 

    notesCopy = List<Note>.from(widget.notes);*/
  }

  void update(List<Note> notes, BuildContext context){
    setState(() {
      if(_noteOverviewNotifier.notes != null){
        _noteOverviewNotifier.notes.replaceRange(0, _noteOverviewNotifier.notes.length, notes);
      } else {
        _noteOverviewNotifier.notes = notes;
      }
      _noteOverviewNotifier.notesCopy = List<Note>.from(_noteOverviewNotifier.notes);
    });
  }

  @override
  Widget build(BuildContext context) {
    noteNotifier = Provider.of<NoteNotifier>(context);
    _snippetNotifier = Provider.of<SnippetNotifier>(context);
    _noteOverviewNotifier = Provider.of<NoteOverviewNotifier>(context);

    return _buildScaffold(context);
  }

  Scaffold _buildScaffold(BuildContext context) {
    return  Scaffold(
      key: _drawerKey,
      appBar: _buildAppBar(),
      drawer: NavigationDrawer(), 
      body: _buildBody(), 
      floatingActionButton: ResponsiveFloatingActionButton()
    );  
  }

  PreferredSizeWidget _buildAppBar() { 
     return OverviewPageAppbar(
        pageTitle: widget.pageTitle,
        onNaviagteBackCallback: () {}, 
        onSelectedActionCallback: (String action) => _selectedAction(action),
        onSearchCallback: (filteredNotes) {
          update(filteredNotes, context);
        },
        onMenuClick: () => _drawerKey.currentState.openDrawer(),
      );
  }

  void _selectedAction(String action){
    switch (action) {
      case ActionConstants.COLLPASE_ACTION:
        _noteOverviewNotifier.expandedTiles = false;
        break;
      case ActionConstants.EXPAND_ACTION:
        _noteOverviewNotifier.expandedTiles = true;
        break;
      case ActionConstants.SHOW_GRIDVIEW_ACTION:
        _noteOverviewNotifier.showListView = false;
        break;
      case ActionConstants.SHOW_LISTVIEW_ACTION:
        _noteOverviewNotifier.showListView = true;
        break;
      case ActionConstants.SAVE_ACTION:
        setState(() {
          noteNotifier.note = null;
        });
        _noteService.save(noteNotifier.note);
        break;
      case ActionConstants.MARK_ACTION:
       setState(() {
          noteNotifier.note.isStarred = true;
        });
        _noteService.save(noteNotifier.note);
        break;
      case ActionConstants.UNMARK_ACTION:
        setState(() {
          noteNotifier.note.isStarred = false;
        });
        _noteService.save(noteNotifier.note);
        break;
      case ActionConstants.RENAME_CURRENT_SNIPPET:
       _showRenameSnippetDialog(context, (String name){
          setState(() {
            _snippetNotifier.selectedCodeSnippet.name = name;
          });
          Navigator.of(context).pop();
          _noteService.save(noteNotifier.note);
        });
        break;
      case ActionConstants.DELETE_CURRENT_SNIPPET:
        setState(() {
          (noteNotifier.note as SnippetNote).codeSnippets.remove(_snippetNotifier.selectedCodeSnippet);
          _snippetNotifier.selectedCodeSnippet = (noteNotifier.note as SnippetNote).codeSnippets.isNotEmpty ? (noteNotifier.note as SnippetNote).codeSnippets.last : null;
        });
        _noteService.save(noteNotifier.note);
        break;
      case ActionConstants.DELETE_CURRENT_SNIPPET:
         setState(() {
          (noteNotifier.note as SnippetNote).codeSnippets.remove(_snippetNotifier.selectedCodeSnippet);
          _snippetNotifier.selectedCodeSnippet = (noteNotifier.note as SnippetNote).codeSnippets.isNotEmpty ? (noteNotifier.note as SnippetNote).codeSnippets.last : null;
        });
        _noteService.save(noteNotifier.note);
        break;
    }
  }

  ResponsiveWidget _buildBody() {
    return ResponsiveWidget(
      widgets: <ResponsiveChild> [
        ResponsiveChild(
          smallFlex: noteNotifier.note == null ? 1 : 0, 
          largeFlex: 2, 
          child: Overview()
        ),
        ResponsiveChild(
          smallFlex: noteNotifier.note == null ? 0 : 1, 
          largeFlex: 3, 
          child: noteNotifier.note == null
            ? Container()
            : noteNotifier.note is MarkdownNote
              ? MarkdownEditor()
              : CodeSnippetEditor()
        )
      ]
    );
  }

  Future<String> _showRenameSnippetDialog(BuildContext context, Function(String) callback) =>
    showDialog(context: context, 
      builder: (context){
        return EditSnippetNameDialog();
  });

}