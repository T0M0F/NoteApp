import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:flutter/material.dart';

class EditMarkdownNoteDialog extends StatelessWidget {    //TODO: Stateful Widget?

  final MarkdownNote note;
  final TextEditingController controller = TextEditingController();
  final Function(MarkdownNote note) saveCallback;
  final Function() cancelCallback;

  EditMarkdownNoteDialog({Key key, @required this.note, this.saveCallback, this.cancelCallback}) : super(key: key); //TODO: Constructor

  @override
  Widget build(BuildContext context) {
    controller.text = note.title;

    return AlertDialog(
      title: Container( 
        alignment: Alignment.center,
        child: Text('Edit Note', style: TextStyle(color: Colors.black))
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
           return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: controller,
                  style: TextStyle(color: Colors.black),
                ), 
              ],
            ),
          );
        },
      ),
      actions: <Widget>[
      MaterialButton(
          minWidth:100,
          child: Text('Cancel', style: TextStyle(color: Colors.black),),
          onPressed: (){
            cancelCallback();
          }
        ),
        MaterialButton(
          minWidth:100,
          elevation: 5.0,
          color: Theme.of(context).accentColor,
          child: Text('Save', style: TextStyle(color: Color(0xFFF6F5F5))),
          onPressed: (){
            if(controller.text.trim().length > 0){
              note.title = controller.text;
              saveCallback(note); 
            }
          }
        )
      ],
    );
  }
}