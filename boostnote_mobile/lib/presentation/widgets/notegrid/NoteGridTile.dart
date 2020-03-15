import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:boostnote_mobile/presentation/converter/DateTimeConverter.dart';
import 'package:boostnote_mobile/presentation/converter/TagListConverter.dart';
import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoteGridTile extends StatelessWidget {

  final TagListConverter _tagListConverter = TagListConverter();
  final DateTimeConverter _dateTimeConverter = DateTimeConverter();

  final Note note;
  bool expanded;

  NoteGridTile({this.note, this.expanded});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets;

    if(expanded) {
      widgets = <Widget>[
        _buildHeaderRow(),
        _buildBody(context),
        _buildFooterRow1(context),
        _buildFooterRow2()
      ];
    } else {
      widgets = <Widget>[
        _buildHeaderRow(),
        _buildBody(context),
        _buildFooterRow2()
      ];
    }  

    return Padding(
      padding: EdgeInsets.only(left: 5, right: 5, top: 8, bottom: 0),
      child: Column(
        children: widgets
      )
    );
  }

  Widget _buildHeaderRow() {

    List<Widget> widgets = [
      Row(
        children: <Widget>[
          Icon(note is MarkdownNote ? Icons.description : Icons.code, color: Colors.grey),
          Padding(
            padding: EdgeInsets.only(left: 5),
            child: Text(
              note.title, 
              maxLines: 1,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            )
          )
        ],
      )
    ];

    if(note.isStarred && expanded) {
      widgets.add( Icon(Icons.star, color: Colors.yellow));
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: widgets
        )
    ); 
  }

  Widget _buildBody(BuildContext context) {
    Widget widget;

    if(note is SnippetNote) {
      SnippetNote snippetNote = note;
      if(snippetNote.description.trim().isNotEmpty) {
         widget = Text(
            snippetNote.description,
            maxLines: 3,
          );
      } else if(snippetNote.codeSnippets.isNotEmpty) {
        widget = Text(
            snippetNote.codeSnippets.first.content,
            maxLines: 3,
          );
      } else {
        widget = Text('\n' + AppLocalizations.of(context).translate('no_data') + '\n', style:  TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic));
      }

    } else {
      MarkdownNote markdownNote = note;
      if(markdownNote.content.trim().isEmpty) {
        widget = Text('\n' + AppLocalizations.of(context).translate('no_data') + '\n', style:  TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic));
      } else {
        widget = Text(
            markdownNote.content,
            maxLines: 3,
        );
      }
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: widget
      )
    ); 

  }

  Widget _buildFooterRow1(BuildContext context) {
    if(note.tags.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.only(bottom: 5),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
                _tagListConverter.convert(note.tags), 
                maxLines: 1,
                style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic, color: Colors.grey),
                overflow: TextOverflow.ellipsis,
              )
        )
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(bottom: 5),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(AppLocalizations.of(context).translate('no_tags'), style:  TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic, color: Colors.grey)),
        )
      );
    }
  }

  Widget _buildFooterRow2() {
  
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Text(_dateTimeConverter.convertToReadableForm(note.updatedAt), style: TextStyle(fontSize: 15.0, color: Colors.grey))
      )
    );
  }

}