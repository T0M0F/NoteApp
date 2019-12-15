
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
      } else if(action == 'Save'){
        noteService.save(this.widget._note);
      } 
      this.widget._overview.refresh();
      Navigator.of(context).pop();
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
}



 
