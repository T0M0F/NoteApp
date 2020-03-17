import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EditModeBottomNavigationBar extends  StatelessWidget {

  final Function() selecetAllNotesCallback;
  final Function() deleteCallback;

  EditModeBottomNavigationBar({this.deleteCallback, this.selecetAllNotesCallback});

  @override
  Widget build(BuildContext context) {
    
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          MaterialButton(
            child: Column(
              children: <Widget>[
                Icon(Icons.check),
                Text( AppLocalizations.of(context).translate('select_all'))
              ],
            ),
            onPressed: selecetAllNotesCallback
          ),
          MaterialButton(
            child: Column(
              children: <Widget>[
                Icon(Icons.delete),
                Text(AppLocalizations.of(context).translate('delete'),)
              ],
            ),
            onPressed: deleteCallback
          ),
        ],
      ),
    );
  }
}