import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/SnippetNotifier.dart';
import 'package:boostnote_mobile/presentation/pages/EmptyAppbar.dart';
import 'package:boostnote_mobile/presentation/screens/editor/markdown_editor/widgets/MarkdownEditorAppBar.dart';
import 'package:boostnote_mobile/presentation/screens/editor/snippet_editor/widgets/CodeSnippetAppBar.dart';
import 'package:boostnote_mobile/presentation/widgets/appbar/TagOverviewAppbar.dart';
import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveChild.dart';
import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TagsPageAppbar extends StatefulWidget  implements PreferredSizeWidget{

  Function(String action) onSelectedActionCallback;
  final Function() openDrawer;

  TagsPageAppbar({this.onSelectedActionCallback, this.openDrawer});

  @override
  _TagsPageAppbarState createState() => _TagsPageAppbarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _TagsPageAppbarState extends State<TagsPageAppbar> {

  NoteNotifier _noteNotifier;
  SnippetNotifier _snippetNotifier; 

  @override
  Widget build(BuildContext context) {
    _noteNotifier = Provider.of<NoteNotifier>(context);
    _snippetNotifier = Provider.of<SnippetNotifier>(context);

    return ResponsiveWidget(
      showDivider: true,
      widgets: <ResponsiveChild> [
         ResponsiveChild(
              smallFlex: _noteNotifier.note == null ? 1 : 0, 
              largeFlex: 2, 
              child: TagOverviewAppbar(openDrawer: widget.openDrawer,)
            ),
        ResponsiveChild(
          smallFlex: _noteNotifier.note == null ? 0 : 1, 
          largeFlex: 3, 
          child: buildSecondChild(context)
        )
      ]
    );
  }

  Widget buildSecondChild(BuildContext context) {
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