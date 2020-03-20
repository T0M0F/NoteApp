import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'OverflowButton.dart';

class MarkdownEditorAppBar extends StatefulWidget implements PreferredSizeWidget {

  final Function() onNavigateBackCallback;
  final Function(bool) onViewModeSwitchedCallback;
  final Function(String) selectedActionCallback;

  bool isPreviewMode;
  bool isNoteStarred;

  MarkdownEditorAppBar({this.isPreviewMode, this.isNoteStarred, this.onNavigateBackCallback, this.onViewModeSwitchedCallback, this.selectedActionCallback});

  @override
  _MarkdownEditorAppBarState createState() => _MarkdownEditorAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _MarkdownEditorAppBarState extends State<MarkdownEditorAppBar> {
  
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).backgroundColor,
      brightness: Theme.of(context).accentColorBrightness,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color:  Theme.of(context).iconTheme.color), 
        onPressed: widget.onNavigateBackCallback,
      ),
      actions: <Widget>[
        Switch(
          inactiveThumbColor: Theme.of(context).accentColor,
          inactiveTrackColor: Theme.of(context).iconTheme.color,
          value: widget.isPreviewMode, 
          onChanged: widget.onViewModeSwitchedCallback
        ),
        OverflowButton(
          noteIsStarred: widget.isNoteStarred,
          selectedActionCallback: widget.selectedActionCallback
        )
      ],
    );
  }

}