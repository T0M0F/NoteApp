import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/CreateFolderDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FolderOverviewAppbar extends StatelessWidget implements PreferredSizeWidget{

  final Function() openDrawer;

  FolderOverviewAppbar({this.openDrawer});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(AppLocalizations.of(context).translate('folders'), style: Theme.of(context).accentTextTheme.title),
      leading: IconButton(
        icon: Icon(Icons.menu, color: Theme.of(context).accentColor),
        onPressed: openDrawer,
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.create_new_folder, color: Theme.of(context).buttonColor),
          onPressed: () => _createFolderDialog(context),
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  void _createFolderDialog(BuildContext context) => showDialog(
    context: context,
    builder: (context) {
      return CreateFolderDialog();
  });
}