import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteOverviewNotifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class TagOverviewAppbar extends StatelessWidget implements PreferredSizeWidget{

  final Function() onCreateTagCallback;
  final Function() openDrawer;

  TagOverviewAppbar({this.onCreateTagCallback, this.openDrawer});

  @override
  Widget build(BuildContext context) {
     return AppBar(
      title: Text(AppLocalizations.of(context).translate('tags'), style: Theme.of(context).accentTextTheme.title),
      leading: IconButton(
        icon: Icon(Icons.menu, color: Theme.of(context).accentColor),
        onPressed: openDrawer,
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(MdiIcons.tagPlusOutline, color: Theme.of(context).buttonColor), 
          onPressed: onCreateTagCallback,
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  
}