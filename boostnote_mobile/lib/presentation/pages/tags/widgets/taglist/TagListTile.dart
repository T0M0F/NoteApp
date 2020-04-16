
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TagListTile extends StatefulWidget {
  
  final String tag;

  TagListTile({this.tag}); 

  @override
  _TagListTileState createState() => _TagListTileState();

}

class _TagListTileState extends State<TagListTile> {

  int _numberOfNotesWithTag = 0;

  NoteService _noteService;

  @override
  void initState(){
    super.initState();
    _noteService = NoteService();
    _noteService.findNotesByTag(widget.tag).then((notes) {
      setState(() {
        _numberOfNotesWithTag = notes.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      child: Column(
        children: <Widget>[
        buildHeaderRow(),
        buildBodyRow(),
        Divider(height: 0.5)
       ]
      ),
  );
  

  Widget buildHeaderRow() => Padding(
    padding: EdgeInsets.only(top: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(MdiIcons.tag, color: Theme.of(context).indicatorColor),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(
                this.widget.tag, 
                maxLines: 1,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.display1.color)
              ),
            ),
          ]
        )
      ]
    )
  );

  Widget buildBodyRow() => Padding(
    padding:  EdgeInsets.only(top: 5, bottom: 15),
    child: Align(
      alignment: Alignment.bottomLeft,
      child:  Padding(
        padding: EdgeInsets.only(left: 30),
        child: Text(
          _numberOfNotesWithTag.toString() + ' ' + AppLocalizations.of(context).translate('notes'),
          maxLines: 2,
          style: TextStyle(fontSize: 16.0, color: Theme.of(context).textTheme.display1.color)
        )
      )
    )
  );

}
