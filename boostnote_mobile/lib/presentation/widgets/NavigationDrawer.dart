import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:boostnote_mobile/presentation/navigation/NavigationService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                Text(AppLocalizations.of(context).translate('mobile'), style: TextStyle(fontSize: 20, color: Color(0xFFF6F5F5))),
              ],
            ),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight
            )
        ),
      ),
     ListTile(
            leading: Icon(Icons.description, color: _navigationService.isAllNotesMode() ? Theme.of(context).accentColor : Color(0xFFF6F5F5)),
            title: Text(AppLocalizations.of(context).translate('all_notes'), style: TextStyle(color: _navigationService.isAllNotesMode() ? Theme.of(context).accentColor : Color(0xFFF6F5F5))),
            onTap: () {
              Navigator.pop(context);
              _navigationService.navigateTo(destinationMode: NavigationMode2.ALL_NOTES_MODE);
            },
      ),
      ListTile(
        leading: Icon(Icons.folder, color: _navigationService.isFoldersMode() ? Theme.of(context).accentColor : Color(0xFFF6F5F5)),
        title: Text(AppLocalizations.of(context).translate('folders'), style: TextStyle(color: _navigationService.isFoldersMode() ? Theme.of(context).accentColor : Color(0xFFF6F5F5))),
        onTap: () {
          Navigator.pop(context);
          _navigationService.navigateTo(destinationMode: NavigationMode2.FOLDERS_MODE);
        },
      ),
      ListTile(
        leading: Icon(Icons.label, color: _navigationService.isTagsMode() ? Theme.of(context).accentColor : Color(0xFFF6F5F5)),
        title: Text(AppLocalizations.of(context).translate('tags'), style: TextStyle(color: _navigationService.isTagsMode() ? Theme.of(context).accentColor : Color(0xFFF6F5F5))),
        onTap: () {
          Navigator.pop(context);
          _navigationService.navigateTo(destinationMode: NavigationMode2.TAGS_MODE);
        }
      ),
      ListTile(
        leading: Icon(Icons.star, color: _navigationService.isStarredNotesMode() ? Theme.of(context).accentColor : Color(0xFFF6F5F5)),
        title: Text(AppLocalizations.of(context).translate('starred'), style: TextStyle(color: _navigationService.isStarredNotesMode() ? Theme.of(context).accentColor : Color(0xFFF6F5F5))),
        onTap: () {
          Navigator.pop(context);
          _navigationService.navigateTo(destinationMode: NavigationMode2.STARRED_NOTES_MODE);
        },
      ),
      ListTile(
        leading: Icon(Icons.delete, color: _navigationService.isTrashMode() ? Theme.of(context).accentColor : Color(0xFFF6F5F5)),
        title: Text(AppLocalizations.of(context).translate('trash'), style: TextStyle(color: _navigationService.isTrashMode() ? Theme.of(context).accentColor : Color(0xFFF6F5F5))),
        onTap: () {
          Navigator.pop(context);
          _navigationService.navigateTo(destinationMode: NavigationMode2.TRASH_MODE);
        },
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Divider(
          height: 2.0,
          thickness: 2,
          color: Theme.of(context).accentColor,
        ),
      ),
      ListTile(
        leading: Icon(Icons.settings, color: Color(0xFFF6F5F5)),
        title: Text(AppLocalizations.of(context).translate('settings')),
        onTap: () {
          Navigator.pop(context);
          _navigationService.navigateTo(destinationMode: NavigationMode2.SETTINGS_MODE);
        },
      ),
      ListTile(
        leading: Icon(Icons.info, color: Color(0xFFF6F5F5)),
        title: Text(AppLocalizations.of(context).translate('about')),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    ];

    for(String folder in folders){
      widgets.insert(7, ListTile(
        leading: Icon(Icons.folder, color: Color(0xFFF6F5F5)),
        title: Text(folder),
        onTap: () {
          Navigator.pop(context);
        },
      ));
    }

    return widgets;
  }
}

