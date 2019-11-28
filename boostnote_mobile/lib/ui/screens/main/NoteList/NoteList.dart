
import 'package:boostnote_mobile/data/model/MarkdownNote.dart';
import 'package:boostnote_mobile/data/model/Note.dart';
import 'package:boostnote_mobile/ui/screens/main/NoteList/MarkdownTile.dart';
import 'package:boostnote_mobile/ui/screens/main/NoteList/SnippetTile.dart';
import 'package:flutter/cupertino.dart';

class NoteList extends StatelessWidget {

  final List<Note> data;
  final ValueChanged<Note> itemSelectedCallback;

  NoteList({this.data, @required this.itemSelectedCallback});

  @override
  Widget build(BuildContext context) {
    return _buildList(context);
  }

  Widget _buildList(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, int) {
        return GestureDetector(
          onTap: () => itemSelectedCallback(data[int]),
          child: data[int] is MarkdownNote ? MarkdownTile(note: data[int]) : SnippetTile(note: data[int]),  //ugly
        );
      },
    );
  }
}