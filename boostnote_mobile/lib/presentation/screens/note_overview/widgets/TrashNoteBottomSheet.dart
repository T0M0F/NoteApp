import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TrashNoteBottomSheet extends StatelessWidget {

  final Function() trashNoteCallback;

  TrashNoteBottomSheet({@required this.trashNoteCallback});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: <Widget>[
            new ListTile(
              leading: Icon(Icons.delete),
              title: Text(AppLocalizations.of(context).translate('trash'), style: Theme.of(context).textTheme.display1,),
              onTap: trashNoteCallback     
            ),
        ],
      ),
    );
  }
}

