import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteOverviewNotifier.dart';
import 'package:boostnote_mobile/presentation/pages/PageNavigator.dart';
import 'package:boostnote_mobile/presentation/screens/note_overview/widgets/DeleteNoteBottomSheet.dart';
import 'package:boostnote_mobile/presentation/screens/note_overview/widgets/TrashNoteBottomSheet.dart';
import 'package:boostnote_mobile/presentation/widgets/notegrid/NoteGridTile.dart';
import 'package:boostnote_mobile/presentation/widgets/notelist/NoteList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class Overview extends StatefulWidget {   //TODO imutable

  @override
  _OverviewState createState() => _OverviewState();

}

class _OverviewState extends State<Overview> {

  List<Note> _selectedNotes;
  NoteNotifier _noteNotifier;
  NoteOverviewNotifier _noteOverviewNotifier;
  
  @override
  void initState(){
    super.initState();

    _selectedNotes = List();
  }

  @override
  Widget build(BuildContext context) {
    _noteNotifier = Provider.of<NoteNotifier>(context);
    _noteOverviewNotifier = Provider.of<NoteOverviewNotifier>(context);
    return _noteOverviewNotifier.showListView ? _buildListViewBody() : _buildGridViewBody();
  }

  Widget _buildListViewBody() {
    return Container( 
      child: NoteList(
        notes:  _noteOverviewNotifier.notes, 
        selectedNotes: _selectedNotes,
        onTapCallback: (selectedNotes){
          _noteNotifier.note = selectedNotes.first;
              /*if(_noteNotifier.note is SnippetNote) {
                  selectedCodeSnippet = (_noteNotifier.note as SnippetNote).codeSnippets.isNotEmpty 
                    ? (_noteNotifier.note as SnippetNote).codeSnippets.first
                    : null;
                }*/
        },
        onLongPressCallback: _onRowLongPress
      )
    );
  }

  Widget _buildGridViewBody() {   //Todo extract widget
    double _displayWidth = MediaQuery.of(context).size.width;
    int _cardWidth = 200;
    if(_displayWidth >= 1200) _displayWidth = _displayWidth * 2/5;
    int _axisCount = (_displayWidth/_cardWidth).round();
    return Container(
      child: StaggeredGridView.countBuilder(
        crossAxisCount: _axisCount,
        itemCount:  _noteOverviewNotifier.notes.length,
        itemBuilder: (BuildContext context, int index) => Card(
            child: GestureDetector(
              onTap: () {
                  _noteNotifier.note = _noteOverviewNotifier.notes[index];
                  /*if(_noteNotifier.note is SnippetNote) {
                  selectedCodeSnippet = (_noteNotifier.note as SnippetNote).codeSnippets.isNotEmpty 
                    ? (_noteNotifier.note as SnippetNote).codeSnippets.first
                    : null;
                }*/
              },
              child: NoteGridTile(note:  _noteOverviewNotifier.notes[index], expanded: _noteOverviewNotifier.expandedTiles)
            )
        ),
        staggeredTileBuilder: (int index) => StaggeredTile.count(1, calculateHeightFactor( _noteOverviewNotifier.notes[index]))
      )
    );
  }

  double calculateHeightFactor(Note note) {
    if(_noteOverviewNotifier.expandedTiles) {
      return 0.95;
    } else {
      return 0.8;
    }
  }

  void _onRowLongPress(List<Note> selectedNotes) {
    showModalBottomSheet(     
        context: context,
        builder: (BuildContext buildContext){
          return PageNavigator().pageNavigatorState != PageNavigatorState.TRASH 
            ? TrashNoteBottomSheet()
            : DeleteNoteBottomSheet();
        }
      );
  }

}

