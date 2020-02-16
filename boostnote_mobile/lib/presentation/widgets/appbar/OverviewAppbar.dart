import 'package:boostnote_mobile/presentation/NavigationService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OverviewAppbar extends StatefulWidget implements PreferredSizeWidget {

  Function() onSearchClickCallback;
  Function(String action) onSelectedActionCallback;
  Function() onMenuClickCallback;
  Function() onNaviagteBackCallback;

  String pageTitle;
  bool listTilesAreExpanded;
  Map<String, String> actions;

  OverviewAppbar({this.listTilesAreExpanded, this.pageTitle, this.actions, this.onSearchClickCallback, this.onMenuClickCallback, this.onNaviagteBackCallback, this.onSelectedActionCallback});

  @override
  _OverviewAppbarState createState() => _OverviewAppbarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

}

class _OverviewAppbarState extends State<OverviewAppbar> {

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(this.widget.pageTitle),
      leading: _buildLeadingIcon(),
      actions: _buildActions(),
    );
  }

  List<Widget> _buildActions() {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.search),
        onPressed: this.widget.onSearchClickCallback
      ),
      PopupMenuButton<String>(
        icon: Icon(Icons.more_vert),
        onSelected: this.widget.onSelectedActionCallback,
        itemBuilder: (BuildContext context) {
          return <PopupMenuEntry<String>>[
            PopupMenuItem(
              value: this.widget.actions['EDIT_ACTION'],
              child: ListTile(
                title: Text(this.widget.actions['EDIT_ACTION'])
              )
            ),
            PopupMenuItem(
              value: this.widget.listTilesAreExpanded ? this.widget.actions['COLLPASE_ACTION']: this.widget.actions['EXPAND_ACTION'],
              child: ListTile(
                title: this.widget.listTilesAreExpanded ? Text(this.widget.actions['COLLPASE_ACTION']) : Text(this.widget.actions['EXPAND_ACTION'])
              )
            ),
          ];
        }
      )
    ];
  }

  IconButton _buildLeadingIcon() {
    return (NavigationService().isNotesWithTagMode() || NavigationService().isNotesInFolderMode())
        ? IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).accentColor), 
          onPressed: this.widget.onNaviagteBackCallback,
        ) : IconButton(
          icon: Icon(Icons.menu, color: Theme.of(context).accentColor), 
          onPressed: this.widget.onMenuClickCallback,
        );
  }
}
