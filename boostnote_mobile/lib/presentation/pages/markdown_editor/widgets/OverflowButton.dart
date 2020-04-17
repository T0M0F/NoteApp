import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteNotifier.dart';
import 'package:boostnote_mobile/presentation/widgets/ActionConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OverflowButton extends StatefulWidget {       

  final Function(String) selectedActionCallback;

  OverflowButton({this.selectedActionCallback});

  @override
  _OverflowButtonState createState() => _OverflowButtonState();
}

class _OverflowButtonState extends State<OverflowButton> {

  NoteNotifier _noteNotifier;
  @override
  Widget build(BuildContext context) {
    _noteNotifier = Provider.of<NoteNotifier>(context);
    return _buildWidget(context);
  }

  PopupMenuButton<String> _buildWidget(BuildContext context) {
     return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color:  Theme.of(context).buttonColor),
      onSelected: widget.selectedActionCallback,
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<String>>[
          PopupMenuItem(
            value: ActionConstants.SAVE_ACTION,
            child: ListTile(
              title: Text(AppLocalizations.of(context).translate('save'), style: Theme.of(context).textTheme.display1)
            )
          ),
          PopupMenuItem(
            value: _noteNotifier.note.isStarred ?  ActionConstants.UNMARK_ACTION : ActionConstants.MARK_ACTION,
            child: ListTile(
              title: Text( 
                _noteNotifier.note.isStarred 
                ? AppLocalizations.of(context).translate('unmark') 
                : AppLocalizations.of(context).translate('mark'), 
                style: Theme.of(context).textTheme.display1
              )
            )
          )
        ];
      }
    );
  }
}