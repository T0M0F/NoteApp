import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
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

class OverviewPageAppbar extends StatefulWidget  implements PreferredSizeWidget{

  Function(String action) onSelectedActionCallback;
  Function() onMenuClickCallback;
  Function() onNaviagteBackCallback;
  Function(List<Note>) onSearchCallback;
  Function(bool) onMarkdownEditorViewModeSwitchedCallback;
  Function() onSnippetEditorViewModeSwitched;
  Function() closeNote;

  String pageTitle;
  bool tilesAreExpanded;
  bool showListView;
  bool markdownEditorPreviewMode;
  List<Note> notes;
  Note note;

  CodeSnippet selectedCodeSnippet;
  Function(CodeSnippet) onSelectedCodeSnippetChanged;
  bool snippetEditorEditMode;

  OverviewPageAppbar({this.tilesAreExpanded, this.showListView, this.pageTitle, this.notes, this.note, this.selectedCodeSnippet , this.snippetEditorEditMode, this.markdownEditorPreviewMode, this.onMenuClickCallback, this.onNaviagteBackCallback, this.onSelectedActionCallback, this.onSearchCallback, this.onMarkdownEditorViewModeSwitchedCallback, this.onSelectedCodeSnippetChanged, this.onSnippetEditorViewModeSwitched, this.closeNote});

  @override
  _OverviewPageAppbarState createState() => _OverviewPageAppbarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _OverviewPageAppbarState extends State<OverviewPageAppbar> {

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      showDivider: true,
      widgets: <ResponsiveChild> [
         ResponsiveChild(
              smallFlex: widget.note == null ? 1 : 0, 
              largeFlex: 2, 
              child: OverviewAppbar(
                pageTitle: widget.pageTitle,
                notes: widget.notes,
                actions: {
                  'EXPAND_ACTION': ActionConstants.EXPAND_ACTION, 
                  'COLLPASE_ACTION': ActionConstants.COLLPASE_ACTION, 
                  'SHOW_LISTVIEW_ACTION': ActionConstants.SHOW_LISTVIEW_ACTION, 
                  'SHOW_GRIDVIEW_ACTION' : ActionConstants.SHOW_GRIDVIEW_ACTION},
                listTilesAreExpanded: widget.tilesAreExpanded,
                showListView: widget.showListView,
                onMenuClickCallback: widget.onMenuClickCallback,
                onNaviagteBackCallback: widget.onNaviagteBackCallback, 
                onSelectedActionCallback: widget.onSelectedActionCallback,
                onSearchCallback: widget.onSearchCallback
              )
            ),
        ResponsiveChild(
          smallFlex: widget.note == null ? 0 : 1, 
          largeFlex: 3, 
          child: buildChild(context)
        )
      ]
    );
  }

  Widget buildChild(BuildContext context) {
    return widget.note == null   //Sonst fliegt komische exception, wenn in methode ausgelagert
          ? EmptyAppbar()
          : widget.note is MarkdownNote
            ? MarkdownEditorAppBar(
                isPreviewMode: widget.markdownEditorPreviewMode,
                isNoteStarred: widget.note.isStarred,
                onViewModeSwitchedCallback: widget.onMarkdownEditorViewModeSwitchedCallback,
                selectedActionCallback: widget.onSelectedActionCallback,
                closeNote: widget.closeNote
            )
            : widget.snippetEditorEditMode
              ? AppBar(
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Theme.of(context).buttonColor), 
                    onPressed: widget.closeNote
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.check, color: Theme.of(context).buttonColor), 
                      onPressed: widget.onSnippetEditorViewModeSwitched
                    )
                  ]
              )
              : CodeSnippetAppBar(
                note: widget.note, 
                selectedCodeSnippet: widget.selectedCodeSnippet,
                selectedActionCallback: widget.onSelectedActionCallback,
                onSelectedSnippetChanged: widget.onSelectedCodeSnippetChanged,
                closeNote: widget.closeNote
              );
  }
}