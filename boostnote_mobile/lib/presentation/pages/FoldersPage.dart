import 'package:boostnote_mobile/business_logic/model/Folder.dart';
import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:boostnote_mobile/business_logic/service/FolderService.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/data/entity/SnippetNoteEntity.dart';
import 'package:boostnote_mobile/presentation/navigation/NavigationService.dart';
import 'package:boostnote_mobile/presentation/notifiers/FolderNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteOverviewNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/SnippetNotifier.dart';
import 'package:boostnote_mobile/presentation/pages/CodeSnippetEditor.dart';
import 'package:boostnote_mobile/presentation/pages/FoldersPageAppbar.dart';
import 'package:boostnote_mobile/presentation/pages/MarkdownEditor.dart';
import 'package:boostnote_mobile/presentation/pages/PageNavigator.dart';
import 'package:boostnote_mobile/presentation/pages/ResponsiveFloatingActionButton.dart';
import 'package:boostnote_mobile/presentation/screens/ActionConstants.dart';
import 'package:boostnote_mobile/presentation/screens/note_overview/Refreshable.dart';
import 'package:boostnote_mobile/presentation/widgets/NavigationDrawer.dart';
import 'package:boostnote_mobile/presentation/widgets/appbar/FolderOverviewAppbar.dart';
import 'package:boostnote_mobile/presentation/widgets/bottom_sheets/FolderOverviewBottomSheet.dart';
import 'package:boostnote_mobile/presentation/widgets/bottom_sheets/FolderOverviewErrorBottomSheet.dart';
import 'package:boostnote_mobile/presentation/widgets/buttons/AddFloatingActionButton.dart';
import 'package:boostnote_mobile/presentation/widgets/buttons/CreateNoteFloatingActionButton.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/AddSnippetDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/CreateFolderDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/EditSnippetNameDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/NewNoteDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/RenameFolderDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/folderlist/FolderList.dart';
import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveChild.dart';
import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';


class FoldersPage extends StatefulWidget {
  @override
  _FoldersPageState createState() => _FoldersPageState();

}

class _FoldersPageState extends State<FoldersPage> {

  NoteService _noteService;

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  NoteNotifier _noteNotifier;
  NoteOverviewNotifier _noteOverviewNotifier;
  FolderNotifier _folderNotifier;
  SnippetNotifier _snippetNotifier;

  @override
  void initState() {
    super.initState();

    _noteService = NoteService();
/*
    if(widget.note is SnippetNote) {
      selectedCodeSnippet = (widget.note as SnippetNote).codeSnippets.isNotEmpty 
        ? (widget.note as SnippetNote).codeSnippets.first
        : null;
    }*/
  }

  @override
  Widget build(BuildContext context) {
    _noteNotifier = Provider.of<NoteNotifier>(context);
    _snippetNotifier = Provider.of<SnippetNotifier>(context);
    _noteOverviewNotifier = Provider.of<NoteOverviewNotifier>(context);
    _folderNotifier = Provider.of<FolderNotifier>(context);

    return _buildScaffold(context);
  }

  Widget _buildScaffold(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        key: _drawerKey,
        appBar: FoldersPageAppbar(
          onSelectedActionCallback: (String action) => _selectedAction(action),
          openDrawer: () => _drawerKey.currentState.openDrawer()
        ),
        drawer: NavigationDrawer(),
        body: _buildBody(context),
        floatingActionButton: ResponsiveFloatingActionButton()
      ), 
      onWillPop: () {
        NoteNotifier _noteNotifier = Provider.of<NoteNotifier>(context);
        SnippetNotifier snippetNotifier = Provider.of<SnippetNotifier>(context);
        if(_drawerKey.currentState.isDrawerOpen) {
          _drawerKey.currentState.openEndDrawer();
        } else if(_noteNotifier.note != null){
          _noteNotifier.note = null;
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

  void _selectedAction(String action){
    switch (action) {
      case ActionConstants.SAVE_ACTION:
        _noteNotifier.note = null;
        _noteService.save(_noteNotifier.note);
        break;
      case ActionConstants.MARK_ACTION:
        _noteNotifier.note.isStarred = true;
        _noteService.save(_noteNotifier.note);
        break;
      case ActionConstants.UNMARK_ACTION:
          _noteNotifier.note.isStarred = false;
        _noteService.save(_noteNotifier.note);
        break;
      case ActionConstants.RENAME_CURRENT_SNIPPET:
       _showRenameSnippetDialog(context);
        break;
      case ActionConstants.DELETE_CURRENT_SNIPPET:
        (_noteNotifier.note as SnippetNote).codeSnippets.remove(_snippetNotifier.selectedCodeSnippet);
        _snippetNotifier.selectedCodeSnippet = (_noteNotifier.note as SnippetNote).codeSnippets.isNotEmpty ? (_noteNotifier.note as SnippetNote).codeSnippets.last : null;
        _noteService.save(_noteNotifier.note);
        break;
    }
  }

  Widget _buildBody(BuildContext context) {
    return ResponsiveWidget(
      widgets: <ResponsiveChild> [
        ResponsiveChild(
          smallFlex: _noteNotifier.note == null ? 1 : 0, 
          largeFlex: 2, 
          child: FolderList()
        ),
        ResponsiveChild(
          smallFlex: _noteNotifier.note == null ? 0 : 1, 
          largeFlex: 3, 
          child: _noteNotifier.note == null
            ? Container()
            : _noteNotifier.note is MarkdownNote
              ? MarkdownEditor()
              : CodeSnippetEditor()
        )
      ]
    );
  }

  Future<String> _showRenameSnippetDialog(BuildContext context) =>
    showDialog(context: context, 
      builder: (context){
        return EditSnippetNameDialog();
  });                                  

}




