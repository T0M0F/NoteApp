import 'package:boostnote_mobile/presentation/widgets/appbar/FolderOverviewAppbar.dart';
import 'package:boostnote_mobile/presentation/widgets/appbar/TagOverviewAppbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppbar extends StatefulWidget implements PreferredSizeWidget{

  @override
  _CustomAppbarState createState() => _CustomAppbarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CustomAppbarState extends State<CustomAppbar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Flexible(
          flex: 1,
          child: IconButton(icon: Icon(Icons.folder), onPressed: null)
        ),
        Flexible(
          flex: 1,
          child:  IconButton(icon: Icon(Icons.folder), onPressed: null)
        ),
        Flexible(
          flex: 1,
          child:  IconButton(icon: Icon(Icons.folder), onPressed: null)
        )
      ],
    );
  }
}