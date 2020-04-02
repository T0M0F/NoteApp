import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:boostnote_mobile/presentation/pages/EmptyAppbar.dart';
import 'package:boostnote_mobile/presentation/screens/editor/markdown_editor/widgets/MarkdownEditorAppBar.dart';
import 'package:boostnote_mobile/presentation/screens/editor/snippet_editor/widgets/CodeSnippetAppBar.dart';
import 'package:boostnote_mobile/presentation/widgets/appbar/FolderOverviewAppbar.dart';
import 'package:boostnote_mobile/presentation/widgets/appbar/TagOverviewAppbar.dart';
import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveChild.dart';
import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TagsPageAppbar extends StatefulWidget  implements PreferredSizeWidget{

  Function(String action) onSelectedActionCallback;
  Function(bool) onMarkdownEditorViewModeSwitchedCallback;
  Function() onSnippetEditorViewModeSwitched;
  Function() closeNote;
  final Function() onCreateTagCallback;
  final Function() openDrawer;

  bool markdownEditorPreviewMode;
  Note note;
  CodeSnippet selectedCodeSnippet;
  Function(CodeSnippet) onSelectedCodeSnippetChanged;
  bool snippetEditorEditMode;

  TagsPageAppbar({this.note, this.selectedCodeSnippet , this.snippetEditorEditMode, this.markdownEditorPreviewMode, this.onSelectedActionCallback, this.onMarkdownEditorViewModeSwitchedCallback, this.onSelectedCodeSnippetChanged, this.onSnippetEditorViewModeSwitched, this.closeNote, this.onCreateTagCallback, this.openDrawer});

  @override
  _TagsPageAppbarState createState() => _TagsPageAppbarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _TagsPageAppbarState extends State<TagsPageAppbar> {

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      showDivider: true,
      widgets: <ResponsiveChild> [
         ResponsiveChild(
              smallFlex: widget.note == null ? 1 : 0, 
              largeFlex: 2, 
              child: TagOverviewAppbar(
                onCreateTagCallback: widget.onCreateTagCallback,
                openDrawer: widget.openDrawer,
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
                isNoteStarred: widget.note.isStarred,
                selectedActionCallback: widget.onSelectedActionCallback,
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
              : CodeSnippetAppBar(selectedActionCallback: widget.onSelectedActionCallback);
  }
}