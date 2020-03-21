import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:boostnote_mobile/presentation/navigation/NavigationService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class NavigationDrawer extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => NavigationDrawerState();

}

class NavigationDrawerState extends State<NavigationDrawer> {

  NavigationService _navigationService = NavigationService();

  @override
  Widget build(BuildContext context) {

    return Theme(
      data: Theme.of(context).copyWith(
          canvasColor: Theme.of(context).primaryColorLight,
          textTheme: TextTheme(
              body1: TextStyle(color: Theme.of(context).primaryColorLight)
            )
          ),
      child: Drawer(
        elevation: 20.0,
        child: ListView(
          padding: EdgeInsets.zero,
          children: buildWidgetList(context, List())
        ),
      )
    );
  }

  List<Widget> buildWidgetList(BuildContext context, List<String> folders) {

    List<Widget> widgets = [
      Container(
          height: 90,
          child: DrawerHeader(
            child: Row(
              children: <Widget>[
                Text(AppLocalizations.of(context).translate('boostnote') + ' ', style: TextStyle(fontSize: 20, color: Theme.of(context).accentColor)),
                Text(AppLocalizations.of(context).translate('mobile'), style: TextStyle(fontSize: 20, color: Theme.of(context).accentTextTheme.display1.color)),
              ],
            ),
        ),
      ),
     ListTile(
            leading: Icon(MdiIcons.fileMultiple, size: 21, color: _navigationService.isAllNotesMode() ? Theme.of(context).accentColor : Theme.of(context).buttonColor),
            title: Text(AppLocalizations.of(context).translate('all_notes'), style: TextStyle(color: _navigationService.isAllNotesMode() ? Theme.of(context).accentColor : Theme.of(context).accentTextTheme.display1.color)),
            onTap: () {
              Navigator.pop(context);
              _navigationService.navigateTo(destinationMode: NavigationMode2.ALL_NOTES_MODE);
            },
      ),
      ListTile(
        leading: Icon(Icons.folder, color: _navigationService.isFoldersMode() ? Theme.of(context).accentColor : Theme.of(context).buttonColor),
        title: Text(AppLocalizations.of(context).translate('folders'), style: TextStyle(color: _navigationService.isFoldersMode() ? Theme.of(context).accentColor :Theme.of(context).accentTextTheme.display1.color)),
        onTap: () {
          Navigator.pop(context);
          _navigationService.navigateTo(destinationMode: NavigationMode2.FOLDERS_MODE);
        },
      ),
      ListTile(
        leading: Icon(MdiIcons.tagMultiple, color: _navigationService.isTagsMode() ? Theme.of(context).accentColor : Theme.of(context).buttonColor),
        title: Text(AppLocalizations.of(context).translate('tags'), style: TextStyle(color: _navigationService.isTagsMode() ? Theme.of(context).accentColor : Theme.of(context).accentTextTheme.display1.color)),
        onTap: () {
          Navigator.pop(context);
          _navigationService.navigateTo(destinationMode: NavigationMode2.TAGS_MODE);
        }
      ),
      ListTile(
        leading: Icon(Icons.star, color: _navigationService.isStarredNotesMode() ? Theme.of(context).accentColor : Theme.of(context).buttonColor),
        title: Text(AppLocalizations.of(context).translate('starred'), style: TextStyle(color: _navigationService.isStarredNotesMode() ? Theme.of(context).accentColor : Theme.of(context).accentTextTheme.display1.color)),
        onTap: () {
          Navigator.pop(context);
          _navigationService.navigateTo(destinationMode: NavigationMode2.STARRED_NOTES_MODE);
        },
      ),
      ListTile(
        leading: Icon(Icons.delete, color: _navigationService.isTrashMode() ? Theme.of(context).accentColor : Theme.of(context).buttonColor),
        title: Text(AppLocalizations.of(context).translate('trash'), style: TextStyle(color: _navigationService.isTrashMode() ? Theme.of(context).accentColor : Theme.of(context).accentTextTheme.display1.color)),
        onTap: () {
          Navigator.pop(context);
          _navigationService.navigateTo(destinationMode: NavigationMode2.TRASH_MODE);
        },
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Divider(
          height: 1,
          thickness: 1,
          color: Theme.of(context).accentColor,
        ),
      ),
      ListTile(
        leading: Icon(Icons.settings, color: _navigationService.isSettingsMode() ? Theme.of(context).accentColor : Theme.of(context).buttonColor),
        title: Text(AppLocalizations.of(context).translate('settings'), style: TextStyle(color: Theme.of(context).accentTextTheme.display1.color),),
        onTap: () {
          Navigator.pop(context);
          _navigationService.navigateTo(destinationMode: NavigationMode2.SETTINGS_MODE);
        },
      ),
      ListTile(
        leading: Icon(Icons.info, color: Theme.of(context).buttonColor),
        title: Text(AppLocalizations.of(context).translate('about'), style: TextStyle(color: Theme.of(context).accentTextTheme.display1.color),),
        onTap: () {
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

