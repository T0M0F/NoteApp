import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateFolderDialog extends StatefulWidget {

  final Function(String folderName) saveCallback;
  final Function() cancelCallback;

  const CreateFolderDialog({Key key, @required this.saveCallback, @required this.cancelCallback}) : super(key: key); //TODO: Constructor

  @override
  _CreateNoteDialogState createState() => _CreateNoteDialogState();
}

class _CreateNoteDialogState extends State<CreateFolderDialog> {

  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Container( 
        alignment: Alignment.center,
        child: Text('Create a Folder', style: TextStyle(color: Colors.black))
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: 100,
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _textEditingController,
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
          elevation: 5.0,
          color: Color(0xFFF6F5F5),
          child: Text('Cancel', style: TextStyle(color: Colors.black),),
          onPressed: (){
            this.widget.cancelCallback();
          }
        ),
        MaterialButton(
          minWidth:100,
          elevation: 5.0,
          color: Theme.of(context).accentColor,
          child: Text('Save', style: TextStyle(color: Color(0xFFF6F5F5))),
          onPressed: () {
            this.widget.saveCallback(_textEditingController.text);
          }
        )
      ],
    );
  }
}