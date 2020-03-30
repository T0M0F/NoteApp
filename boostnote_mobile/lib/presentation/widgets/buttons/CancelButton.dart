import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CancelButton extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth:100,
      child: Text(AppLocalizations.of(context).translate('cancel'), style: TextStyle(color: Theme.of(context).textTheme.display1.color)),
      onPressed: (){
        Navigator.of(context).pop();
      }
    );
  }

}