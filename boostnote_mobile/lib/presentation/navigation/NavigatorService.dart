import 'package:boostnote_mobile/business_logic/model/Folder.dart';
import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/presentation/screens/editor/markdown_editor/MarkdownEditor.dart';
import 'package:boostnote_mobile/presentation/screens/editor/snippet_editor/CodeSnippetEditor.dart';
import 'package:boostnote_mobile/presentation/screens/note_overview/Overview.dart';
import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveChild.dart';
import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveWidget.dart';
import 'package:flutter/material.dart';

class NavigatorService {

  NoteService _noteService;

  static final NavigatorService navigationService = NavigatorService._internal();

  NavigatorService._internal(){
    _noteService = NoteService();
  }

  factory NavigatorService(){
    return navigationService;
  }

  void openNote(BuildContext context, Note note) {
    _noteService.findNotTrashed().then((notes) {
      Route route = PageRouteBuilder( 
        pageBuilder: (c, a1, a2) =>  ResponsiveWidget(widgets: <ResponsiveChild> [
          ResponsiveChild(
            smallFlex: 1, 
            largeFlex: 2, 
            child: Overview(notes: notes)
          ),
          ResponsiveChild(
            smallFlex: 0, 
            largeFlex: 3, 
            child: note is MarkdownNote 
              ? MarkdownEditor(note) 
              : CodeSnippetEditor(note)
          )
          ]
        ),
        transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
        transitionDuration: Duration(milliseconds: 0),
      );
      Navigator.of(context).pushReplacement(
        route
      );
    });
  }

  void closeNote(BuildContext context) {
     Navigator.of(context).pop();
  }

  void openNoteOverview(){

  }

  void openFolderOveriew(){

  }

  void openFolder(Folder folder){

  }

  void openTagOverview(){

  }

  void openNotesWithTag(){

  }

  void openTrash() {

  }

  void openStarred() {

  }

  void openSettings() {
    
  }

  void openAbout() {

  }

}