import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/presentation/converter/DateTimeConverter.dart';
import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:boostnote_mobile/presentation/converter/TagListConverter.dart';
import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteOverviewNotifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NoteTile extends StatefulWidget{
  
  final Note note; 

  NoteTile({this.note});

  @override
  _NoteTileState createState() => _NoteTileState();
}

class _NoteTileState extends State<NoteTile> {

  DateTimeConverter _dateTimeConverter = DateTimeConverter(); 
  TagListConverter tagListConverter = TagListConverter();
  bool expandedAndNotEmpty;
  NoteOverviewNotifier _noteOverviewNotifier;

  @override
  Widget build(BuildContext context) {
    _noteOverviewNotifier = Provider.of<NoteOverviewNotifier>(context);
    return _buildWidget(context);
  }

  Padding _buildWidget(BuildContext context) {
    List<Widget> widgets;
    expandedAndNotEmpty = _noteOverviewNotifier.expandedTiles && (widget.note.isStarred || widget.note.tags.isNotEmpty);
    if (expandedAndNotEmpty) {
      widgets = <Widget>[
        buildHeaderRow(context),
        buildBodyRow(context),
        buildFooterRow(context),
        Divider(height: 0.5)
      ];
    } else {
      widgets = <Widget>[
        buildHeaderRow(context),
        buildBodyRow(context),
        Divider(height: 0.5)
      ];
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        children: widgets
      ),
    );
  }

  Widget buildHeaderRow(BuildContext context) => Padding(
    padding: EdgeInsets.only(top: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(
              widget.note is SnippetNote 
              ? Icons.code
              : Icons.description, 
              color: Theme.of(context).indicatorColor
            ),
            Padding(
              padding: EdgeInsets.only(left: 5),
              child:  Text(widget.note.title, 
                maxLines: 1,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.display1.color)),
            )
          ],
        ),
        Text(_dateTimeConverter.convertToReadableForm(widget.note.updatedAt), style: TextStyle(fontSize: 15.0, color: Theme.of(context).textTheme.display2.color),)
      ],
    ),
  );

  Widget buildBodyRow(BuildContext context) => Padding(
    padding: expandedAndNotEmpty ? EdgeInsets.symmetric(vertical: 5) : EdgeInsets.only(top: 5, bottom: 15),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        getPreviewText(widget.note, context), 
        maxLines: 2,
        style: getPreviewText(widget.note, context) == AppLocalizations.of(context).translate('no_data') 
          ? TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic, color: Theme.of(context).textTheme.display1.color) 
          : TextStyle(fontSize: 16.0, color: Theme.of(context).textTheme.display1.color)
      ),
    )
  );

  String getPreviewText(Note note, BuildContext context) {
    return note is SnippetNote
     ? _getPreviewTextForSnippetNote(note, context)
     : _getPreviewTextForMarkdownNote(note, context);
  }

  String _getPreviewTextForSnippetNote(SnippetNote note, BuildContext context) {
     if(note.description == null || note.description.trim().isEmpty) {
       if(note.codeSnippets.isNotEmpty && note.codeSnippets.first.content != null && note.codeSnippets.first.content.isNotEmpty) {
         return note.codeSnippets.first.content.trim();
       } 
       return AppLocalizations.of(context).translate('no_data');
    } else {
      return note.description.trim();
    }
  }

  String _getPreviewTextForMarkdownNote(MarkdownNote note, BuildContext context) {
    return (note.content == null || note.content.trim().isEmpty) 
      ? AppLocalizations.of(context).translate('no_data') 
      : note.content.trim();
  }

  Widget buildFooterRow(BuildContext context) {
    List<Widget> widgets;

    if(widget.note.isStarred){
      widgets = [ Text(
          tagListConverter.convert(widget.note.tags), 
          maxLines: 1,
          style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic, color: Theme.of(context).textTheme.display2.color),
          overflow: TextOverflow.ellipsis,
        ),
        Icon(Icons.star, color: Colors.yellow) 
      ];
    } else {
      widgets = [ Text(
          tagListConverter.convert(widget.note.tags), 
          maxLines: 1,
          style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic, color:  Theme.of(context).textTheme.display2.color),
          overflow: TextOverflow.ellipsis,
        )
      ];
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: widgets
      ),
    );
  }
}

