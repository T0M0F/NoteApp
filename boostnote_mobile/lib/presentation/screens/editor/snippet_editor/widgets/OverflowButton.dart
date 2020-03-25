import 'package:boostnote_mobile/presentation/screens/ActionConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OverflowButton extends StatefulWidget {

  final Function(String) selectedActionCallback;
  bool snippetSelected;
  bool noteIsStarred;

  OverflowButton({this.selectedActionCallback, this.noteIsStarred, this.snippetSelected});

  @override
  _OverflowButtonState createState() => _OverflowButtonState();
}

class _OverflowButtonState extends State<OverflowButton> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: Theme.of(context).buttonColor),
      onSelected: this.widget.selectedActionCallback,
      itemBuilder: (BuildContext context) {
        return _getWidgets();
      }
    );
  }

  List<PopupMenuEntry<String>> _getWidgets() {

    List<PopupMenuEntry<String>> widgets = <PopupMenuEntry<String>>[
      PopupMenuItem(
        value: ActionConstants.SAVE_ACTION,
        child: ListTile(
          title: Text(ActionConstants.SAVE_ACTION, style: Theme.of(context).textTheme.display1)
        )
      ),
      PopupMenuItem(
        value: this.widget.noteIsStarred ?  ActionConstants.UNMARK_ACTION : ActionConstants.MARK_ACTION,
        child: ListTile(
          title: Text(this.widget.noteIsStarred ?  ActionConstants.UNMARK_ACTION : ActionConstants.MARK_ACTION, style: Theme.of(context).textTheme.display1)
        )
      )
    ];

    if(this.widget.snippetSelected){
      List<PopupMenuEntry<String>> widgetsToInsert = [
        PopupMenuItem(
          value: ActionConstants.DELETE_CURRENT_SNIPPET,
          child: ListTile(
            title: Text(ActionConstants.DELETE_CURRENT_SNIPPET, style: Theme.of(context).textTheme.display1)
          )
        ),
        PopupMenuItem(
          value: ActionConstants.RENAME_CURRENT_SNIPPET,
          child: ListTile(
            title: Text(ActionConstants.RENAME_CURRENT_SNIPPET, style: Theme.of(context).textTheme.display1)
          )
        )
      ];
      widgets.insertAll(1, widgetsToInsert);
    }

    return widgets;
  }
}