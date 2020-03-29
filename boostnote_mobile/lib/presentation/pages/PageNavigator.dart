import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:boostnote_mobile/presentation/pages/FoldersPage.dart';
import 'package:boostnote_mobile/presentation/pages/NotesPage.dart';
import 'package:boostnote_mobile/presentation/pages/TagsPage.dart';
import 'package:flutter/material.dart';

class PageNavigator {

  NoteService _noteService = NoteService();
  PageNavigatorState pageNavigatorState;

  void navigateToAllNotes(BuildContext context, {Note note}){
    pageNavigatorState = PageNavigatorState.ALL_NOTES;
    _noteService.findNotTrashed().then((notes){
      Route route = PageRouteBuilder( 
        pageBuilder: (c, a1, a2) => NotesPage(
          pageTitle: AppLocalizations.of(context).translate('all_notes'),
          note: note,
          notes: notes,),
        transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
        transitionDuration: Duration(milliseconds: 0),
      );
      Navigator.of(context).pushReplacement(
        route
      );
    });
  }

  void navigateToStarredNotes(BuildContext context, {Note note}){
    pageNavigatorState = PageNavigatorState.STARRED;
    _noteService.findStarred().then((notes){
      Route route = PageRouteBuilder( 
        pageBuilder: (c, a1, a2) => NotesPage(
          pageTitle: AppLocalizations.of(context).translate('starredNotes'),
          note: note,
          notes: notes,),
        transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
        transitionDuration: Duration(milliseconds: 0),
      );
      Navigator.of(context).pushReplacement(
        route
      );
    });
  }

  void navigateToTrash(BuildContext context, {Note note}){
    pageNavigatorState = PageNavigatorState.TRASH;
    _noteService.findTrashed().then((notes){
      Route route = PageRouteBuilder( 
        pageBuilder: (c, a1, a2) => NotesPage(
          pageTitle: AppLocalizations.of(context).translate('trash'),
          note: note,
          notes: notes,),
        transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
        transitionDuration: Duration(milliseconds: 0),
      );
      Navigator.of(context).pushReplacement(
        route
      );
    });
  }

  void navigateToFolders(BuildContext context, {Note note}){
    pageNavigatorState = PageNavigatorState.FOLDERS;
    Route route = PageRouteBuilder( 
        pageBuilder: (c, a1, a2) => FoldersPage(note: note),
        transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
        transitionDuration: Duration(milliseconds: 0),
      );
      Navigator.of(context).pushReplacement(
        route
      );
  }

  void navigateToTags(BuildContext context, {Note note}){
    pageNavigatorState = PageNavigatorState.TAGS;
    Route route = PageRouteBuilder( 
        pageBuilder: (c, a1, a2) => TagsPage(note: note),
        transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
        transitionDuration: Duration(milliseconds: 0),
      );
      Navigator.of(context).pushReplacement(
        route
      );
  }

}

  enum PageNavigatorState {
    ALL_NOTES,
    FOLDERS,
    TAGS,
    STARRED,
    TRASH,
    SETTINGS,
    ABOUT
  }