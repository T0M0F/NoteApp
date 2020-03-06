import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/presentation/screens/note_overview/Overview.dart';

class StarredOverview extends Overview {

  //title etc for StarredOverview to keep Overview as dumb as possible

  StarredOverview({List<Note> notes}) : super(notes: notes);
  
}