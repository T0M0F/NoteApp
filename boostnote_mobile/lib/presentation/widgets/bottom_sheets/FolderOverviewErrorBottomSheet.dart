import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FolderOverviewErrorBottomSheet extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
   return Container(
      child: Wrap(
        children: <Widget>[
          ListTile(
              title:  Text(
                AppLocalizations.of(context).translate('cant_change_foldername'),
                style: TextStyle(color: Colors.red)
              )
          )
        ],
      ),
    );
  }
}
