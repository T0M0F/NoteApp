import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeleteAllBottomNavigationBar extends StatelessWidget {

  final Function() deleteAllCallback;

  DeleteAllBottomNavigationBar({this.deleteAllCallback});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.redAccent,
      padding: EdgeInsets.symmetric(vertical: 5),
      child: MaterialButton(
        onPressed: deleteAllCallback,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Icon(Icons.delete, color: Theme.of(context).buttonColor)
                ),
                Text(
                  AppLocalizations.of(context).translate('delete_all'),
                  style: TextStyle(fontSize: 18, color: Theme.of(context).accentTextTheme.display1.color),
                )
              ],
            ) 
          ],
        )
      )
    );
  }

}





