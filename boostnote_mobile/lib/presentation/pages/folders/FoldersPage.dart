import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/presentation/navigation/PageNavigator.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/SnippetNotifier.dart';
import 'package:boostnote_mobile/presentation/pages/code_editor/CodeSnippetEditor.dart';
import 'package:boostnote_mobile/presentation/pages/folders/widgets/CombinedFoldersAndEditorAppbar.dart';
import 'package:boostnote_mobile/presentation/pages/folders/widgets/folderlist/FolderList.dart';
import 'package:boostnote_mobile/presentation/pages/markdown_editor/MarkdownEditor.dart';
import 'package:boostnote_mobile/presentation/widgets/NavigationDrawer.dart';
import 'package:boostnote_mobile/presentation/widgets/buttons/ResponsiveFloatingActionButton.dart';
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

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  NoteNotifier _noteNotifier;

  @override
  Widget build(BuildContext context) {
    _initNotifier();
    return _buildScaffold(context);
  }

  void _initNotifier() {
    _noteNotifier = Provider.of<NoteNotifier>(context);
  }

  Widget _buildScaffold(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        key: _drawerKey,
        appBar: _buildAppbar(),
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

  CombinedFoldersAndEditorAppbar _buildAppbar() {
    return CombinedFoldersAndEditorAppbar(
      openDrawer: () => _drawerKey.currentState.openDrawer()
    );
  }

  Widget _buildBody(BuildContext context) {
    return ResponsiveWidget(
      widgets: <ResponsiveChild> [
        ResponsiveChild(
          smallFlex: _noteNotifier.note == null ? 1 : 0, 
          largeFlex: _noteNotifier.isEditorExpanded ? 0 : 2, 
          child: FolderList()
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




