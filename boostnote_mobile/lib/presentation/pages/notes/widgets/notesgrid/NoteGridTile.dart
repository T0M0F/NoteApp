import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:boostnote_mobile/presentation/converter/DateTimeConverter.dart';
import 'package:boostnote_mobile/presentation/converter/TagListConverter.dart';
import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteOverviewNotifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NoteGridTile extends StatefulWidget {   

  final Note note;

  NoteGridTile({this.note});

  @override
  _NoteGridTileState createState() => _NoteGridTileState();
}

class _NoteGridTileState extends State<NoteGridTile> {

  TagListConverter _tagListConverter = TagListConverter();
  DateTimeConverter _dateTimeConverter = DateTimeConverter();
  NoteOverviewNotifier _noteOverviewNotifier;

  @override
  Widget build(BuildContext context) {
    _noteOverviewNotifier = Provider.of<NoteOverviewNotifier>(context);
    List<Widget> widgets;
    return _buildWidget(widgets, context);
  }

  Container _buildWidget(List<Widget> widgets, BuildContext context) {
      if(_noteOverviewNotifier.expandedTiles) {
      widgets = <Widget>[
        _buildHeaderRow(context),
        _buildBody(context),
        _buildFooterRow1(context),
        _buildFooterRow2(context)
      ];
    } else {
      widgets = <Widget>[
        _buildHeaderRow(context),
        _buildBody(context),
        _buildFooterRow2(context)
      ];
    }  
    
    return Container(
      color: Theme.of(context).dialogBackgroundColor,
      padding: EdgeInsets.only(left: 5, right: 5, top: 8, bottom: 0),
      child: Column(
        children: widgets
      )
    );
  }

  Widget _buildHeaderRow(BuildContext context) {

    List<Widget> widgets = [
      Row(
        children: <Widget>[
          Icon(widget.note is MarkdownNote ? Icons.description : Icons.code, color: Theme.of(context).indicatorColor),
          Padding(
            padding: EdgeInsets.only(left: 5),
            child: Text(
              widget.note.title, 
              maxLines: 1,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.display1.color),
            )
          )
        ],
      )
    ];

    if(widget.note.isStarred && _noteOverviewNotifier.expandedTiles) {
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

    if(this.widget.note is SnippetNote) {
      SnippetNote snippetNote = this.widget.note;
      if(snippetNote.description != null && snippetNote.description.trim().isNotEmpty) {
         widget = Text(
            snippetNote.description,
            maxLines: 3,
            style: Theme.of(context).textTheme.display1,
          );
      } else if(snippetNote.codeSnippets != null && snippetNote.codeSnippets.isNotEmpty) {
        bool contentNullorEmpyty = true;
        for(CodeSnippet snippet in snippetNote.codeSnippets) {
          if(snippet.content != null) {
            widget = Text(
              snippetNote.codeSnippets.first.content,
              maxLines: 3,
                style: Theme.of(context).textTheme.display1,
            );
            contentNullorEmpyty = false;
            break;
          }
        }
        if(contentNullorEmpyty) {
          widget = Text(
            '\n' + AppLocalizations.of(context).translate('no_data') + '\n', 
            style:  TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic, color: Theme.of(context).textTheme.display1.color)
          );  
        }
        
      } else {
        widget = Text(
          '\n' + AppLocalizations.of(context).translate('no_data') + '\n', 
          style:  TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic, color: Theme.of(context).textTheme.display1.color)
        );
      }

    } else {
      MarkdownNote markdownNote = this.widget.note;
      if(markdownNote.content == null || markdownNote.content.trim().isEmpty) {
        widget = Text(
          '\n' + AppLocalizations.of(context).translate('no_data') + '\n', 
          style:  TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic, color: Theme.of(context).textTheme.display1.color)
        );
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
    if(widget.note.tags.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.only(bottom: 5),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
                _tagListConverter.convert(widget.note.tags), 
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
          child: Text(
            AppLocalizations.of(context).translate('no_tags'), 
            style:  TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic, color: Theme.of(context).textTheme.display2.color)
          ),
        )
      );
    }
  }

  Widget _buildFooterRow2(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
          _dateTimeConverter.convertToReadableForm(widget.note.updatedAt), 
          style: TextStyle(fontSize: 15.0, color: Theme.of(context).textTheme.display2.color)
      )
    );
  }
}