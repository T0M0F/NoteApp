

import 'package:boostnote_mobile/presentation/converter/DateTimeConverter.dart';
import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//TODO: Merge with MarkdownTile
class SnippetTile extends StatelessWidget{
  
  final DateTimeConverter _dateTimeConverter = new DateTimeConverter();  
  final SnippetNote note;
  final bool expanded;

  SnippetTile({this.note, this.expanded});

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
            Icon(Icons.code, color: Colors.grey),
            Padding(
              padding: EdgeInsets.only(left: 7),
              child:  Text(note.title, 
                maxLines: 1,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            )
          ],
        ),
        Text(_dateTimeConverter.convertToReadableForm(note.updatedAt), style: TextStyle(fontSize: 15.0, color: Colors.grey))
      ],
    ),
  );

  Widget buildBodyRow() => Padding(
    padding: expanded ? EdgeInsets.symmetric(vertical: 5) : EdgeInsets.only(top: 5, bottom: 15),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        getPreviewText(note), 
        maxLines: 2,
        style: getPreviewText(note) == 'No Content' ? TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic) : TextStyle(fontSize: 16.0)
      ),
    )
  );

  String getPreviewText(SnippetNote note) {
    if(note.description.trim().isEmpty) {
       if(note.codeSnippets.isNotEmpty) {
         return note.codeSnippets.first.content;
       } 
       return 'No Content';
    } else {
      return note.description;
    }
  }

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
      ),
    );
  }
}

