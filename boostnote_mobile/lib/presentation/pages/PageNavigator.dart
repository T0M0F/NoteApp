import 'package:boostnote_mobile/business_logic/model/Folder.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:boostnote_mobile/presentation/pages/FoldersPage.dart';
import 'package:boostnote_mobile/presentation/pages/NotesPage.dart';
import 'package:boostnote_mobile/presentation/pages/TagsPage.dart';
import 'package:boostnote_mobile/presentation/screens/settings/Settings.dart';
import 'package:flutter/material.dart';

class PageNavigator {

  NoteService _noteService = NoteService();
  PageNavigatorState pageNavigatorState;

  static final PageNavigator navigationService = new PageNavigator._internal();

  PageNavigator._internal(){}

  factory PageNavigator(){
    return navigationService;
  }

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
      Navigator.of(context).push(
        route
      );
    });
  }

  void navigateToNotesInFolder(BuildContext context, Folder folder, {Note note}){
    pageNavigatorState = PageNavigatorState.NOTES_IN_FOLDER;
    _noteService.findNotesIn(folder).then((notes){
      Route route = PageRouteBuilder( 
        pageBuilder: (c, a1, a2) => NotesPage(
          pageTitle: folder.name,
          note: note,
          notes: notes,
          folder: folder
        ),
        transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
        transitionDuration: Duration(milliseconds: 0),
      );
      Navigator.of(context).push(
        route
      );
    });
  }

  void navigateToNotesWithTag(BuildContext context, String tag, {Note note}){
    pageNavigatorState = PageNavigatorState.NOTES_WITH_TAG;
    _noteService.findNotesByTag(tag).then((notes){
      Route route = PageRouteBuilder( 
        pageBuilder: (c, a1, a2) => NotesPage(
          pageTitle: tag,
          note: note,
          notes: notes,
          tag: tag
        ),
        transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
        transitionDuration: Duration(milliseconds: 0),
      );
      Navigator.of(context).push(
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
      Navigator.of(context).push(
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
      Navigator.of(context).push(
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
    Navigator.of(context).push(
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
    Navigator.of(context).push(
      route
    );
  }

  void navigateToSettings(BuildContext context) {
    pageNavigatorState = PageNavigatorState.TAGS;
    Route route = PageRouteBuilder( 
      pageBuilder: (c, a1, a2) => Settings(),
      transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
      transitionDuration: Duration(milliseconds: 0),
    );
    Navigator.of(context).push(
      route
    );
  }

}

  enum PageNavigatorState {
    ALL_NOTES,
    NOTES_IN_FOLDER,
    NOTES_WITH_TAG,
    FOLDERS,
    TAGS,
    STARRED,
    TRASH,
    SETTINGS,
    ABOUT
  }