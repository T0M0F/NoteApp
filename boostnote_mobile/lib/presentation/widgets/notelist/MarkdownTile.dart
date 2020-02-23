
import 'package:boostnote_mobile/presentation/converter/DateTimeConverter.dart';
import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/presentation/converter/TagListConverter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//TODO: Merge with SnippetTile
class MarkdownTile extends StatelessWidget{
  
  final DateTimeConverter dateTimeConverter = DateTimeConverter();
  final TagListConverter tagListConverter = TagListConverter();

  final MarkdownNote note;
  final bool expanded;

  bool expandedAndNotEmpty;
  
  MarkdownTile({this.note, this.expanded});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets;
    expandedAndNotEmpty = expanded && (note.isStarred || note.tags.isNotEmpty);
    if (expandedAndNotEmpty) {
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
            Icon(Icons.description, color: Colors.grey),
            Padding(
              padding: EdgeInsets.only(left: 5),
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
    padding:  expandedAndNotEmpty ? EdgeInsets.symmetric(vertical: 5) : EdgeInsets.only(top: 5, bottom: 15),
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
      widgets = [ Text(
                    tagListConverter.convert(note.tags), 
                    maxLines: 1,
                    style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Icon(Icons.star, color: Colors.yellow) 
                ];
    } else if(note.tags.isNotEmpty) {
      widgets = [ Text(
                    tagListConverter.convert(note.tags), 
                    maxLines: 1,
                    style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic, color: Colors.grey),
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

