
import 'package:boostnote_mobile/business_logic/model/Folder.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:flutter/material.dart';

class FolderListTile extends StatefulWidget {
  
  final Folder folder;

  FolderListTile({this.folder}); 

  @override
  _FolderListTileState createState() => _FolderListTileState();

}

class _FolderListTileState extends State<FolderListTile> {

  int _numberOfNotesInFolder = 0;

  NoteService _noteService;

  @override
  void initState(){
    super.initState();
    _noteService = NoteService();
    _noteService.findUntrashedNotesIn(widget.folder).then((notes) {
      setState(() {
        _numberOfNotesInFolder = notes.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      child: Column(
        children: <Widget>[
        buildHeaderRow(),
        buildBodyRow(),
        Divider(
          height: 1.0,
          thickness: 1,
        )
       ]
      ),
  );
  

  Widget buildHeaderRow() => Padding(
    padding: EdgeInsets.only(top: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(Icons.folder, color: Theme.of(context).indicatorColor),
            Padding(
              padding: EdgeInsets.only(left: 7),
              child: Text(
                this.widget.folder.name, 
                maxLines: 1,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.display1.color)),
            ),
          ]
        )
      ]
    )
  );

  Widget buildBodyRow() => Padding(
    padding:  EdgeInsets.only(top: 5, bottom: 15),
    child: Align(
      alignment: Alignment.bottomLeft,
      child:  Padding(
        padding: EdgeInsets.only(left: 30),
        child: Text(
          _numberOfNotesInFolder.toString() + ' Notes', 
          maxLines: 2,
          style: TextStyle(fontSize: 16.0, color: Theme.of(context).textTheme.display1.color)
        )
      )
    )
  );

}
