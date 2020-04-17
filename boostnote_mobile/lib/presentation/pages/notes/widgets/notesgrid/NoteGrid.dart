import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteOverviewNotifier.dart';
import 'package:boostnote_mobile/presentation/pages/notes/widgets/notesgrid/NoteGridTile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class NoteGrid extends StatefulWidget {
  @override
  _NoteGridState createState() => _NoteGridState();
}

class _NoteGridState extends State<NoteGrid> {

  NoteOverviewNotifier _noteOverviewNotifier;
  NoteNotifier _noteNotifier;

  @override
  Widget build(BuildContext context) {
    initNotifiers();
    return _buildWidget();
  }

  void initNotifiers() {
    _noteOverviewNotifier = Provider.of<NoteOverviewNotifier>(context);
    _noteNotifier = Provider.of<NoteNotifier>(context);
  }

  Widget _buildWidget() {
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
}