import 'package:boostnote_mobile/business_logic/model/Folder.dart';
import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateNoteDialog extends StatefulWidget {

  //TODO CONTINUE HERE

  static const int _MARKDOWNNOTE = 1;
  static const int _SNIPPETNOTE = 2;

  final Function(Note note) saveCallback;
  final Function() cancelCallback;

  const CreateNoteDialog({Key key, @required this.saveCallback, @required this.cancelCallback}) : super(key: key); //TODO: Constructor

  @override
  _CreateNoteDialogState createState() => _CreateNoteDialogState();
}

class _CreateNoteDialogState extends State<CreateNoteDialog> {
  final TextEditingController controller = TextEditingController();

  int groupvalue = CreateNoteDialog._MARKDOWNNOTE;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Container( 
        alignment: Alignment.center,
        child: Text('Make a Note', style: TextStyle(color: Colors.black))
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
                RadioListTile(
                  title: Text('Markdown Note'),
                  value: 1,
                  groupValue: groupvalue,
                  onChanged: (int value) {
                    setState(() {
                      groupvalue = CreateNoteDialog._MARKDOWNNOTE;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('Snippet Note'),
                  groupValue: groupvalue,
                  value: 2,
                  onChanged: (int value) {
                    setState(() {
                      groupvalue = CreateNoteDialog._SNIPPETNOTE;
                    });
                  },
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
            this.widget.cancelCallback();
          }
        ),
        MaterialButton(
          minWidth:100,
          elevation: 5.0,
          color: Theme.of(context).accentColor,
          child: Text('Save', style: TextStyle(color: Color(0xFFF6F5F5))),
          onPressed: _save
        )
      ],
    );
  }

  void _save(){
    if(controller.text.trim().length > 0){
      Note note;
      if(groupvalue == CreateNoteDialog._MARKDOWNNOTE){
        note = MarkdownNote(
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          folder: Folder(),
          title: controller.text.trim(),
          tags: [],
          isStarred: false,
          isTrashed: false,
          content: ''
        );
      } else {
        note = SnippetNote(
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          folder: Folder(),
          title: controller.text.trim(),
          tags: [],
          isStarred: false,
          isTrashed: false,
          description: '',
          codeSnippets: []
        );
      }
      this.widget.saveCallback(note);
    }
  }
}