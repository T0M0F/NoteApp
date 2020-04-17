import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/presentation/navigation/PageNavigator.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteOverviewNotifier.dart';
import 'package:boostnote_mobile/presentation/pages/notes/widgets/DeleteNoteBottomSheet.dart';
import 'package:boostnote_mobile/presentation/pages/notes/widgets/TrashNoteBottomSheet.dart';
import 'package:boostnote_mobile/presentation/pages/notes/widgets/noteslist/NoteTile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList>{

  NoteOverviewNotifier _noteOverviewNotifier;
  NoteNotifier _noteNotifier;

  @override
  Widget build(BuildContext context) {
    _initNotifiers(context);
    return _buildList(context);
  }

  void _initNotifiers(BuildContext context) {
    _noteOverviewNotifier = Provider.of<NoteOverviewNotifier>(context);
    _noteNotifier = Provider.of<NoteNotifier>(context);
  }
  
  Widget _buildList(BuildContext context) => ListView.builder(
    itemCount: _noteOverviewNotifier.notes.length,
    itemBuilder: (context, index) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => _onTap(_noteOverviewNotifier.notes[index]),
        onLongPress: () => _onLongPress(_noteOverviewNotifier.notes[index]),
        child: NoteTile(note: _noteOverviewNotifier.notes[index])
      );
    },
  );

  void _onTap(Note note) {
    _noteNotifier.note = note;
  }

  void _onLongPress(Note note) {
    _noteOverviewNotifier.selectedNote = note;
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

