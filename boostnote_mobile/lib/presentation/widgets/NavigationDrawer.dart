 
 
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/data/repositoryImpl/mock/MockFolderRepository.dart';
import 'package:boostnote_mobile/business_logic/repository/FolderRepository.dart';
import 'package:boostnote_mobile/presentation/screens/overview/Overview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationDrawer extends StatefulWidget {

  final Function(String) createFolderCallback;
  final Function(int) onNavigate; 
  String mode = 'All Notes';

  NavigationDrawer({Key key, @required this.createFolderCallback, this.onNavigate, this.mode}) : super(key: key); //TODO: Constructor

  @override
  State<StatefulWidget> createState() => NavigationDrawerState();
}

class NavigationDrawerState extends State<NavigationDrawer> {

  FolderRepository _folderRepository = MockFolderRepository();

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
            leading: Icon(Icons.note, color: this.widget.mode == 'All Notes' ? Theme.of(context).accentColor : Color(0xFFF6F5F5)),
            title: Text('All Notes', style: TextStyle(color: this.widget.mode == 'All Notes' ? Theme.of(context).accentColor : Color(0xFFF6F5F5))),
            onTap: () {
              //TODO: Callback to Parent
              this.widget.onNavigate(NaviagtionDrawerAction.ALL_NOTES);
              Navigator.of(context).pop();
            },
      ),
      ListTile(
        leading: Icon(Icons.label, color: this.widget.mode == 'Tags' ? Theme.of(context).accentColor : Color(0xFFF6F5F5)),
        title: Text('Tags', style: TextStyle(color: this.widget.mode == 'Tags' ? Theme.of(context).accentColor : Color(0xFFF6F5F5))),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      ListTile(
        leading: Icon(Icons.star, color: this.widget.mode == 'Starred Notes' ? Theme.of(context).accentColor : Color(0xFFF6F5F5)),
        title: Text('Starred', style: TextStyle(color: this.widget.mode == 'Starred Notes' ? Theme.of(context).accentColor : Color(0xFFF6F5F5))),
        onTap: () {
           //TODO: Callback to Parent
          this.widget.onNavigate(NaviagtionDrawerAction.STARRED);
          Navigator.of(context).pop();
        },
      ),
      ListTile(
        leading: Icon(Icons.delete, color: this.widget.mode == 'Trashed Notes' ? Theme.of(context).accentColor : Color(0xFFF6F5F5)),
        title: Text('Trash', style: TextStyle(color: this.widget.mode == 'Trashed Notes' ? Theme.of(context).accentColor : Color(0xFFF6F5F5))),
        onTap: () {
           //TODO: Callback to Parent
          this.widget.onNavigate(NaviagtionDrawerAction.TRASH);
          Navigator.of(context).pop();
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
        leading: Icon(Icons.create_new_folder, color: Color(0xFFF6F5F5)),
        title: Text('Create Folder'),
        onTap: () {
          _createDialog(context);
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

//TODO: In Widget auslagern
  Future<String> _createDialog(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('Create Folder', style: TextStyle(color: Colors.black)),
        content: TextField(
          controller: textEditingController,
          style: TextStyle(color: Colors.black)
        ),
        actions: <Widget>[
          MaterialButton(
            elevation: 5.0,
            color: Theme.of(context).accentColor,
            child: Text('Save', style: TextStyle(color: Color(0xFFF6F5F5))),
            onPressed: (){
               this.widget.createFolderCallback(textEditingController.text);
            }
          )
        ],
      );
    });
  }

}
 
class NaviagtionDrawerAction {

  static const int TRASH = 0;
  static const int ALL_NOTES = 1;
  static const int STARRED = 2;

}

