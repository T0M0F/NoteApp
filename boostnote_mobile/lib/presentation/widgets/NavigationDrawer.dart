 
import 'package:boostnote_mobile/presentation/NavigationService.dart';
import 'package:boostnote_mobile/presentation/screens/overview/OverviewView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationDrawer extends StatefulWidget {

 // final Function(int) onNavigate; 
  //String mode = 'All Notes';
  OverviewView overviewView;

  NavigationDrawer({Key key,/* this.onNavigate, this.mode, */this.overviewView}) : super(key: key); //TODO: Constructor

  @override
  State<StatefulWidget> createState() => NavigationDrawerState();
}

class NavigationDrawerState extends State<NavigationDrawer> {

  NavigationService navigationService = NavigationService();

   @override
  Widget build(BuildContext context) {

    return Drawer(
      elevation: 20.0,
      child: ListView(
        padding: EdgeInsets.zero,
        children: buildWidgetList(context, List()) //TODO: use repo
      ),
    );
  }

  List<Widget> buildWidgetList(BuildContext context, List<String> folders) {

      List<Widget> widgets = [
      Container(
          height: 90,
          child: DrawerHeader(
            child: Row(
              children: <Widget>[
                Text("Boostnote ", style: TextStyle(fontSize: 20, color: Theme.of(context).accentColor)),
                Text("Mobile", style: TextStyle(fontSize: 20, color: Color(0xFFF6F5F5))),
              ],
            ),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight
            )
        ),
      ),
     ListTile(
            leading: Icon(Icons.note, color: navigationService.isAllNotesMode() ? Theme.of(context).accentColor : Color(0xFFF6F5F5)),
            title: Text('All Notes', style: TextStyle(color: navigationService.isAllNotesMode() ? Theme.of(context).accentColor : Color(0xFFF6F5F5))),
            onTap: () {
              Navigator.pop(context);
              navigationService.navigateTo(context, OverviewMode.ALL_NOTES_MODE, overviewView: this.widget.overviewView);
              //this.widget.onNavigate(NaviagtionDrawerAction.ALL_NOTES);
            },
      ),
      ListTile(
        leading: Icon(Icons.label, color: navigationService.isFoldersMode() ? Theme.of(context).accentColor : Color(0xFFF6F5F5)),
        title: Text('Folders', style: TextStyle(color: navigationService.isFoldersMode() ? Theme.of(context).accentColor : Color(0xFFF6F5F5))),
        onTap: () {
          Navigator.pop(context);
          navigationService.navigateTo(context, OverviewMode.FOLDERS_MODE);
          //this.widget.onNavigate(NaviagtionDrawerAction.FOLDERS);
        },
      ),
      ListTile(
        leading: Icon(Icons.label, color: navigationService.isTagsMode() ? Theme.of(context).accentColor : Color(0xFFF6F5F5)),
        title: Text('Tags', style: TextStyle(color: navigationService.isTagsMode() ? Theme.of(context).accentColor : Color(0xFFF6F5F5))),
        onTap: () {
          Navigator.pop(context);
          navigationService.navigateTo(context, OverviewMode.TAGS_MODE);
          //this.widget.onNavigate(NaviagtionDrawerAction.TAGS);
        },
      ),
      ListTile(
        leading: Icon(Icons.star, color: navigationService.isStarredNotesMode() ? Theme.of(context).accentColor : Color(0xFFF6F5F5)),
        title: Text('Starred', style: TextStyle(color: navigationService.isStarredNotesMode() ? Theme.of(context).accentColor : Color(0xFFF6F5F5))),
        onTap: () {
          Navigator.pop(context);
          navigationService.navigateTo(context, OverviewMode.STARRED_NOTES_MODE, overviewView: this.widget.overviewView);
          //this.widget.onNavigate(NaviagtionDrawerAction.STARRED);
        },
      ),
      ListTile(
        leading: Icon(Icons.delete, color: navigationService.isTrashMode() ? Theme.of(context).accentColor : Color(0xFFF6F5F5)),
        title: Text('Trash', style: TextStyle(color: navigationService.isTrashMode() ? Theme.of(context).accentColor : Color(0xFFF6F5F5))),
        onTap: () {
          Navigator.pop(context);
          navigationService.navigateTo(context, OverviewMode.TRASH_MODE, overviewView: this.widget.overviewView);
          //this.widget.onNavigate(NaviagtionDrawerAction.TRASH);
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
        title: Text('Settings'),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      ListTile(
        leading: Icon(Icons.info, color: Color(0xFFF6F5F5)),
        title: Text('About'),
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
 
class NaviagtionDrawerAction {

  static const int TRASH = 0;
  static const int ALL_NOTES = 1;
  static const int STARRED = 2;
  static const int FOLDERS = 3;
  static const int NOTES_IN_FOLDER = 4; //TODO Refactor, move in other class??
  static const int NOTES_WITH_TAG = 5;
  static const int TAGS = 6;
}

