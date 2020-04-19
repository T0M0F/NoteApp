import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TagsPageAppbar extends StatelessWidget implements PreferredSizeWidget{

  @override
  Widget build(BuildContext context) {
     return AppBar(
      title: Text(AppLocalizations.of(context).translate('tags'), style: Theme.of(context).accentTextTheme.title),
      leading: IconButton(
        icon: Icon(Icons.menu, color: Theme.of(context).accentColor),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        }
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

}