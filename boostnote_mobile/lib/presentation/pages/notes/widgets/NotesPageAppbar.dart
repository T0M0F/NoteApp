import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/presentation/ActionConstants.dart';
import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:boostnote_mobile/presentation/navigation/PageNavigator.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteOverviewNotifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class NotesPageAppbar extends StatefulWidget implements PreferredSizeWidget {

  final Function(String action) onSelectedActionCallback;
  final Function() onMenuClick;
  final Map<String, String> actions;
  final List<Note> notes;

  NotesPageAppbar({this.notes, this.actions, this.onSelectedActionCallback, this.onMenuClick});

  @override
  _NotesPageAppbarState createState() => _NotesPageAppbarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _NotesPageAppbarState extends State<NotesPageAppbar> {

  TextEditingController _filter;
  Widget _appbarTitle;
  List<Note> filteredNotes;
  Icon _searchIcon;
  String _searchText;
  bool _firstLoad;
  NoteOverviewNotifier _noteOverviewNotifier;
  PageNavigator _pageNavigator = PageNavigator();

  @override
  void initState(){
    super.initState();

    _firstLoad = true;
  }

  void _init(){    //Necessary, because initialization of Text and Icon widget not possible in initState
    _filter = TextEditingController();
    filteredNotes = List();
    _searchIcon = Icon(Icons.search, color: Theme.of(context).buttonColor);
    _appbarTitle = Text(
      _noteOverviewNotifier.pageTitle 
      ?? AppLocalizations.of(context).translate('all_notes'), 
      style: Theme.of(context).accentTextTheme.title
    );
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
          _noteOverviewNotifier.notes = tempList;
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
          _noteOverviewNotifier.notes = tempList;
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

    return _buildWidget(context);
  }

  AppBar _buildWidget(BuildContext context) {
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
              value: _noteOverviewNotifier.expandedTiles 
                ? ActionConstants.COLLPASE_ACTION
                : ActionConstants.EXPAND_ACTION,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    _noteOverviewNotifier.expandedTiles 
                    ? MdiIcons.arrowCollapse 
                    : MdiIcons.arrowExpand, 
                    color: Theme.of(context).iconTheme.color
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      _noteOverviewNotifier.expandedTiles 
                      ?  AppLocalizations.of(context).translate('collapse') 
                      : AppLocalizations.of(context).translate('expand'), 
                      style: Theme.of(context).textTheme.display1
                    )
                  )
                ]
              )
            ),
            PopupMenuItem(
              value: _noteOverviewNotifier.showListView 
                ? ActionConstants.SHOW_GRIDVIEW_ACTION
                : ActionConstants.SHOW_LISTVIEW_ACTION,
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    _noteOverviewNotifier.showListView 
                    ? MdiIcons.viewGrid : MdiIcons.viewList, color
                    : Theme.of(context).iconTheme.color
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child:  Text(
                      _noteOverviewNotifier.showListView 
                      ? AppLocalizations.of(context).translate('gridview') 
                      : AppLocalizations.of(context).translate('listview'), 
                      style: Theme.of(context).textTheme.display1)
                  )
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
        this._appbarTitle = Text(
          _noteOverviewNotifier.pageTitle 
          ?? AppLocalizations.of(context).translate('all_notes'), 
          style: Theme.of(context).accentTextTheme.title
        );
        filteredNotes = this.widget.notes;
        _filter.clear();
      }
    });
  }

  IconButton _buildLeadingIcon(BuildContext context) {
    bool notesInFOlderOrNotesWithTagsMode = 
      _pageNavigator.pageNavigatorState == PageNavigatorState.NOTES_IN_FOLDER 
      ||  _pageNavigator.pageNavigatorState == PageNavigatorState.NOTES_WITH_TAG;

    return notesInFOlderOrNotesWithTagsMode ? IconButton(
        icon: Icon(Icons.arrow_back, color: Theme.of(context).accentColor),
        onPressed: ()  {
          _pageNavigator.navigateBack(context);
          Navigator.of(context).pop();
        },
      )
    : IconButton(
        icon: Icon(Icons.menu, color: Theme.of(context).accentColor),
        onPressed: widget.onMenuClick
      );
  }

}
