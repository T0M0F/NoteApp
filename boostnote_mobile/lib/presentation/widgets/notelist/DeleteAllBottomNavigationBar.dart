import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeleteAllBottomNavigationBar extends StatelessWidget {

  final Function() deleteAllCallback;

  DeleteAllBottomNavigationBar({this.deleteAllCallback});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.redAccent,
      padding: EdgeInsets.symmetric(vertical: 5),
      child: MaterialButton(
        onPressed: deleteAllCallback,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Icon(Icons.delete, color: Colors.white)
                ),
                Text(
                  'Delete All',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                )
              ],
            ) 
          ],
        )
      )
    );
  }

}





