
import 'package:boostnote_mobile/data/model/Note.dart';
import 'package:boostnote_mobile/ui/screens/NoteList/NoteTile.dart';
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
          child: new NoteTile(note: data[int]),
        );
      },
    );
  }
}