
import 'dart:collection';

import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:flutter/material.dart';

class NoteSearch extends SearchDelegate {

  final List<Note> _notes;
  final ValueChanged<Note> _itemSelectedCallback;

  NoteSearch(this._notes, this._itemSelectedCallback) : super(searchFieldLabel: 'Search');

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
    return _buildStreamBuilder(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildStreamBuilder(context);
  }

  Widget _buildStreamBuilder(BuildContext context) {
    List<Note> results = List();

    if(_notes.isEmpty){
      return Center(
        child: Text('No data', style: TextStyle(fontSize: 18)),
      );
    } else {
      results = _notes.where((note){
        if(note is MarkdownNote){
          return note.title.toLowerCase().contains(query.toLowerCase()) || 
          note.content.toLowerCase().contains(query.toLowerCase()) || 
          note.tags.any((tag){
              return tag.toLowerCase().contains(query.toLowerCase());
          });
        } else if(note is SnippetNote){
          return note.title.toLowerCase().contains(query.toLowerCase()) ||
          note.codeSnippets.any((codeSnippet){
            return codeSnippet.name.toLowerCase().contains(query.toLowerCase()) ||
            codeSnippet.content.toLowerCase().contains(query.toLowerCase());
          }) || 
          note.tags.any((tag){
            return tag.toLowerCase().contains(query.toLowerCase());
          });
        }
        return false;
      }).toList();
    }
    
    return ListView(
      children: results.map<ListTile>((note) => ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        title: Text(note.title,
          maxLines: 1,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
        subtitle: Text(
          _getSubtitle(note),
          maxLines: 2,
          style: TextStyle(fontSize: 16.0, color: Colors.black)),
        onTap: () {
          close(context, results);
          _itemSelectedCallback(note);
        },
      )).toList()  
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

  String _getSubtitle(Note note) {
    if(note is MarkdownNote){
      return note.content;
    } else if (note is SnippetNote){
      return note.description;
    }
    return "";
  }

}