import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:boostnote_mobile/presentation/pages/EmptyAppbar.dart';
import 'package:boostnote_mobile/presentation/screens/editor/markdown_editor/widgets/MarkdownEditorAppBar.dart';
import 'package:boostnote_mobile/presentation/screens/editor/snippet_editor/widgets/CodeSnippetAppBar.dart';
import 'package:boostnote_mobile/presentation/widgets/appbar/FolderOverviewAppbar.dart';
import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveChild.dart';
import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FoldersPageAppbar extends StatefulWidget  implements PreferredSizeWidget{

  Function(String action) onSelectedActionCallback;
  Function(bool) onMarkdownEditorViewModeSwitchedCallback;
  Function() onSnippetEditorViewModeSwitched;
  Function() closeNote;
  final Function() onCreateFolderCallback;
  final Function() onMenuClickCallback;

  bool markdownEditorPreviewMode;
  Note note;
  CodeSnippet selectedCodeSnippet;
  Function(CodeSnippet) onSelectedCodeSnippetChanged;
  bool snippetEditorEditMode;

  FoldersPageAppbar({this.note, this.selectedCodeSnippet , this.snippetEditorEditMode, this.markdownEditorPreviewMode, this.onSelectedActionCallback, this.onMarkdownEditorViewModeSwitchedCallback, this.onSelectedCodeSnippetChanged, this.onSnippetEditorViewModeSwitched, this.closeNote, this.onCreateFolderCallback, this.onMenuClickCallback});

  @override
  _FoldersPageAppbarState createState() => _FoldersPageAppbarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _FoldersPageAppbarState extends State<FoldersPageAppbar> {

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      showDivider: true,
      widgets: <ResponsiveChild> [
         ResponsiveChild(
              smallFlex: widget.note == null ? 1 : 0, 
              largeFlex: 2, 
              child: FolderOverviewAppbar(
                onCreateFolderCallback: widget.onCreateFolderCallback,
                onMenuClickCallback: widget.onMenuClickCallback,
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