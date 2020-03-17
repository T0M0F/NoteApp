
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
          child: Icon(Icons.add, color: Color(0xFFF6F5F5), size: 35),
          onPressed: onPressed,
        )
      )
    );
  }

}