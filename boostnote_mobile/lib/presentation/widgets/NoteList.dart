
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

  NoteList({@required this.notes,@required  this.edit, @required this.itemSelectedCallback, this.expanded});

  @override
  State<StatefulWidget> createState() => _NoteListState(notes, itemSelectedCallback);

}

 class _NoteListState extends State<NoteList>{

  final List<Note> notes;
  final ValueChanged<List<Note>> itemSelectedCallback;
  final List<Note> selectedNotes = List();
   
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
                  value: selectedNotes.contains(notes[int]), 
                  onChanged: (bool selected) {
                    setState(() {
                      selected ? selectedNotes.add(notes[int]) : selectedNotes.remove(notes[int]);
                      itemSelectedCallback(selectedNotes);
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

