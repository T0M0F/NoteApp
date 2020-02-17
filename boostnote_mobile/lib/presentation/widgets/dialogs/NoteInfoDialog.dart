import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NoteInfoDialog extends StatelessWidget {  

  final Note note;

  const NoteInfoDialog(this.note);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _buildTitle(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return _buildContent();
        },
      ),
      actions: _buildActions(context),
    );
  }

  Widget _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container( 
              alignment: Alignment.center,
              child: Text(note.title, style: TextStyle(color: Colors.black))
            ),
            Padding(
              padding: EdgeInsets.only(left: 5, top: 3),
              child:  Icon(Icons.info_outline)
            )
          ],
        )
      ],
    );
  }


  Widget _buildContent() {
     return SingleChildScrollView(
       child: Container(
       height: 260,
       child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Updated at', style: TextStyle(color: Colors.grey)),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child:  Align(
              alignment: Alignment.centerLeft,
              child:  Text(note.updatedAt.toString()),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child:  Text('Created at', style: TextStyle(color: Colors.grey)),
          ),
           Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(note.createdAt.toString()),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Id', style: TextStyle(color: Colors.grey)),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(note.id.toString()),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Folder', style: TextStyle(color: Colors.grey)),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(note.folder.name),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Starred', style: TextStyle(color: Colors.grey)),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(note.isStarred ? 'Yes' : 'No'),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Trashed', style: TextStyle(color: Colors.grey)),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(note.isTrashed ? 'Yes' : 'No'),
            ),
          ),
        ],
      )
     )
    );
  }


  List<Widget> _buildActions(BuildContext context) {
    return <Widget>[
      MaterialButton(
        minWidth:100,
        child: Text('Close', style: TextStyle(color: Colors.black),),
        onPressed: (){
          Navigator.of(context).pop();
        }
      ),
    ];
  }

}
