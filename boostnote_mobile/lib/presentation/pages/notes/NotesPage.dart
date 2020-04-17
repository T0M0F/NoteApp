import 'package:boostnote_mobile/presentation/notifiers/NoteOverviewNotifier.dart';
import 'package:boostnote_mobile/presentation/pages/notes/widgets/NotesPageAppbar.dart';
import 'package:boostnote_mobile/presentation/pages/notes/widgets/notesgrid/NoteGrid.dart';
import 'package:boostnote_mobile/presentation/pages/notes/widgets/noteslist/NoteList.dart';
import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveBaseAppbar.dart';
import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveBaseView.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {

  NoteOverviewNotifier _noteOverviewNotifier;

  @override
  Widget build(BuildContext context) {
    _noteOverviewNotifier = Provider.of<NoteOverviewNotifier>(context);
    return _buildWidget();
  }

  ResponsiveBaseView _buildWidget() {
    return ResponsiveBaseView(
      appBar: ResponsiveBaseAppbar(
        leftSideAppbar: NotesPageAppbar(
          notes: _noteOverviewNotifier.notesCopy,
        )
      ),
      leftSideChild: _noteOverviewNotifier.showListView ? NoteList() : NoteGrid()
    );
  }
}