import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'MarkdownTile.dart';
import 'SnippetTile.dart';

class NoteList extends StatefulWidget {

  final List<Note> notes;
  final Function(List<Note>) rowSelectedCallback;
  final bool editMode;
  final bool expandedMode;
  final List<Note> selectedNotes;

  NoteList({@required this.notes,@required  this.editMode, @required this.rowSelectedCallback, @required this.expandedMode, @required this.selectedNotes}); //TODO: constructor

  void clearSelectedElements() => selectedNotes.clear(); //TODO: unelegant??
  
  @override
  State<StatefulWidget> createState() => _NoteListState();

}

 class _NoteListState extends State<NoteList>{

  @override
  Widget build(BuildContext context) => _buildList(context);
  
  Widget _buildList(BuildContext context) => ListView.builder(
    itemCount: this.widget.notes.length,
    itemBuilder: (context, int) {
      return GestureDetector(
        onTap: () => this.widget.rowSelectedCallback([this.widget.notes[int]]),
        child: _buildBody(int)
      );
    },
  );

  Widget _buildBody(int int) {
    if (this.widget.editMode) {
      return Row (
        children: <Widget>[
          Flexible(
            flex: 5,
            child: _buildTile(this.widget.notes[int])
          ),
          Flexible(
            flex: 1,
            child: Checkbox(
              value: this.widget.selectedNotes.contains(this.widget.notes[int]), 
              onChanged: (bool selected) {
                NoteList widget = this.widget;
                setState(() {
                  selected ? widget.selectedNotes.add(this.widget.notes[int]) : widget.selectedNotes.remove(this.widget.notes[int]);
                });
                this.widget.rowSelectedCallback(widget.selectedNotes);
              },
            )
          )
        ],
      );
    } else {
      return _buildTile(this.widget.notes[int]);
    }
  }

  Widget _buildTile(Note note) => note is MarkdownNote ? MarkdownTile(note: note, expanded: this.widget.expandedMode) : SnippetTile(note: note, expanded: this.widget.expandedMode);
}

