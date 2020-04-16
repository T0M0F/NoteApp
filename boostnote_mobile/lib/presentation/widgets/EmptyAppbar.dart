import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmptyAppbar extends StatefulWidget  implements PreferredSizeWidget{

  @override
  _EmptyAppbarState createState() => _EmptyAppbarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _EmptyAppbarState extends State<EmptyAppbar> {

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Container(),
    );
  }
}