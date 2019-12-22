
import 'dart:collection';

import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'MarkdownTile.dart';
import 'SnippetTile.dart';

class NoteList extends StatefulWidget {

  final List<Note> notes;
  final ValueChanged<List<Note>> itemSelectedCallback;
  final bool edit;
  final bool expanded;
  final List<Note> _selectedNotes = List();

  NoteList({@required this.notes,@required  this.edit, @required this.itemSelectedCallback, this.expanded});

  void clearSelectedElements(){
    _selectedNotes.clear();
  }

  @override
  State<StatefulWidget> createState() => _NoteListState(notes, itemSelectedCallback);

}

 class _NoteListState extends State<NoteList>{

  final List<Note> notes;
  final ValueChanged<List<Note>> itemSelectedCallback;
  
   
  _NoteListState(this.notes, this.itemSelectedCallback);

  @override
  Widget build(BuildContext context) => _buildList(context);
  
  Widget _buildList(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, int) {
        return GestureDetector(
          onTap: () => itemSelectedCallback([notes[int]]),
          child:  this.widget.edit ? 
          Row (
            children: <Widget>[
              Flexible(
                flex: 5,
                child: _buildTile(notes[int])
              ),
              Flexible(
                flex: 1,
                child: Checkbox(
                  value: this.widget._selectedNotes.contains(notes[int]), 
                  onChanged: (bool selected) {
                    NoteList widget = this.widget;
                    setState(() {
                      selected ? widget._selectedNotes.add(notes[int]) : widget._selectedNotes.remove(notes[int]);
                      itemSelectedCallback(widget._selectedNotes);
                    });
                  },
                )
              )
            ],
          ) : _buildTile(notes[int])
        );
      },
    );
  }

  Widget _buildTile(Note note){
    return note is MarkdownNote ? MarkdownTile(note: note, expanded: this.widget.expanded) : SnippetTile(note: note, expanded: this.widget.expanded);
  }
}

