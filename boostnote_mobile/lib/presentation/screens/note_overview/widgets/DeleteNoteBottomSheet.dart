import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeleteNoteBottomSheet extends StatelessWidget {

  final Function() deleteNoteCallback;
  final Function() restoreNoteCallback;

  DeleteNoteBottomSheet({@required this.deleteNoteCallback, @required this.restoreNoteCallback});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: <Widget>[
             ListTile(
              leading: Icon(Icons.delete),
              title: Text(AppLocalizations.of(context).translate('restore_note'), style: Theme.of(context).textTheme.display1,),
              onTap: restoreNoteCallback     
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.redAccent,),
              title: Text(AppLocalizations.of(context).translate('delete'), style: TextStyle(color: Colors.redAccent)),
              onTap: deleteNoteCallback     
            )
        ],
      ),
    );
  }
}

