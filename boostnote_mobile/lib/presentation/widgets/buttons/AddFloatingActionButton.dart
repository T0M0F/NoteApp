
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddFloatingActionButton extends StatelessWidget {

  final Function() onPressed;

  AddFloatingActionButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      child: FittedBox(
        child: FloatingActionButton(
          child: Icon(Icons.add, color: Theme.of(context).primaryIconTheme.color, size: 35),
          onPressed: onPressed,
        )
      )
    );
  }

}