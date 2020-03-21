import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NoteInfoDialog extends StatelessWidget {  

  final Note note;

  const NoteInfoDialog(this.note);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _buildTitle(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return _buildContent(context);
        },
      ),
      actions: _buildActions(context),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container( 
              alignment: Alignment.center,
              child: Text(note.title, style: TextStyle(color:  Theme.of(context).textTheme.display1.color))
            ),
            Padding(
              padding: EdgeInsets.only(left: 5, top: 3),
              child:  Icon(Icons.info_outline, color: Theme.of(context).iconTheme.color),
            )
          ],
        )
      ],
    );
  }


  Widget _buildContent(BuildContext context) {
     return SingleChildScrollView(
       child: Container(
       height: 260,
       child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(AppLocalizations.of(context).translate('updatedAt'), style: TextStyle(color:  Theme.of(context).textTheme.display2.color)),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child:  Align(
              alignment: Alignment.centerLeft,
              child:  Text(note.updatedAt.toString(), style: Theme.of(context).textTheme.display1),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child:  Text(AppLocalizations.of(context).translate('createdAt'), style: TextStyle(color: Theme.of(context).textTheme.display2.color)),
          ),
           Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(note.createdAt.toString(), style: Theme.of(context).textTheme.display1),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Id', style: TextStyle(color:  Theme.of(context).textTheme.display2.color)),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(note.id.toString(), style: Theme.of(context).textTheme.display1),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(AppLocalizations.of(context).translate('folder'), style: TextStyle(color:  Theme.of(context).textTheme.display2.color)),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(note.folder.name, style: Theme.of(context).textTheme.display1),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(AppLocalizations.of(context).translate('starred'), style: TextStyle(color:  Theme.of(context).textTheme.display2.color)),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(note.isStarred ? AppLocalizations.of(context).translate('yes') : AppLocalizations.of(context).translate('no'), style: Theme.of(context).textTheme.display1,),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(AppLocalizations.of(context).translate('trashed'), style: TextStyle(color:  Theme.of(context).textTheme.display2.color)),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(note.isTrashed ? AppLocalizations.of(context).translate('yes') : AppLocalizations.of(context).translate('no'), style: Theme.of(context).textTheme.display1,),
            ),
          ),
        ],
      )
     )
    );
  }


  List<Widget> _buildActions(BuildContext context) {  //TODO auslagern
    return <Widget>[
      MaterialButton(
        minWidth:100,
        child: Text(AppLocalizations.of(context).translate('close'), style: TextStyle(color: Theme.of(context).textTheme.display1.color)),
        onPressed: (){
          Navigator.of(context).pop();
        }
      ),
    ];
  }

}
