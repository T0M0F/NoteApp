
import 'package:boostnote_mobile/business_logic/model/Folder.dart';
import 'package:boostnote_mobile/presentation/widgets/folderlist/FolderListTile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FolderList extends StatefulWidget {

  final List<Folder> folders;
  final Function(Folder) rowSelectedCallback;

  FolderList({@required this.folders, @required this.rowSelectedCallback}); //TODO: constructor
  
  @override
  State<StatefulWidget> createState() => _FolderListState();

}

class _FolderListState extends State<FolderList> {

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
    itemCount: this.widget.folders.length,
    itemBuilder: (context, index) {
      return GestureDetector(
        onTap: () => this.widget.rowSelectedCallback(this.widget.folders[index]),
        child: FolderListTile(folder: this.widget.folders[index])
      );
    },
  );
  }
  

}
