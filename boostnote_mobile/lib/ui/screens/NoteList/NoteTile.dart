
import 'package:boostnote_mobile/data/model/MarkdownNote.dart';
import 'package:boostnote_mobile/data/model/Note.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoteTile extends StatelessWidget{
  
  Note note;
  NoteTile({this.note});

  @override
  Widget build(BuildContext context) => _buildItem(context);

  Widget _buildItem(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      child: Column(
        children: <Widget>[
        buildHeaderRow(),
        buildBodyRow(),
        buildFooterRow()
        ],
      ),
    );
  }

  Widget buildHeaderRow() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Row(
        children: <Widget>[
          note is MarkdownNote ? Icon(Icons.note) : Icon(Icons.code),
          Text(note.title, style: TextStyle(fontSize: 28.0)),
        ],
      ),
      Text('17:07', style: TextStyle(fontSize: 18.0))
    ],
  );

  Widget buildBodyRow() => Text(
    'Lorem ispsum dolor sit amet consectetur adioiscing elit morbi dictum euismod...', 
    style: TextStyle(fontSize: 20.0)
  );

  Widget buildFooterRow() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Text('#Welcome #Boostnote #Mobile', style: TextStyle(fontSize: 18.0, fontStyle: FontStyle.italic)),
      Icon(Icons.star)
    ],
  );
}

