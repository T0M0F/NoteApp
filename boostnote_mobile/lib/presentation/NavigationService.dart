
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/presentation/screens/folder_overview/FolderOverview.dart';
import 'package:boostnote_mobile/presentation/screens/overview/Overview.dart';
import 'package:boostnote_mobile/presentation/screens/overview/OverviewView.dart';
import 'package:boostnote_mobile/presentation/screens/tag_overview/TagOverview.dart';
import 'package:flutter/material.dart';

class NavigationService {

  String overviewMode;

  NoteService _noteService;

  static final NavigationService navigationService = new NavigationService._internal();

  NavigationService._internal(){
    overviewMode = OverviewMode.ALL_NOTES_MODE;
    _noteService = NoteService();
  }

  factory NavigationService(){
    return navigationService;
  }

  void navigateTo( BuildContext context, String overviewMode, {OverviewView overviewView}) {
    switch (overviewMode) {

      case OverviewMode.ALL_NOTES_MODE:
        if(this.overviewMode == OverviewMode.FOLDERS_MODE || this.overviewMode == OverviewMode.TAGS_MODE) {
          this.overviewMode = OverviewMode.ALL_NOTES_MODE;
          _noteService.findNotTrashed().then((notes) {
            Route route = PageRouteBuilder( 
              pageBuilder: (c, a1, a2) =>  Overview(notes: notes),
              transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: 0),
            );
            Navigator.of(context).pushReplacement(
              route
            );
          });
        } else {
          if(overviewView == null) throw Exception('OverviewView must be provided to navigate to ' + overviewMode +'. Current mode is ' + this.overviewMode);
          else {
            this.overviewMode = OverviewMode.ALL_NOTES_MODE;
            _noteService.findNotTrashed().then((notes) => overviewView.update(notes));
          }
        }
     
        break;

      case OverviewMode.TRASH_MODE:
        if(this.overviewMode == OverviewMode.FOLDERS_MODE || this.overviewMode == OverviewMode.TAGS_MODE) {
          this.overviewMode = OverviewMode.TRASH_MODE;
          _noteService.findNotTrashed().then((notes) {
            Route route = PageRouteBuilder( 
              pageBuilder: (c, a1, a2) =>  Overview(notes: notes),
              transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: 0),
            );
            Navigator.of(context).pushReplacement(
              route
            );
          });
        } else {
          if(overviewView == null) throw Exception('OverviewView must be provided to navigate to ' + overviewMode +'. Current mode is ' + this.overviewMode);
          else {
            this.overviewMode = OverviewMode.TRASH_MODE;
            _noteService.findTrashed().then((notes) => overviewView.update(notes));
          }
        }
        break;

      case OverviewMode.STARRED_NOTES_MODE:
        if(this.overviewMode == OverviewMode.FOLDERS_MODE || this.overviewMode == OverviewMode.TAGS_MODE) {
          this.overviewMode = OverviewMode.STARRED_NOTES_MODE;
          _noteService.findStarred().then((notes) {
            Route route = PageRouteBuilder( 
              pageBuilder: (c, a1, a2) =>  Overview(notes: notes),
              transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: 0),
            );
            Navigator.of(context).pushReplacement(
              route
            );
          });
        } else {
          if(overviewView == null) throw Exception('OverviewView must be provided to navigate to ' + overviewMode +'. Current mode is ' + this.overviewMode);
          else {
            this.overviewMode = OverviewMode.STARRED_NOTES_MODE;
            _noteService.findStarred().then((notes) => overviewView.update(notes));
          }
        }
        break;

      case OverviewMode.FOLDERS_MODE:
        this.overviewMode = OverviewMode.FOLDERS_MODE;
        Route route = PageRouteBuilder( 
          pageBuilder: (c, a1, a2) =>  FolderOverview(),
          transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
          transitionDuration: Duration(milliseconds: 0),
        );
        Navigator.of(context).pushReplacement(
          route
        );
        break;

      case OverviewMode.NOTES_IN_FOLDER_MODE:
        if(this.overviewMode == OverviewMode.FOLDERS_MODE || this.overviewMode == OverviewMode.TAGS_MODE) {

        } else {
          
        }

        break;

      case OverviewMode.TAGS_MODE:
        this.overviewMode = OverviewMode.TAGS_MODE;
        Route route = PageRouteBuilder( 
              pageBuilder: (c, a1, a2) =>  TagOverview(),
              transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: 0),
            );
        Navigator.of(context).pushReplacement(
          route
        );
        break;

      case OverviewMode.NOTES_WITH_TAG_MODE:

        break;

      default:
        Navigator.pushNamed(context, '/AllNotes');
        break;
    }

  }

  bool isAllNotesMode() => overviewMode == OverviewMode.ALL_NOTES_MODE;

  bool isTrashMode() => overviewMode == OverviewMode.TRASH_MODE;

  bool isStarredNotesMode() => overviewMode == OverviewMode.STARRED_NOTES_MODE;

  bool isFoldersMode() => overviewMode == OverviewMode.FOLDERS_MODE;

  bool isNotesInFolderMode() => overviewMode == OverviewMode.NOTES_IN_FOLDER_MODE;

  bool isTagsMode() => overviewMode == OverviewMode.TAGS_MODE;

  bool isNotesWithTagMode() => overviewMode == OverviewMode.NOTES_WITH_TAG_MODE;

}

abstract class OverviewMode {

  static const String TRASH_MODE =  'Trashed Notes';
  static const String ALL_NOTES_MODE = 'All Notes';
  static const String STARRED_NOTES_MODE = 'Starred Notes';
  static const String FOLDERS_MODE = 'Folders';
  static const String NOTES_IN_FOLDER_MODE = 'Notes in Folder';
  static const String TAGS_MODE = 'Tags'; 
  static const String NOTES_WITH_TAG_MODE = 'Notes with Tag';

}

