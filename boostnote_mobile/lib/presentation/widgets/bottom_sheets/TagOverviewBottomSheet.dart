import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TagOverviewBottomSheet extends StatelessWidget {

  final Function() removeTagCallback;
  final Function() renameTagCallback;

  TagOverviewBottomSheet({this.removeTagCallback, this.renameTagCallback});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: <Widget>[
            new ListTile(
              leading: Icon(Icons.delete),
              title: Text(AppLocalizations.of(context).translate('remove_tag')),
              onTap: removeTagCallback     
            ),
            new ListTile(
              leading: new Icon(Icons.folder),
              title: new Text(AppLocalizations.of(context).translate('rename_tag')),
              onTap: renameTagCallback    
            ),
        ],
      ),
    );
  }

}
