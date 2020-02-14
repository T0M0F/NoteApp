import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FolderOverviewAppbar extends StatelessWidget implements PreferredSizeWidget{

  final Function() onMenuClickCallback;
  final Function() onCreateFolderCallback;

  FolderOverviewAppbar({this.onCreateFolderCallback, this.onMenuClickCallback});

  @override
  Widget build(BuildContext context) {
     return AppBar(
      title: Text('Folders'),
      leading: IconButton(
        icon: Icon(Icons.menu, color: Theme.of(context).accentColor),
        onPressed: onMenuClickCallback,
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.create_new_folder),
          onPressed: onCreateFolderCallback,
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}