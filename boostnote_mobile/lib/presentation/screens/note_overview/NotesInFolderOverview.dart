import 'package:boostnote_mobile/business_logic/model/Folder.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/presentation/screens/note_overview/Overview.dart';

class NotesInFolderOverview extends Overview {

  //title etc for StarredOverview to keep Overview as dumb as possible

  NotesInFolderOverview({List<Note> notes, Folder selectedFolder}) : super(notes: notes, selectedFolder: selectedFolder);
  
}