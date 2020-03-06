
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/presentation/screens/note_overview/Overview.dart';

class TrashOverview extends Overview {   //TODO imutable

//title etc for TrashOverview to keep Overview as dumb as possible

  TrashOverview({List<Note> notes}) : super(notes: notes);

}
