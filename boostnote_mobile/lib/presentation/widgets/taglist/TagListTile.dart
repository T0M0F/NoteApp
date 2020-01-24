
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:flutter/material.dart';

class TagListTile extends StatefulWidget {
  
  final String tag;

  TagListTile({this.tag}); 

  @override
  _TagListTileState createState() => _TagListTileState();

}

class _TagListTileState extends State<TagListTile> {

  int _numberOfNotesWithTag = 0;

  NoteService _noteService;

  @override
  void initState(){
    super.initState();
    _noteService = NoteService();
    _noteService.findNotesByTag(widget.tag).then((notes) {
      setState(() {
        _numberOfNotesWithTag = notes.length;
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
            Icon(Icons.folder, color: Colors.grey),
            Padding(
              padding: EdgeInsets.only(left: 7),
              child: Text(
                this.widget.tag, 
                maxLines: 1,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
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
          _numberOfNotesWithTag.toString() + ' Notes', 
          maxLines: 2,
          style: TextStyle(fontSize: 16.0)
        )
      )
    )
  );

}
