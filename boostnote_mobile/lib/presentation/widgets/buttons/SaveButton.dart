import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SaveButton extends StatelessWidget {

  Function() save;

  SaveButton({@required this.save});
  
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth:100,
      elevation: 5.0,
      color: Theme.of(context).accentColor,
      child: Text(AppLocalizations.of(context).translate('save'), style: TextStyle(color:  Theme.of(context).accentTextTheme.display1.color)),
      onPressed: save
    );
  }

}