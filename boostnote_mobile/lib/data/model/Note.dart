abstract class Note {

  final DateTime createdAt;
  DateTime updatedAt;
  String folder; //im wiki nach gucken, wie wert generiert wird + evtl extra Klasse
  String title;
  List<String> tags;
  bool isStarred;
  bool isTrashed;

  Note({this.createdAt, 
        this.updatedAt, 
        this.folder, 
        this.title, 
        this.tags, 
        this.isStarred, 
        this.isTrashed});

}