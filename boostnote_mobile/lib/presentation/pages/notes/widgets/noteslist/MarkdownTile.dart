
import 'package:boostnote_mobile/presentation/converter/DateTimeConverter.dart';
import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/presentation/converter/TagListConverter.dart';
import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteOverviewNotifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//TODO: Merge with SnippetTile
class MarkdownTile extends StatelessWidget{
  
  final DateTimeConverter dateTimeConverter = DateTimeConverter();
  final TagListConverter tagListConverter = TagListConverter();

  final MarkdownNote note;  

  bool expandedAndNotEmpty;
  
  MarkdownTile({this.note});

  NoteOverviewNotifier _noteOverviewNotifier;

  @override
  Widget build(BuildContext context) {
    _noteOverviewNotifier = Provider.of<NoteOverviewNotifier>(context);
    List<Widget> widgets;
    expandedAndNotEmpty = _noteOverviewNotifier.expandedTiles && (note.isStarred || note.tags.isNotEmpty);
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
        vertical: 5,
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
            Icon(Icons.description, color: Theme.of(context).indicatorColor),
            Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text(note.title, 
                maxLines: 1,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.display1.color)),
            )
          ],
        ),
        Text(dateTimeConverter.convertToReadableForm(note.updatedAt), style: TextStyle(fontSize: 15.0, color: Theme.of(context).textTheme.display2.color),)
      ],
    ),
  );

  Widget buildBodyRow(BuildContext context) => Padding(
    padding:  expandedAndNotEmpty ? EdgeInsets.symmetric(vertical: 5) : EdgeInsets.only(top: 5, bottom: 15),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        (note.content == null || note.content.trim().isEmpty) 
          ? AppLocalizations.of(context).translate('no_data') 
          : note.content.trim(), 
        maxLines: 2,
        style:  (note.content == null || note.content.trim().isEmpty) 
          ? TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic, color: Theme.of(context).textTheme.display1.color) 
          : TextStyle(fontSize: 16.0, color: Theme.of(context).textTheme.display1.color)
      ),
    )
  );

  Widget buildFooterRow(BuildContext context) {
    List<Widget> widgets;

    if(note.isStarred){
      widgets = [ Text(
                    tagListConverter.convert(note.tags), 
                    maxLines: 1,
                    style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic, color: Theme.of(context).textTheme.display2.color),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Icon(Icons.star, color: Colors.yellow) 
                ];
    } else if(note.tags.isNotEmpty) {
      widgets = [ Text(
                    tagListConverter.convert(note.tags), 
                    maxLines: 1,
                    style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic, color: Theme.of(context).textTheme.display2.color),
                    overflow: TextOverflow.ellipsis,
                  )
                ];
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: widgets
      )
    );
  }
}

