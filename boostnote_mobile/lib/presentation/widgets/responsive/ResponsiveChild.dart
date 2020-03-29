import 'package:flutter/widgets.dart';

class ResponsiveChild extends StatefulWidget{

  final int smallFlex;
  final int largeFlex;
  final Widget child;

  ResponsiveChild({ @required this.smallFlex, @required this.largeFlex, @required this.child});

  @override
  _ResponsiveChildState createState() => _ResponsiveChildState();
}

class _ResponsiveChildState extends State<ResponsiveChild> {
  @override
  Widget build(BuildContext context) {
    return this.widget.child;
  }
}