import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
  }

  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 6), onDoneLoading);
  }

  onDoneLoading() async {
    print('Done');
    Navigator.pushNamed(context, '/abc');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Text('KJHASFKJHSFKHAFHSAFKJHASKFHK'),
    );
  }
}