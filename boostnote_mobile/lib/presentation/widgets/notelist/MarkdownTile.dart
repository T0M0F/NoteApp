
import 'package:boostnote_mobile/presentation/converter/DateTimeConverter.dart';
import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//TODO: Merge with SnippetTile
class MarkdownTile extends StatelessWidget{
  
  final DateTimeConverter dateTimeConverter = new DateTimeConverter();
  final MarkdownNote note;
  final bool expanded;
  
  MarkdownTile({this.note, this.expanded});

  @override
  Widget build(BuildContext context) {

    List<Widget> widgets;
    if (expanded) {
      widgets = <Widget>[
        buildHeaderRow(),
        buildBodyRow(),
        buildFooterRow(),
        Divider(
          height: 1.0,
          thickness: 1,
          )
      ];
    } else {
      widgets = <Widget>[
        buildHeaderRow(),
        buildBodyRow(),
        Divider(
          height: 1.0,
          thickness: 1,
          )
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

  Widget buildHeaderRow() => Padding(
    padding: EdgeInsets.only(top: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(Icons.note, color: Colors.grey),
            Padding(
              padding: EdgeInsets.only(left: 7),
              child: Text(note.title, 
                maxLines: 1,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            )
          ],
        ),
        Text(dateTimeConverter.convertToReadableForm(note.updatedAt), style: TextStyle(fontSize: 15.0, color: Colors.grey))
      ],
    ),
  );

  Widget buildBodyRow() => Padding(
    padding:  expanded ? EdgeInsets.symmetric(vertical: 5) : EdgeInsets.only(top: 5, bottom: 15),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        note.content.trim().isEmpty ? 'No Content' : note.content, 
        maxLines: 2,
        style: note.content.trim().isEmpty ? TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic) : TextStyle(fontSize: 16.0)
      ),
    )
  );

  Widget buildFooterRow() {

    List<Widget> widgets;
    if(note.isStarred){
      widgets = [ Text(note.tags.toString(), 
                  maxLines: 1,
                  style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic, color: Colors.grey)),
                  Icon(Icons.star, color: Colors.yellow) ];
    } else {
      widgets = [ Text(note.tags.toString(), 
                      maxLines: 1,
                      style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic, color: Colors.grey))];
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

