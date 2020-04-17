import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class NoteInfoDialog extends StatefulWidget {  
  @override
  _NoteInfoDialogState createState() => _NoteInfoDialogState();
}

class _NoteInfoDialogState extends State<NoteInfoDialog> {
  
  NoteNotifier _noteNotifier;

  @override
  Widget build(BuildContext context) {
    _noteNotifier = Provider.of<NoteNotifier>(context);

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
              child: Text(
                _noteNotifier.note.title, 
                style: TextStyle(color: Theme.of(context).textTheme.display1.color)
              )
            ),
            Padding(
              padding: EdgeInsets.only(left: 5, top: 3),
              child:  Icon(
                Icons.info_outline, 
                color: Theme.of(context).iconTheme.color
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
     return SingleChildScrollView(
       child: Container(
       height: 280,
       child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              AppLocalizations.of(context).translate('updatedAt'), 
              style: TextStyle(color:  Theme.of(context).textTheme.display2.color)
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child:  Align(
              alignment: Alignment.centerLeft,
              child:  Text(_noteNotifier.note.updatedAt.toString(), style: Theme.of(context).textTheme.display1),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child:  Text(
              AppLocalizations.of(context).translate('createdAt'), 
              style: TextStyle(color: Theme.of(context).textTheme.display2.color)
            ),
          ),
           Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(_noteNotifier.note.createdAt.toString(), style: Theme.of(context).textTheme.display1),
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
              child: Text(_noteNotifier.note.id.toString(), style: Theme.of(context).textTheme.display1),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              AppLocalizations.of(context).translate('folder'), 
              style: TextStyle(color:  Theme.of(context).textTheme.display2.color)
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _noteNotifier.note.folder.name == 'Trash' 
                  ? AppLocalizations.of(context).translate('trash') 
                  : _noteNotifier.note.folder.name, 
                style: Theme.of(context).textTheme.display1
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              AppLocalizations.of(context).translate('starred'), 
              style: TextStyle(color:  Theme.of(context).textTheme.display2.color)
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _noteNotifier.note.isStarred 
                  ? AppLocalizations.of(context).translate('yes') 
                  : AppLocalizations.of(context).translate('no'), 
                style: Theme.of(context).textTheme.display1,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              AppLocalizations.of(context).translate('trash'), 
              style: TextStyle(color:  Theme.of(context).textTheme.display2.color)
            ),
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _noteNotifier.note.isTrashed 
                ? AppLocalizations.of(context).translate('yes') 
                : AppLocalizations.of(context).translate('no'),
                style: Theme.of(context).textTheme.display1
              ),
          ),
        ],
      )
     )
    );
  }

  List<Widget> _buildActions(BuildContext context) {  
    return <Widget>[
      MaterialButton(
        minWidth:100,
        child: Text(
          AppLocalizations.of(context).translate('close'), 
          style: TextStyle(color: Theme.of(context).textTheme.display1.color)
        ),
        onPressed: (){
          Navigator.of(context).pop();
        }
      ),
    ];
  }
}
