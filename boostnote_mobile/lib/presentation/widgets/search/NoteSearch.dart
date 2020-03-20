
import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:boostnote_mobile/presentation/widgets/search/SearchListTile.dart';
import 'package:flutter/material.dart';

class NoteSearch extends SearchDelegate {

  final List<Note> notes;
  final ValueChanged<Note> itemSelectedCallback;

  NoteSearch({this.notes, this.itemSelectedCallback, searchFieldLabel}) : super(searchFieldLabel: searchFieldLabel);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear, color: Theme.of(context).primaryColorLight),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryColorLight),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) => _buildStreamBuilder(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildStreamBuilder(context);
  

  Widget _buildStreamBuilder(BuildContext context) {
    List<Note> results = List();

    if(notes.isEmpty){
      return Center(
        child: Text(AppLocalizations.of(context).translate('no_data') , style: TextStyle(fontSize: 18, color: Theme.of(context).textTheme.display1.color)),
      );
    } else {
      results = notes.where((note){
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
      children: results.map<SearchListTile>((note) => 
        SearchListTile(note: note, onTapCallback: (Note note) {
          close(context, results);
          itemSelectedCallback(note);
        })
      ).toList()  
    );
  }


}
