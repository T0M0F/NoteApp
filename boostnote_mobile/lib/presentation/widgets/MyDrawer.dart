
import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:boostnote_mobile/presentation/navigation/NavigationService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MyDrawer extends StatefulWidget{
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {

  NavigationService _navigationService = NavigationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        elevation: 80.0,
        child: Container(
          color: Theme.of(context).primaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: buildWidgetList(context, List())
          ),
        )
      )
    );
  }

  List<Widget> buildWidgetList(BuildContext context, List<String> folders) {

    List<Widget> widgets = [
     IconButton(
            icon: Icon(MdiIcons.fileMultiple, size: 21, color: _navigationService.isAllNotesMode() ? Theme.of(context).accentColor : Theme.of(context).buttonColor),
            onPressed: () {
              Navigator.pop(context);
              _navigationService.navigateTo(destinationMode: NavigationMode2.ALL_NOTES_MODE);
            },
      ),
      IconButton(
        icon: Icon(Icons.folder, color: _navigationService.isFoldersMode() ? Theme.of(context).accentColor : Theme.of(context).buttonColor),
        onPressed: () {
          Navigator.pop(context);
          _navigationService.navigateTo(destinationMode: NavigationMode2.FOLDERS_MODE);
        },
      ),
      IconButton(
        icon: Icon(MdiIcons.tagMultiple, color: _navigationService.isTagsMode() ? Theme.of(context).accentColor : Theme.of(context).buttonColor),
        onPressed: () {
          Navigator.pop(context);
          _navigationService.navigateTo(destinationMode: NavigationMode2.TAGS_MODE);
        }
      ),
      IconButton(
        icon: Icon(Icons.star, color: _navigationService.isStarredNotesMode() ? Theme.of(context).accentColor : Theme.of(context).buttonColor),
        onPressed: () {
          Navigator.pop(context);
          _navigationService.navigateTo(destinationMode: NavigationMode2.STARRED_NOTES_MODE);
        },
      ),
      IconButton(
        icon: Icon(Icons.delete, color: _navigationService.isTrashMode() ? Theme.of(context).accentColor : Theme.of(context).buttonColor),
        onPressed: () {
          Navigator.pop(context);
          _navigationService.navigateTo(destinationMode: NavigationMode2.TRASH_MODE);
        },
      ),
      IconButton(
        icon: Icon(Icons.settings, color: _navigationService.isSettingsMode() ? Theme.of(context).accentColor : Theme.of(context).buttonColor),
        onPressed: () {
          Navigator.pop(context);
          _navigationService.navigateTo(destinationMode: NavigationMode2.SETTINGS_MODE);
        },
      ),
      IconButton(
        icon: Icon(Icons.info, color: Theme.of(context).buttonColor),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ];

    for(String folder in folders){
      widgets.insert(7, ListTile(
        leading: Icon(Icons.folder, color: Theme.of(context).buttonColor),
        title: Text(folder),
        onTap: () {
          Navigator.pop(context);
        },
      ));
    }

    return widgets;
  }
}