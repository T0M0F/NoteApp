import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CreateNoteFloatingActionButton extends StatelessWidget {

  final Function() onPressed;

  CreateNoteFloatingActionButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      child: FittedBox(
        child: FloatingActionButton(
          child: Icon(MdiIcons.pencil, color: Theme.of(context).primaryIconTheme.color, size: 30),
          onPressed: onPressed,
        )
      )
    );
  }

}