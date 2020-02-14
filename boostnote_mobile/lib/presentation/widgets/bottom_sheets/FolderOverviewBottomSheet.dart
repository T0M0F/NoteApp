import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FolderOverviewBottomSheet extends StatelessWidget {

  final Function() removeFolderCallback;
  final Function() renameFolderCallback;

  FolderOverviewBottomSheet({this.removeFolderCallback, this.renameFolderCallback});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: <Widget>[
            ListTile(
              leading:  Icon(Icons.delete),
              title:  Text('Remove Folder'),
              onTap: removeFolderCallback
            ),
            ListTile(
              leading:  Icon(Icons.folder),
              title:  Text('Rename Folder'),
              onTap: renameFolderCallback
            ),
        ],
      ),
    );
  }

}