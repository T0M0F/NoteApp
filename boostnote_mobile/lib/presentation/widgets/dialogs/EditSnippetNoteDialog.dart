import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EditSnippetNoteDialog extends StatefulWidget {

  final TextEditingController textEditingController;
  final SnippetNote note;
  final Function(SnippetNote) onNoteChanged;

  const EditSnippetNoteDialog({Key key, this.textEditingController, this.note, this.onNoteChanged}) : super(key: key); //TODO Constructor

  @override
  _EditSnippetNoteDialogState createState() => _EditSnippetNoteDialogState();
}

class _EditSnippetNoteDialogState extends State<EditSnippetNoteDialog> {
  
  @override
  Widget build(BuildContext context) {

    this.widget.textEditingController.text = this.widget.note.title;

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

  Container _buildTitle() {
    return Container( 
      alignment: Alignment.center,
      child: Text('Edit Note', style: TextStyle(color: Colors.black))
    );
  }

  Container _buildContent() {
    return Container(
      height: 75,
      child: Column(
        children: <Widget>[
          TextField(
            controller: widget.textEditingController,
            style: TextStyle(color: Colors.black),
          ), 
        ],
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return <Widget>[
    MaterialButton(
        minWidth:100,
        child: Text('Cancel', style: TextStyle(color: Colors.black),),
        onPressed: (){
          Navigator.of(context).pop();
        }
      ),
      MaterialButton(
        minWidth:100,
        elevation: 5.0,
        color: Theme.of(context).accentColor,
        child: Text('Save', style: TextStyle(color: Color(0xFFF6F5F5))),
        onPressed: (){
          if(this.widget.textEditingController.text.trim().length > 0){
            this.widget.note.title = this.widget.textEditingController.text;
            this.widget.onNoteChanged(widget.note); 
          }
        }
      )
    ];
  }
}