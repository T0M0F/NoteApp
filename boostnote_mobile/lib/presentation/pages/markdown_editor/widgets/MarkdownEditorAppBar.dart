import 'package:boostnote_mobile/presentation/notifiers/MarkdownEditorNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteNotifier.dart';
import 'package:boostnote_mobile/presentation/pages/markdown_editor/widgets/OverflowButton.dart';
import 'package:boostnote_mobile/presentation/responsive/DeviceWidthService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';


class MarkdownEditorAppBar extends StatefulWidget implements PreferredSizeWidget {

  final Function(String) selectedActionCallback;

  MarkdownEditorAppBar({this.selectedActionCallback});

  @override
  _MarkdownEditorAppBarState createState() => _MarkdownEditorAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
 
class _MarkdownEditorAppBarState extends State<MarkdownEditorAppBar> {

  NoteNotifier _noteNotifier;
  MarkdownEditorNotifier _markdownEditorNotifier;
  
  @override
  Widget build(BuildContext context) {
    _noteNotifier = Provider.of<NoteNotifier>(context);
    _markdownEditorNotifier = Provider.of<MarkdownEditorNotifier>(context);

    return AppBar(
      leading: _buildLeadingIcon(),
      actions: <Widget>[
        Switch(
          inactiveThumbColor: Theme.of(context).accentColor,
          inactiveTrackColor: Theme.of(context).buttonColor,
          value: _markdownEditorNotifier.isPreviewMode, 
          onChanged: (bool isPreviewMode) => _markdownEditorNotifier.isPreviewMode = isPreviewMode,
        ),
        OverflowButton(
          noteIsStarred: _noteNotifier.note.isStarred,
          selectedActionCallback: widget.selectedActionCallback
        )
      ],
    );
  }


  Widget _buildLeadingIcon() {
    if(DeviceWidthService(context).isTablet()) {
      return IconButton(
        icon: Icon(_noteNotifier.isEditorExpanded ? MdiIcons.chevronRight : MdiIcons.chevronLeft, color:  Theme.of(context).buttonColor), 
        onPressed:() {
          _noteNotifier.isEditorExpanded = !_noteNotifier.isEditorExpanded;
        },
      );
    } else {
      return IconButton(
        icon: Icon(Icons.arrow_back, color:  Theme.of(context).buttonColor), 
        onPressed:() {
          _noteNotifier.note = null;
          _noteNotifier.isEditorExpanded = false;
        },
      );
    }
  }

}