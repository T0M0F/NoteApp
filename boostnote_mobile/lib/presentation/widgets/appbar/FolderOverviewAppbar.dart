import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteOverviewNotifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FolderOverviewAppbar extends StatelessWidget implements PreferredSizeWidget{

  final Function() onCreateFolderCallback;

  FolderOverviewAppbar({this.onCreateFolderCallback});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(AppLocalizations.of(context).translate('folders'), style: Theme.of(context).accentTextTheme.title),
      leading: IconButton(
        icon: Icon(Icons.menu, color: Theme.of(context).accentColor),
        onPressed: () => GlobalKey<ScaffoldState>().currentState.openDrawer(),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.create_new_folder, color: Theme.of(context).buttonColor),
          onPressed: onCreateFolderCallback,
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}