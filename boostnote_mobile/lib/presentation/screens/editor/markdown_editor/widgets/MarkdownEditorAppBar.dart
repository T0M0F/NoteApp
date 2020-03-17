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
  Size get preferredSize => Size.fromHeight(kToolbarHeight-15);
}

class _MarkdownEditorAppBarState extends State<MarkdownEditorAppBar> {
  
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white24,
    
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Color(0xFF2E3235),), 
        onPressed: widget.onNavigateBackCallback,
      ),
      actions: <Widget>[
        Switch(
          inactiveThumbColor: Color(0xFF1EC38B),
          inactiveTrackColor: Colors.black54,
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