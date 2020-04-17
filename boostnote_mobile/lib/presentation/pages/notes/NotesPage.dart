import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/presentation/ActionConstants.dart';
import 'package:boostnote_mobile/presentation/navigation/PageNavigator.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteOverviewNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/SnippetNotifier.dart';
import 'package:boostnote_mobile/presentation/pages/code_editor/CodeSnippetEditor.dart';
import 'package:boostnote_mobile/presentation/pages/markdown_editor/MarkdownEditor.dart';
import 'package:boostnote_mobile/presentation/pages/notes/widgets/CombinedNotesAndEditorAppbar.dart';
import 'package:boostnote_mobile/presentation/pages/notes/widgets/notesgrid/NoteGrid.dart';
import 'package:boostnote_mobile/presentation/pages/notes/widgets/noteslist/NoteList.dart';
import 'package:boostnote_mobile/presentation/widgets/NavigationDrawer.dart';
import 'package:boostnote_mobile/presentation/widgets/buttons/ResponsiveFloatingActionButton.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/EditSnippetNameDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveChild.dart';
import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';


class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  NoteService _noteService = NoteService();
  NoteNotifier _noteNotifier;
  NoteOverviewNotifier _noteOverviewNotifier;
  SnippetNotifier _snippetNotifier;

  @override
  Widget build(BuildContext context) {
    _initNotifiers();
    return _buildScaffold(context);
  }

  void _initNotifiers() {
    _noteNotifier = Provider.of<NoteNotifier>(context);
    _snippetNotifier = Provider.of<SnippetNotifier>(context);
    _noteOverviewNotifier = Provider.of<NoteOverviewNotifier>(context);
  }

  Widget _buildScaffold(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        key: _drawerKey,
        appBar: _buildAppBar(),
        drawer: NavigationDrawer(), 
        body: _buildBody(), 
        floatingActionButton: ResponsiveFloatingActionButton()
      ), 
      onWillPop: () {
        NoteNotifier _noteNotifier = Provider.of<NoteNotifier>(context);
        SnippetNotifier snippetNotifier = Provider.of<SnippetNotifier>(context);
        if(_drawerKey.currentState.isDrawerOpen) {
          _drawerKey.currentState.openEndDrawer();
        } else if(_noteNotifier.note != null){
          _noteNotifier.note = null;
          _noteNotifier.isEditorExpanded = false;
          snippetNotifier.selectedCodeSnippet = null;
        } else if(PageNavigator().pageNavigatorState == PageNavigatorState.ALL_NOTES){
          SystemNavigator.pop();
        } else {
          PageNavigator().navigateBack(context);
          Navigator.of(context).pop();
        }
      },
    );  
  }

  PreferredSizeWidget _buildAppBar() { 
    return CombinedNotesAndEditorAppbar(
      onMenuClick: () => _drawerKey.currentState.openDrawer(),
    );
  }

  ResponsiveWidget _buildBody() {
    return ResponsiveWidget(
      widgets: <ResponsiveChild> [
        ResponsiveChild(
          smallFlex: _noteNotifier.note == null ? 1 : 0, 
          largeFlex: _noteNotifier.isEditorExpanded ? 0 : 2, 
          child: _noteOverviewNotifier.showListView ? NoteList() : NoteGrid(),
        ),
        ResponsiveChild(
          smallFlex: _noteNotifier.note == null ? 0 : 1, 
          largeFlex: _noteNotifier.isEditorExpanded ? 1 : 3, 
          child: _noteNotifier.note == null
            ? Container()
            : _noteNotifier.note is MarkdownNote
              ? MarkdownEditor()
              : CodeSnippetEditor()
        )
      ]
    );
  }

}