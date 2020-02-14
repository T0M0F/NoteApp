import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FolderOverviewErrorBottomSheet extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
   return Container(
      child: Wrap(
        children: <Widget>[
          ListTile(
              title:  Text(
                'Folder can\'t be changed', 
                style: TextStyle(color: Colors.red)
              )
          )
        ],
      ),
    );
  }
}
