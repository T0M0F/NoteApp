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
              leading: Icon(Icons.delete, color: Theme.of(context).primaryColorLight),
              title: Text(AppLocalizations.of(context).translate('remove_tag'), style: Theme.of(context).textTheme.display1),
              onTap: removeTagCallback     
            ),
            new ListTile(
              leading: new Icon(Icons.label, color: Theme.of(context).primaryColorLight),
              title: new Text(AppLocalizations.of(context).translate('rename_tag'), style: Theme.of(context).textTheme.display1),
              onTap: renameTagCallback    
            ),
        ],
      ),
    );
  }

}
