import 'package:boostnote_mobile/presentation/screens/ActionConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OverflowButton extends StatefulWidget {

  final Function(String) selectedActionCallback;
  bool noteIsStarred;

  OverflowButton({this.selectedActionCallback, this.noteIsStarred});

  @override
  _OverflowButtonState createState() => _OverflowButtonState();
}

class _OverflowButtonState extends State<OverflowButton> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color:  Theme.of(context).buttonColor),
      onSelected: widget.selectedActionCallback,
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<String>>[
          PopupMenuItem(
            value: ActionConstants.SAVE_ACTION,
            child: ListTile(
              title: Text(ActionConstants.SAVE_ACTION, style: Theme.of(context).textTheme.display1)
            )
          ),
          /*
          PopupMenuItem(
            value: ActionConstants.DELETE_ACTION,
            child: ListTile(
              title: Text(ActionConstants.DELETE_ACTION, style: Theme.of(context).textTheme.display1)
            )
          ),*/
          PopupMenuItem(
            value: widget.noteIsStarred ?  ActionConstants.UNMARK_ACTION : ActionConstants.MARK_ACTION,
            child: ListTile(
              title: Text(widget.noteIsStarred ?  ActionConstants.UNMARK_ACTION : ActionConstants.MARK_ACTION, style: Theme.of(context).textTheme.display1)
            )
          )
        ];
      }
    );
  }
}