
import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/presentation/screens/markdown_editor/MarkdownEditor.dart';
import 'package:boostnote_mobile/presentation/screens/overview/OverviewView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'MarkdownPreview.dart';

class Editor extends StatefulWidget {

  final OverviewView _overview;
  final bool _isTablet;
  final MarkdownNote _note;

  Editor(this._isTablet, this._note, this._overview);

  @override
  State<StatefulWidget> createState() => EditorState();
}
  

class EditorState extends State<Editor> {

  bool _previewMode = false;

  void _selectedAction(String action){
      NoteService noteService = NoteService();
      print(action);
      print(action == 'Delete');
      if(action == 'Delete'){
        noteService.delete(this.widget._note);
        this.widget._overview.refresh();
        Navigator.of(context).pop();
      } else if(action == 'Save'){
        noteService.save(this.widget._note);
        this.widget._overview.refresh();
        Navigator.of(context).pop();
      }  else if(action == 'Edit Note'){
        showEditNoteDialog(context, this.widget._note, (note){
          setState(() {
            this.widget._note.title = note.title;
          });
          noteService.save(this.widget._note);
          Navigator.of(context).pop();
        });
      }
  }

  @override
  Widget build(BuildContext context) {

    Widget body;
    if (this.widget._isTablet) {
      body = _buildTabletLayout();
    } else {
      body = _buildMobileLayout();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget._note.title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFFF6F5F5)), 
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          Switch(
            value: _previewMode, 
            onChanged: (bool value) {
              setState(() {
                _previewMode = value;
              });
            }, 
            ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            onSelected: _selectedAction,
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                PopupMenuItem(
                  value: 'Save',
                  child: ListTile(
                    title: Text('Save')
                  )
                ),
                PopupMenuItem(
                  value: 'Delete',
                  child: ListTile(
                    title: Text('Delete')
                  )
                ),
                PopupMenuItem(
                  value: 'Edit Note',
                  child: ListTile(
                    title: Text('Edit Note')
                  )
                )
              ];
            }
          )
        ],
      ),
      body: body,
    );
  }

  Widget _buildMobileLayout() {
    return _previewMode ? MarkdownPreview(this.widget._note.content) : MarkdownEditor(this.widget._note.content, callback);
  }

  Widget _buildTabletLayout() {
    return Column(
      children: <Widget>[
        Flexible(
          flex: 1,
          child: MarkdownEditor(this.widget._note.content, callback)
        ),
        Divider(),
        Flexible(
          flex: 1,
          child: MarkdownPreview(this.widget._note.content)
        ),
      ],
    );
  }

  void callback(String text){
      this.widget._note.content = text;
  }

  Future<MarkdownNote> showEditNoteDialog(BuildContext context, MarkdownNote note, Function(MarkdownNote) callback){
     TextEditingController controller = TextEditingController();
     controller.text = note.title;
  
      return showDialog(context: context, 
        builder: (context){
          return AlertDialog(
            title: Container( 
              alignment: Alignment.center,
              child: Text('Edit Note', style: TextStyle(color: Colors.black))
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  height: 75,
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
                  if(controller.text.trim().length > 0){
                    note.title = controller.text;
                    callback(note); 
                  }
                }
              )
            ],
          );
      });
  }
}



 
