import 'package:boostnote_mobile/presentation/navigation/NavigationService.dart';
import 'package:boostnote_mobile/presentation/screens/ActionConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OverviewAppbar extends StatefulWidget implements PreferredSizeWidget {

  Function() onSearchClickCallback;
  Function(String action) onSelectedActionCallback;
  Function() onMenuClickCallback;
  Function() onNaviagteBackCallback;

  String pageTitle;
  bool listTilesAreExpanded;
  bool showListView;
  Map<String, String> actions;

  OverviewAppbar({this.listTilesAreExpanded, this.showListView, this.pageTitle, this.actions, this.onSearchClickCallback, this.onMenuClickCallback, this.onNaviagteBackCallback, this.onSelectedActionCallback});

  @override
  _OverviewAppbarState createState() => _OverviewAppbarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

}

class _OverviewAppbarState extends State<OverviewAppbar> {

  NavigationService _newNavigationService;


  @override
  void initState(){
    super.initState();
    _newNavigationService = NavigationService();
  }
 
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(this.widget.pageTitle, style: Theme.of(context).accentTextTheme.title),
      leading: _buildLeadingIcon(),
      actions: _buildActions(),
    );
  }

  List<Widget> _buildActions() {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.search, color: Theme.of(context).buttonColor),
        onPressed: this.widget.onSearchClickCallback
      ),
      PopupMenuButton<String>(
        icon: Icon(Icons.more_vert, color: Theme.of(context).buttonColor),
        onSelected: this.widget.onSelectedActionCallback,
        itemBuilder: (BuildContext context) {
          return <PopupMenuEntry<String>>[
            PopupMenuItem(
              value: this.widget.listTilesAreExpanded ?  ActionConstants.COLLPASE_ACTION: ActionConstants.EXPAND_ACTION,
              child: ListTile(
                title: Text(this.widget.listTilesAreExpanded ?  ActionConstants.COLLPASE_ACTION : ActionConstants.EXPAND_ACTION , style: Theme.of(context).textTheme.display1), 
              )
            ),
            PopupMenuItem(
              value: this.widget.showListView ? ActionConstants.SHOW_GRIDVIEW_ACTION: ActionConstants.SHOW_LISTVIEW_ACTION,
              child: ListTile(
                title: Text(this.widget.showListView ? ActionConstants.SHOW_GRIDVIEW_ACTION : ActionConstants.SHOW_LISTVIEW_ACTION, style: Theme.of(context).textTheme.display1), 
              )
            ),
          ];
        }
      )
    ];
  }

  IconButton _buildLeadingIcon() {
    return (_newNavigationService.isNotesWithTagMode() || _newNavigationService.isNotesInFolderMode())
      ? IconButton(
        icon: Icon(Icons.arrow_back, color: Theme.of(context).accentColor), 
        onPressed: this.widget.onNaviagteBackCallback,
      ) : IconButton(
        icon: Icon(Icons.menu, color: Theme.of(context).accentColor), 
        onPressed: this.widget.onMenuClickCallback,
    );
    /*
    return (NavigationService().isNotesWithTagMode() || NavigationService().isNotesInFolderMode())
        ? IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).accentColor), 
          onPressed: this.widget.onNaviagteBackCallback,
        ) : IconButton(
          icon: Icon(Icons.menu, color: Theme.of(context).accentColor), 
          onPressed: this.widget.onMenuClickCallback,
        );
      */
  }
}
