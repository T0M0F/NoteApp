import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TagOverviewAppbar extends StatelessWidget implements PreferredSizeWidget{

  final Function() openDrawer;

  TagOverviewAppbar({this.openDrawer});

  @override
  Widget build(BuildContext context) {
     return AppBar(
      title: Text(AppLocalizations.of(context).translate('tags'), style: Theme.of(context).accentTextTheme.title),
      leading: IconButton(
        icon: Icon(Icons.menu, color: Theme.of(context).accentColor),
        onPressed: openDrawer,
      ),
      /*
      actions: <Widget>[
        IconButton(
          icon: Icon(MdiIcons.tagPlusOutline, color: Theme.of(context).buttonColor), 
          onPressed: () => _showCreateTagDialog(context),
        )
      ],*/
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

}