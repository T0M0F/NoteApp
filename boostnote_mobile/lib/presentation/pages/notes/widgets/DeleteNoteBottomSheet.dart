import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteOverviewNotifier.dart';
import 'package:boostnote_mobile/presentation/pages/notes/widgets/NoteOverviewUpdater.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeleteNoteBottomSheet extends StatefulWidget {
  @override
  _DeleteNoteBottomSheetState createState() => _DeleteNoteBottomSheetState();
}

class _DeleteNoteBottomSheetState extends State<DeleteNoteBottomSheet> {

  final NoteService _noteService = NoteService();
  NoteOverviewNotifier _noteOverviewNotifier;
  NoteNotifier _noteNotifier;

  @override
  Widget build(BuildContext context) {
    _initNotifiers(context);
    return _buildWidget(context);
  }

  void _initNotifiers(BuildContext context) {
     _noteOverviewNotifier = Provider.of<NoteOverviewNotifier>(context);
    _noteNotifier = Provider.of<NoteNotifier>(context);
  }

  Container _buildWidget(BuildContext context) {
     return Container(
      child: Wrap(
        children: <Widget>[
             ListTile(
              leading: Icon(Icons.delete),
              title: Text(AppLocalizations.of(context).translate('restore_note'), style: Theme.of(context).textTheme.display1,),
              onTap: () => _restoreNote(context)
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.redAccent,),
              title: Text(AppLocalizations.of(context).translate('delete'), style: TextStyle(color: Colors.redAccent)),
              onTap: () => _deleteNote(context)
            )
        ],
      ),
    );
  }

  void _restoreNote(BuildContext context) {
     Navigator.of(context).pop();
    Note noteToBeRestored = _noteOverviewNotifier.selectedNote;
    _noteService.restore(noteToBeRestored);
    _noteOverviewNotifier.notes.remove(noteToBeRestored);
    NoteOverviewUpdater().update(_noteOverviewNotifier.notes, context);
    if(_noteNotifier.note == noteToBeRestored) _noteNotifier.note = null;
  }

  void _deleteNote(BuildContext context) {
     Navigator.of(context).pop();
    Note noteToBeDeleted = _noteOverviewNotifier.selectedNote;
    _noteService.delete(noteToBeDeleted);
    _noteOverviewNotifier.notes.remove(noteToBeDeleted);
    NoteOverviewUpdater().update(_noteOverviewNotifier.notes, context);
    if(_noteNotifier.note == noteToBeDeleted) _noteNotifier.note = null;
  }
}

