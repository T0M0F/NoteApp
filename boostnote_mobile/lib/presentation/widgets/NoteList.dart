
import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:flutter/cupertino.dart';

import 'MarkdownTile.dart';
import 'SnippetTile.dart';

class NoteList extends StatefulWidget {

  final List<Note> notes;
  final ValueChanged<Note> itemSelectedCallback;

  NoteList({this.notes, @required this.itemSelectedCallback});

  @override
  State<StatefulWidget> createState() => _NoteListState(notes, itemSelectedCallback);
}

 class _NoteListState extends State<NoteList>{

  final List<Note> notes;
  final ValueChanged<Note> itemSelectedCallback;
   
  _NoteListState(this.notes, this.itemSelectedCallback);

  @override
  Widget build(BuildContext context) => _buildList(context);
  
  Widget _buildList(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, int) {
        return GestureDetector(
          onTap: () => itemSelectedCallback(notes[int]),
          child: notes[int] is MarkdownNote ? MarkdownTile(note: notes[int]) : SnippetTile(note: notes[int]),  
        );
      },
    );
  }
}