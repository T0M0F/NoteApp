import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/presentation/notifiers/MarkdownEditorNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteNotifier.dart';
import 'package:boostnote_mobile/presentation/pages/markdown_editor/widgets/OverflowButton.dart';
import 'package:boostnote_mobile/presentation/widgets/ActionConstants.dart';
import 'package:boostnote_mobile/presentation/widgets/DeviceWidthService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';


class MarkdownEditorAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  _MarkdownEditorAppBarState createState() => _MarkdownEditorAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
 
class _MarkdownEditorAppBarState extends State<MarkdownEditorAppBar> {

  NoteService _noteService = NoteService();
  NoteNotifier _noteNotifier;
  MarkdownEditorNotifier _markdownEditorNotifier;
  
  @override
  Widget build(BuildContext context) {
    _initNotifiers(context);
    return _buildWidget(context);
  }

  void _initNotifiers(BuildContext context) {
     _noteNotifier = Provider.of<NoteNotifier>(context);
    _markdownEditorNotifier = Provider.of<MarkdownEditorNotifier>(context);
  }

  AppBar _buildWidget(BuildContext context) {
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
          selectedActionCallback: (action) => _selectedAction(action)
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

  void _selectedAction(String action){
    switch (action) {
      case ActionConstants.SAVE_ACTION:
        setState(() {
          _noteNotifier.note = null;
        });
        _noteService.save(_noteNotifier.note);
        break;
      case ActionConstants.MARK_ACTION:
       setState(() {
          _noteNotifier.note.isStarred = true;
        });
        _noteService.save(_noteNotifier.note);
        break;
      case ActionConstants.UNMARK_ACTION:
        setState(() {
          _noteNotifier.note.isStarred = false;
        });
        _noteService.save(_noteNotifier.note);
        break;
    }
  }
}