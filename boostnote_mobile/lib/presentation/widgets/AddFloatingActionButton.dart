
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddFloatingActionButton extends StatelessWidget {

  final Function() onPressed;

  AddFloatingActionButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add, color: Color(0xFFF6F5F5)),
      onPressed: onPressed,
    );
  }

}