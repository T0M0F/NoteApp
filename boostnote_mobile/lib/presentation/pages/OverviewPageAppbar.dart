import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:boostnote_mobile/presentation/notifiers/FolderNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteOverviewNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/SnippetNotifier.dart';
import 'package:boostnote_mobile/presentation/pages/EmptyAppbar.dart';
import 'package:boostnote_mobile/presentation/screens/ActionConstants.dart';
import 'package:boostnote_mobile/presentation/screens/editor/markdown_editor/widgets/MarkdownEditorAppBar.dart';
import 'package:boostnote_mobile/presentation/screens/editor/snippet_editor/widgets/CodeSnippetAppBar.dart';
import 'package:boostnote_mobile/presentation/screens/note_overview/widgets/OverviewAppbar.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/EditSnippetNameDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveChild.dart';
import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OverviewPageAppbar extends StatefulWidget  implements PreferredSizeWidget{

  final Function(String action) onSelectedActionCallback;

  final Function onMenuClick;

  OverviewPageAppbar({this.onSelectedActionCallback, this.onMenuClick});

  @override
  _OverviewPageAppbarState createState() => _OverviewPageAppbarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _OverviewPageAppbarState extends State<OverviewPageAppbar> {

  NoteNotifier _noteNotifier;
  SnippetNotifier _snippetNotifier;
  FolderNotifier _folderNotifier;
  NoteOverviewNotifier _noteOverviewNotifier;

  @override
  Widget build(BuildContext context) {
    _noteNotifier = Provider.of<NoteNotifier>(context);
    _snippetNotifier = Provider.of<SnippetNotifier>(context);
    _folderNotifier = Provider.of<FolderNotifier>(context);
    _noteOverviewNotifier = Provider.of<NoteOverviewNotifier>(context);

    return ResponsiveWidget(
      showDivider: true,
      widgets: <ResponsiveChild> [
         ResponsiveChild(
              smallFlex: _noteNotifier.note == null ? 1 : 0, 
              largeFlex: 2, 
              child: _buildLeftAppbar(context)
            ),
        ResponsiveChild(
          smallFlex: _noteNotifier.note == null ? 0 : 1, 
          largeFlex: 3, 
          child: _buildRightAppbar(context)
        )
      ]
    );
  }
 
  Widget _buildLeftAppbar(BuildContext context) {
    return OverviewAppbar(
      notes: _noteOverviewNotifier.notesCopy,
      actions: {
        'EXPAND_ACTION': ActionConstants.EXPAND_ACTION, 
        'COLLPASE_ACTION': ActionConstants.COLLPASE_ACTION, 
        'SHOW_LISTVIEW_ACTION': ActionConstants.SHOW_LISTVIEW_ACTION, 
        'SHOW_GRIDVIEW_ACTION' : ActionConstants.SHOW_GRIDVIEW_ACTION},
      onSelectedActionCallback: widget.onSelectedActionCallback,
      onMenuClick: widget.onMenuClick,
    );
  }

  Widget _buildRightAppbar(BuildContext context) {
    return _noteNotifier.note == null   //Sonst fliegt komische exception, wenn in methode ausgelagert
      ? EmptyAppbar()
      : _noteNotifier.note is MarkdownNote
        ? MarkdownEditorAppBar(selectedActionCallback: widget.onSelectedActionCallback,)
        : _snippetNotifier.isEditMode
          ? AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Theme.of(context).buttonColor), 
                onPressed: () {
                  _noteNotifier.note = null;
                  _folderNotifier.selectedFolder = null;
                  _snippetNotifier.selectedCodeSnippet = null;
                }
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.check, color: Theme.of(context).buttonColor), 
                  onPressed: () => _snippetNotifier.isEditMode = !_snippetNotifier.isEditMode
                )
              ]
          )
          : CodeSnippetAppBar(selectedActionCallback: widget.onSelectedActionCallback);
  }
}