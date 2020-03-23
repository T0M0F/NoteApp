
import 'package:boostnote_mobile/business_logic/model/Folder.dart';
import 'package:boostnote_mobile/presentation/widgets/folderlist/FolderListTile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FolderList extends StatefulWidget {

  final List<Folder> folders;
  final Function(Folder) onRowTap;
  final Function(Folder) onRowLongPress;

  FolderList({@required this.folders, @required this.onRowTap, this.onRowLongPress}); //TODO: constructor
  
  @override
  State<StatefulWidget> createState() => _FolderListState();

}

class _FolderListState extends State<FolderList> {
 
  @override
  Widget build(BuildContext context) {
    print('rebuild');
    this.widget.folders.forEach((f)=> print('name ' + f.name));
    return ListView.builder(
    itemCount: this.widget.folders.length,
    itemBuilder: (context, index) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => this.widget.onRowTap(this.widget.folders[index]),
        onLongPress: () => this.widget.onRowLongPress(this.widget.folders[index]),
        child: FolderListTile(folder: this.widget.folders[index])
      );
    },
  );
  }
  

}
