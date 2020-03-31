import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/presentation/navigation/NavigationService.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteOverviewNotifier.dart';
import 'package:boostnote_mobile/presentation/pages/PageNavigator.dart';
import 'package:boostnote_mobile/presentation/screens/ActionConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class OverviewAppbar extends StatefulWidget implements PreferredSizeWidget {

  Function(String action) onSelectedActionCallback;
  Function() onNaviagteBackCallback;
  Function(List<Note>) onSearchCallback;
  final Function() onMenuClick;

  String pageTitle;
  Map<String, String> actions;
  List<Note> notes;

  OverviewAppbar({this.pageTitle, this.notes, this.actions, this.onNaviagteBackCallback, this.onSelectedActionCallback, this.onSearchCallback, this.onMenuClick});

  @override
  _OverviewAppbarState createState() => _OverviewAppbarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

}

class _OverviewAppbarState extends State<OverviewAppbar> {

  NavigationService _newNavigationService;
  TextEditingController _filter;
  Widget _appbarTitle;
  List<Note> filteredNotes;
  Icon _searchIcon;
  String _searchText;

  bool _firstLoad;

  NoteOverviewNotifier _noteOverviewNotifier;

  @override
  void initState(){
    super.initState();

    _firstLoad = true;
  }

  //Necessary, because initialization of widgets not possible in initState
  void _init(){
    _newNavigationService = NavigationService();
    _filter = TextEditingController();
    filteredNotes = List();
    _searchIcon = Icon(Icons.search, color: Theme.of(context).buttonColor);
    _appbarTitle = Text(this.widget.pageTitle, style: Theme.of(context).accentTextTheme.title);
    _searchText = "";
    _firstLoad = false;

    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          List<Note> tempList = new List();
          for (int i = 0; i < this.widget.notes.length; i++) {
            tempList.add(this.widget.notes[i]);
          }
          filteredNotes = tempList;
          this.widget.onSearchCallback(tempList);
        });
      } else {
        setState(() {
          _searchText = _filter.text;
          List<Note> tempList = new List();
          for (int i = 0; i < this.widget.notes.length; i++) {
            if (this.widget.notes[i].title.toLowerCase().contains(_searchText.toLowerCase())) {
              tempList.add(this.widget.notes[i]);
            }
          }
          filteredNotes = tempList;
          this.widget.onSearchCallback(tempList);
        });
      }
    });
  }
 
  @override
  Widget build(BuildContext context) {
    _noteOverviewNotifier = Provider.of<NoteOverviewNotifier>(context);

    if(_firstLoad){
      _init();
    }
    return AppBar(
      title: _appbarTitle,
      leading: _buildLeadingIcon(context),
      actions: _buildActions(),
    );
  }

  List<Widget> _buildActions() {
    return <Widget>[
      IconButton(
        icon: _searchIcon,
        onPressed: (){_searchPressed();}
      ),
      PopupMenuButton<String>(
        icon: Icon(Icons.more_vert, color: Theme.of(context).buttonColor),
        onSelected: this.widget.onSelectedActionCallback,
        itemBuilder: (BuildContext context) {
          return <PopupMenuEntry<String>>[
            PopupMenuItem(
              value: _noteOverviewNotifier.expandedTiles ?  ActionConstants.COLLPASE_ACTION: ActionConstants.EXPAND_ACTION,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Icon(_noteOverviewNotifier.expandedTiles ? MdiIcons.arrowCollapse : MdiIcons.arrowExpand, color: Theme.of(context).iconTheme.color),
                  Text(_noteOverviewNotifier.expandedTiles ?  ActionConstants.COLLPASE_ACTION : ActionConstants.EXPAND_ACTION , style: Theme.of(context).textTheme.display1)
                ]
              )
            ),
            PopupMenuItem(
              value: _noteOverviewNotifier.showListView ? ActionConstants.SHOW_GRIDVIEW_ACTION: ActionConstants.SHOW_LISTVIEW_ACTION,
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Icon(_noteOverviewNotifier.showListView ? MdiIcons.viewGrid : MdiIcons.viewList, color: Theme.of(context).iconTheme.color),
                  Text(_noteOverviewNotifier.showListView ? ActionConstants.SHOW_GRIDVIEW_ACTION: ActionConstants.SHOW_LISTVIEW_ACTION , style: Theme.of(context).textTheme.display1)
                ]
              )
            ),
          ];
        }
      )
    ];
  }
 
  _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = Icon(Icons.close, color: Theme.of(context).buttonColor);
        this._appbarTitle = TextField(
          controller: _filter,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search, color: Theme.of(context).buttonColor),
            hintText: 'Search...',
            hintStyle: Theme.of(context).accentTextTheme.title,
            border: InputBorder.none,
          ),
          style: Theme.of(context).accentTextTheme.title,
        );
      } else {
        this._searchIcon = Icon(Icons.search, color: Theme.of(context).buttonColor);
        this._appbarTitle = Text(this.widget.pageTitle, style: Theme.of(context).accentTextTheme.title);
        filteredNotes = this.widget.notes;
        _filter.clear();
      }
    });
  }

  IconButton _buildLeadingIcon(BuildContext context) {
    return PageNavigator().pageNavigatorState == PageNavigatorState.NOTES_IN_FOLDER 
            ||  PageNavigator().pageNavigatorState == PageNavigatorState.NOTES_WITH_TAG 
      ? IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).accentColor),
          onPressed: ()  => Navigator.of(context).pop(),
        )
      : IconButton(
          icon: Icon(Icons.menu, color: Theme.of(context).accentColor),
          onPressed: () => widget.onMenuClick
        );
  }

}
