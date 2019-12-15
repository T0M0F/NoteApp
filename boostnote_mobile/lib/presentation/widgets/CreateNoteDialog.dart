
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateNoteDialog extends StatefulWidget {

  final bool createMarkdowNote;
  final void Function(bool) onValueChange;

  const CreateNoteDialog({Key key, this.createMarkdowNote, this.onValueChange}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CreateNoteDialogState();
  
}
  
class CreateNoteDialogState extends State<CreateNoteDialog>{

  bool _createMarkdowNote;
  TextEditingController controller;

  @override
  void initState() {
    super.initState();
    _createMarkdowNote = widget.createMarkdowNote;
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) => 
   AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Container( 
        alignment: Alignment.center,
        child: Text('Make a Note', style: TextStyle(color: Colors.black))
      ),
      content: Container(
        height: 170,
        child: Column(
          children: <Widget>[
            TextField(
              controller: controller,
              style: TextStyle(color: Colors.black),
            ),
            RadioListTile(
              title: Text('Markdown Note'),
              value: _createMarkdowNote,
              groupValue: _createMarkdowNote,
              onChanged: (bool value){
                setState(() {
                    _createMarkdowNote = value;
                    widget.onValueChange(value);
                });
              },
            ),
            RadioListTile(
              title: Text('Snippet Note'),
              value: !_createMarkdowNote,
              groupValue: _createMarkdowNote,
              onChanged: (bool value){
                setState(() {
                    _createMarkdowNote = value;
                    widget.onValueChange(value);
                });
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        MaterialButton(
          minWidth:100,
          elevation: 5.0,
          color: Color(0xFFF6F5F5),
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
            
          }
        )
      ],
    );
}