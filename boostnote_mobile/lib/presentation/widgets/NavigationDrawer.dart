import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:boostnote_mobile/presentation/navigation/NavigationService.dart';
import 'package:boostnote_mobile/presentation/pages/PageNavigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class NavigationDrawer extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => NavigationDrawerState();

}

class NavigationDrawerState extends State<NavigationDrawer> {

  PageNavigator _pageNavigator = PageNavigator();

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
            leading: Icon(MdiIcons.fileMultiple, size: 21, color: _pageNavigator.pageNavigatorState == PageNavigatorState.ALL_NOTES ? Theme.of(context).accentColor : Theme.of(context).buttonColor),
            title: Text(AppLocalizations.of(context).translate('all_notes'), style: TextStyle(color:  _pageNavigator.pageNavigatorState == PageNavigatorState.ALL_NOTES ? Theme.of(context).accentColor : Theme.of(context).accentTextTheme.display1.color)),
            onTap: () {
              Navigator.pop(context);
              _pageNavigator.navigateToAllNotes(context);
            },
      ),
      ListTile(
        leading: Icon(Icons.folder, color:  _pageNavigator.pageNavigatorState == PageNavigatorState.FOLDERS || _pageNavigator.pageNavigatorState == PageNavigatorState.NOTES_IN_FOLDER ? Theme.of(context).accentColor : Theme.of(context).buttonColor),
        title: Text(AppLocalizations.of(context).translate('folders'), style: TextStyle(color:  _pageNavigator.pageNavigatorState == PageNavigatorState.FOLDERS || _pageNavigator.pageNavigatorState == PageNavigatorState.NOTES_IN_FOLDER ? Theme.of(context).accentColor :Theme.of(context).accentTextTheme.display1.color)),
        onTap: () {
          Navigator.pop(context);
          _pageNavigator.navigateToFolders(context);
        },
      ),
      ListTile(
        leading: Icon(MdiIcons.tagMultiple, color:  _pageNavigator.pageNavigatorState == PageNavigatorState.TAGS || _pageNavigator.pageNavigatorState == PageNavigatorState.NOTES_WITH_TAG ? Theme.of(context).accentColor : Theme.of(context).buttonColor),
        title: Text(AppLocalizations.of(context).translate('tags'), style: TextStyle(color:  _pageNavigator.pageNavigatorState == PageNavigatorState.TAGS || _pageNavigator.pageNavigatorState == PageNavigatorState.NOTES_WITH_TAG ? Theme.of(context).accentColor : Theme.of(context).accentTextTheme.display1.color)),
        onTap: () {
          Navigator.pop(context);
          _pageNavigator.navigateToTags(context);
        }
      ),
      ListTile(
        leading: Icon(Icons.star, color:  _pageNavigator.pageNavigatorState == PageNavigatorState.STARRED ? Theme.of(context).accentColor : Theme.of(context).buttonColor),
        title: Text(AppLocalizations.of(context).translate('starred'), style: TextStyle(color:  _pageNavigator.pageNavigatorState == PageNavigatorState.STARRED ? Theme.of(context).accentColor : Theme.of(context).accentTextTheme.display1.color)),
        onTap: () {
          Navigator.pop(context);
         
          _pageNavigator.navigateToStarredNotes(context);
        },
      ),
      ListTile(
        leading: Icon(Icons.delete, color:  _pageNavigator.pageNavigatorState == PageNavigatorState.TRASH ? Theme.of(context).accentColor : Theme.of(context).buttonColor),
        title: Text(AppLocalizations.of(context).translate('trash'), style: TextStyle(color:  _pageNavigator.pageNavigatorState == PageNavigatorState.TRASH ? Theme.of(context).accentColor : Theme.of(context).accentTextTheme.display1.color)),
        onTap: () {
          Navigator.pop(context);
       
          _pageNavigator.navigateToTrash(context);
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
        leading: Icon(Icons.settings, color: Theme.of(context).buttonColor),
        title: Text(AppLocalizations.of(context).translate('settings'), style: TextStyle(color: Theme.of(context).accentTextTheme.display1.color),),
        onTap: () {
          Navigator.pop(context);
        
          _pageNavigator.navigateToSettings(context);
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

