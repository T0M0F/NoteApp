 
import 'package:boostnote_mobile/presentation/NavigationService.dart';
import 'package:boostnote_mobile/presentation/screens/note_overview/OverviewView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationDrawer extends StatefulWidget {

  final OverviewView overviewView;

  NavigationDrawer({Key key, this.overviewView}) : super(key: key); //TODO: Constructor

  @override
  State<StatefulWidget> createState() => NavigationDrawerState();

}

class NavigationDrawerState extends State<NavigationDrawer> {

  NavigationService navigationService = NavigationService();

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
          children: buildWidgetList(context, List()) //TODO: use repo
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
              navigationService.navigateTo(context, NavigationMode.ALL_NOTES_MODE, overviewView: this.widget.overviewView);
            },
      ),
      ListTile(
        leading: Icon(Icons.folder, color: navigationService.isFoldersMode() ? Theme.of(context).accentColor : Color(0xFFF6F5F5)),
        title: Text('Folders', style: TextStyle(color: navigationService.isFoldersMode() ? Theme.of(context).accentColor : Color(0xFFF6F5F5))),
        onTap: () {
          Navigator.pop(context);
          navigationService.navigateTo(context, NavigationMode.FOLDERS_MODE);
        },
      ),
      ListTile(
        leading: Icon(Icons.label, color: navigationService.isTagsMode() ? Theme.of(context).accentColor : Color(0xFFF6F5F5)),
        title: Text('Tags', style: TextStyle(color: navigationService.isTagsMode() ? Theme.of(context).accentColor : Color(0xFFF6F5F5))),
        onTap: () {
          Navigator.pop(context);
          navigationService.navigateTo(context, NavigationMode.TAGS_MODE);
        },
      ),
      ListTile(
        leading: Icon(Icons.star, color: navigationService.isStarredNotesMode() ? Theme.of(context).accentColor : Color(0xFFF6F5F5)),
        title: Text('Starred', style: TextStyle(color: navigationService.isStarredNotesMode() ? Theme.of(context).accentColor : Color(0xFFF6F5F5))),
        onTap: () {
          Navigator.pop(context);
          navigationService.navigateTo(context, NavigationMode.STARRED_NOTES_MODE, overviewView: this.widget.overviewView);
        },
      ),
      ListTile(
        leading: Icon(Icons.delete, color: navigationService.isTrashMode() ? Theme.of(context).accentColor : Color(0xFFF6F5F5)),
        title: Text('Trash', style: TextStyle(color: navigationService.isTrashMode() ? Theme.of(context).accentColor : Color(0xFFF6F5F5))),
        onTap: () {
          Navigator.pop(context);
          navigationService.navigateTo(context, NavigationMode.TRASH_MODE, overviewView: this.widget.overviewView);
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

