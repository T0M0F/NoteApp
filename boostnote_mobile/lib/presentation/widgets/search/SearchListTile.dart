import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchListTile extends StatelessWidget {

  final Note note;
  final Function(Note note) onTapCallback;

  SearchListTile({this.note, this.onTapCallback});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      title: Text(
        note.title,
        maxLines: 1,
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)
      ),
      subtitle: Text(
        _getSubtitle(note, context),
        maxLines: 2,
        style: _getSubtitle(note,context) == AppLocalizations.of(context).translate('no_data')  ? TextStyle(fontSize: 16.0, color: Colors.black, fontStyle: FontStyle.italic) 
        : TextStyle(fontSize: 16.0, color: Colors.black),
      ),
      onTap: () => onTapCallback(note),
    );
  }
  
  String _getSubtitle(Note note, BuildContext context) {
    if(note is MarkdownNote){
      if(note.content.trim().isNotEmpty){
        return note.content;
      }
    } else if (note is SnippetNote){
      if(note.description.trim().isNotEmpty){
        return note.description;
      } else if (note.codeSnippets.isNotEmpty){
        return note.codeSnippets.first.content;
      }
    }
    return AppLocalizations.of(context).translate('no_data') ;
  }

}