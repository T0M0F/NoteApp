import 'package:boostnote_mobile/business_logic/model/Folder.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/service/FolderService.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/presentation/pages/PageNavigator.dart';
import 'package:boostnote_mobile/presentation/screens/note_overview/widgets/DeleteNoteBottomSheet.dart';
import 'package:boostnote_mobile/presentation/screens/note_overview/widgets/TrashNoteBottomSheet.dart';
import 'package:boostnote_mobile/presentation/widgets/notegrid/NoteGridTile.dart';
import 'package:boostnote_mobile/presentation/widgets/notelist/NoteList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Overview extends StatefulWidget {   //TODO imutable

  List<Note> notes;   
  bool tilesAreExpanded;
  bool showListView;
  Function(Note) openNote;
  final Function(Note) trashOrDeleteOrRestoreNote;

  Overview({@required this.notes, 
            @required this.tilesAreExpanded, 
            @required this.showListView,
            @required this.openNote, 
            this.trashOrDeleteOrRestoreNote});   //TODO constructor

  @override
  _OverviewState createState() => _OverviewState();

}

class _OverviewState extends State<Overview> {

  NoteService _noteService;
  List<Note> _selectedNotes;
  
  @override
  void initState(){
    super.initState();

    _noteService = NoteService();
    _selectedNotes = List();
  }

  @override
  Widget build(BuildContext context)  => this.widget.showListView ? _buildListViewBody() : _buildGridViewBody();

  Widget _buildListViewBody() {
    return Container( 
      child: NoteList(
        notes:  this.widget.notes, 
        selectedNotes: _selectedNotes,
        expandedMode: this.widget.tilesAreExpanded,
        onTapCallback: (selectedNotes){
          this.widget.openNote(selectedNotes.first);
        },
        onLongPressCallback: (selectedNotes){
          _onRowLongPress(selectedNotes);
        }
      )
    );
  }

  Widget _buildGridViewBody() {   //Todo extract widget
    double _displayWidth = MediaQuery.of(context).size.width;
    int _cardWidth = 200;
    int _axisCount = (_displayWidth/_cardWidth).round();
    return Container(
      child: StaggeredGridView.countBuilder(
        crossAxisCount: _axisCount,
        itemCount:  this.widget.notes.length,
        itemBuilder: (BuildContext context, int index) => Card(
            child: GestureDetector(
              onTap: () {
                 this.widget.openNote(this.widget.notes[index]);
              },
              child: NoteGridTile(note:  this.widget.notes[index], expanded: this.widget.tilesAreExpanded)
            )
        ),
        staggeredTileBuilder: (int index) => StaggeredTile.count(1, calculateHeightFactor( this.widget.notes[index]))
      )
    );
  }

  double calculateHeightFactor(Note note) {
    if(this.widget.tilesAreExpanded) {
      return 0.95;
    } else {
      return 0.8;
    }
  }

  void _onRowLongPress(List<Note> selectedNotes) {
    if(PageNavigator().pageNavigatorState != PageNavigatorState.TRASH) {
      showModalBottomSheet(     
        context: context,
        builder: (BuildContext buildContext){
          return TrashNoteBottomSheet(
            trashNoteCallback: () {
              Navigator.of(context).pop();
              _noteService.moveToTrash(selectedNotes.first);
              setState(() {
                this.widget.notes.remove(selectedNotes.first);
              });
              widget.trashOrDeleteOrRestoreNote(selectedNotes.first);
            } ,
          );
        }
      );
    } else {
      showModalBottomSheet(     
        context: context,
        builder: (BuildContext buildContext){
          return DeleteNoteBottomSheet(
            deleteNoteCallback: () {
              Navigator.of(context).pop();
              _noteService.delete(selectedNotes.first);
              setState(() {
                this.widget.notes.remove(selectedNotes.first);
              });
              widget.trashOrDeleteOrRestoreNote(selectedNotes.first);
            },
            restoreNoteCallback: () {
              Navigator.of(context).pop();
              _noteService.restore(selectedNotes.first);
              setState(() {
                this.widget.notes.remove(selectedNotes.first);
              });
              widget.trashOrDeleteOrRestoreNote(selectedNotes.first);
            } ,
          );
        }
      );
    }
  }

}

