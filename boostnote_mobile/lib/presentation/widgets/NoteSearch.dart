
import 'dart:collection';

import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:flutter/material.dart';

class NoteSearch extends SearchDelegate {

  final Stream<UnmodifiableListView<Note>> notes;
  final ValueChanged<Note> itemSelectedCallback;

  NoteSearch(this.notes, this.itemSelectedCallback) : super(searchFieldLabel: 'Search');

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildStreamBuilder();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildStreamBuilder();
  }

  StreamBuilder<UnmodifiableListView<Note>> _buildStreamBuilder() {
    return StreamBuilder<UnmodifiableListView<Note>>(
      stream: notes,
      builder: (context, AsyncSnapshot<UnmodifiableListView<Note>> snapshot) {
        if(!snapshot.hasData){
          return Center(
            child: Text('No data', style: TextStyle(fontSize: 18)),
          );
        } else {
          final results = snapshot.data.where((note) => note.title.toLowerCase().contains(query.toLowerCase()));
          return ListView(
            children: results.map<ListTile>((note) => ListTile(
              title: Text(note.title),
              onTap: () {
                close(context, results);
                itemSelectedCallback(note);
              },
            )).toList()  
          );
        }
      },
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
       textTheme: TextTheme(
            title:   TextStyle(color: Colors.white),
        ),
    );
  }

}