import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteOverviewNotifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class NoteOverviewUpdater {

    void update(List<Note> notes, BuildContext context){
      NoteOverviewNotifier _noteOverviewNotifier = Provider.of<NoteOverviewNotifier>(context);
    
      if(_noteOverviewNotifier.notes != null){
        _noteOverviewNotifier.notes.replaceRange(0, _noteOverviewNotifier.notes.length, notes);
      } else {
        _noteOverviewNotifier.notes = notes;
      }
      _noteOverviewNotifier.notesCopy = List<Note>.from(_noteOverviewNotifier.notes);
    
  }

}