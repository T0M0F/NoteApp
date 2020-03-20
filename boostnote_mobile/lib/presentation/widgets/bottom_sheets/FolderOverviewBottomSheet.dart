import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FolderOverviewBottomSheet extends StatelessWidget {

  final Function() removeFolderCallback;
  final Function() renameFolderCallback;

  FolderOverviewBottomSheet({this.removeFolderCallback, this.renameFolderCallback});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: <Widget>[
            ListTile(
              leading:  Icon(Icons.delete, color: Theme.of(context).primaryColorLight),
              title:  Text(AppLocalizations.of(context).translate('remove_folder'), style: Theme.of(context).textTheme.display1),
              onTap: removeFolderCallback
            ),
            ListTile(
              leading:  Icon(Icons.folder, color: Theme.of(context).primaryColorLight),
              title:  Text(AppLocalizations.of(context).translate('rename_folder'), style: Theme.of(context).textTheme.display1),
              onTap: renameFolderCallback
            ),
        ],
      ),
    );
  }

}