import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OverviewEditModeAppbar extends StatefulWidget implements PreferredSizeWidget{

  final Function() onMenuClickCallback;
  final Function() onCancelClickCallback;
  String titleEditMode;
  bool isEditMode;

  OverviewEditModeAppbar({this.titleEditMode, this.isEditMode, this.onCancelClickCallback, this.onMenuClickCallback});

  @override
  _OverviewEditModeAppbarState createState() => _OverviewEditModeAppbarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _OverviewEditModeAppbarState extends State<OverviewEditModeAppbar> {
  
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(this.widget.titleEditMode),
      leading: this.widget.isEditMode ? null : IconButton(
        icon: Icon(Icons.menu, color: Theme.of(context).accentColor), 
        onPressed: this.widget.onMenuClickCallback
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.cancel),
          onPressed: this.widget.onCancelClickCallback,
        )
      ],
    );
  }

}