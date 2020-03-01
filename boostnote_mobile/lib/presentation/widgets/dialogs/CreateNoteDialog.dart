
import 'package:boostnote_mobile/data/internationalization%20%20%20%20/Translation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//TODO Delete???
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
        child: Text(Translation.of(context).text("make_a_note"), style: TextStyle(color: Colors.black))
      ),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: controller,
              style: TextStyle(color: Colors.black),
            ),
            RadioListTile(
              title: Text(Translation.of(context).text("markdown_note")),
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
              title: Text(Translation.of(context).text("snippet_note")),
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
          child: Text(Translation.of(context).text("cancel"), style: TextStyle(color: Colors.black),),
          onPressed: (){
            Navigator.of(context).pop();
          }
        ),
        MaterialButton(
          minWidth:100,
          elevation: 5.0,
          color: Theme.of(context).accentColor,
          child: Text(Translation.of(context).text("save"), style: TextStyle(color: Color(0xFFF6F5F5))),
          onPressed: (){
            
          }
        )
      ],
    );
}