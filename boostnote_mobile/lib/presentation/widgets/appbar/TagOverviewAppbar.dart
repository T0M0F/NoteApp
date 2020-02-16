import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TagOverviewAppbar extends StatelessWidget implements PreferredSizeWidget{

  final Function() onMenuClickCallback;
  final Function() onCreateTagCallback;

  TagOverviewAppbar({this.onCreateTagCallback, this.onMenuClickCallback});

  @override
  Widget build(BuildContext context) {
     return AppBar(
      title: Text('Tags'),
      leading: IconButton(
        icon: Icon(Icons.menu, color: Theme.of(context).accentColor),
        onPressed: onMenuClickCallback,
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.label_outline), 
          onPressed: onCreateTagCallback,
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  
}