import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TagOverviewBottomSheet extends StatelessWidget {

  final Function() removeTagCallback;
  final Function() renameTagCallback;

  TagOverviewBottomSheet({this.removeTagCallback, this.renameTagCallback});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: <Widget>[
            new ListTile(
              leading: new Icon(Icons.delete),
              title: new Text('Remove Tag'),
              onTap: removeTagCallback     
            ),
            new ListTile(
              leading: new Icon(Icons.folder),
              title: new Text('Rename Tag'),
              onTap: renameTagCallback    
            ),
        ],
      ),
    );
  }

}
