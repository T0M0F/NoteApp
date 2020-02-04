
import 'package:boostnote_mobile/business_logic/model/Folder.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/presentation/screens/folder_overview/FolderOverview.dart';
import 'package:boostnote_mobile/presentation/screens/overview/Overview.dart';
import 'package:boostnote_mobile/presentation/screens/overview/OverviewView.dart';
import 'package:boostnote_mobile/presentation/screens/tag_overview/TagOverview.dart';
import 'package:flutter/material.dart';

class NavigationService {

  String navigationMode;
  bool noteIsOpen;

  NoteService _noteService;

  static final NavigationService navigationService = new NavigationService._internal();

  NavigationService._internal(){
    navigationMode = NavigationMode.ALL_NOTES_MODE;
    _noteService = NoteService();
    noteIsOpen = false;
  }

  factory NavigationService(){
    return navigationService;
  }

  void navigateTo( BuildContext context, String overviewMode, {OverviewView overviewView, Folder folder, String tag}) {
    switch (overviewMode) {

      case NavigationMode.ALL_NOTES_MODE:
        if(this.navigationMode == NavigationMode.FOLDERS_MODE || this.navigationMode == NavigationMode.TAGS_MODE) {
          this.navigationMode = NavigationMode.ALL_NOTES_MODE;
          _noteService.findNotTrashed().then((notes) {
            print(notes.length);
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
          if(overviewView == null) throw Exception('OverviewView must be provided to navigate to ' + overviewMode +'. Current mode is ' + this.navigationMode);
          else {
            this.navigationMode = NavigationMode.ALL_NOTES_MODE;
            _noteService.findNotTrashed().then((notes) => overviewView.update(notes));
          }
        }
        break;

      case NavigationMode.TRASH_MODE:
        if(this.navigationMode == NavigationMode.FOLDERS_MODE || this.navigationMode == NavigationMode.TAGS_MODE) {
          this.navigationMode = NavigationMode.TRASH_MODE;
          _noteService.findTrashed().then((notes) {
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
          if(overviewView == null) throw Exception('OverviewView must be provided to navigate to ' + overviewMode +'. Current mode is ' + this.navigationMode);
          else {
            this.navigationMode = NavigationMode.TRASH_MODE;
            _noteService.findTrashed().then((notes) => overviewView.update(notes));
          }
        }
        break;

      case NavigationMode.STARRED_NOTES_MODE:
        if(this.navigationMode == NavigationMode.FOLDERS_MODE || this.navigationMode == NavigationMode.TAGS_MODE) {
          this.navigationMode = NavigationMode.STARRED_NOTES_MODE;
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
          if(overviewView == null) throw Exception('OverviewView must be provided to navigate to ' + overviewMode +'. Current mode is ' + this.navigationMode);
          else {
            this.navigationMode = NavigationMode.STARRED_NOTES_MODE;
            _noteService.findStarred().then((notes) => overviewView.update(notes));
          }
        }
        break;

      case NavigationMode.FOLDERS_MODE:
        this.navigationMode = NavigationMode.FOLDERS_MODE;
        Route route = PageRouteBuilder( 
          pageBuilder: (c, a1, a2) =>  FolderOverview(),
          transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
          transitionDuration: Duration(milliseconds: 0),
        );
        Navigator.of(context).pushReplacement(
          route
        );
        break;

      case NavigationMode.NOTES_IN_FOLDER_MODE:
          this.navigationMode = NavigationMode.NOTES_IN_FOLDER_MODE;
          _noteService.findUntrashedNotesIn(folder).then((notes) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Overview(notes: notes, selectedFolder: folder)
                )
            );
         });
        break;

      case NavigationMode.TAGS_MODE:
        this.navigationMode = NavigationMode.TAGS_MODE;
        Route route = PageRouteBuilder( 
              pageBuilder: (c, a1, a2) =>  TagOverview(),
              transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: 0),
            );
        Navigator.of(context).pushReplacement(
          route
        );
        break;

      case NavigationMode.NOTES_WITH_TAG_MODE:
          this.navigationMode = NavigationMode.NOTES_WITH_TAG_MODE;
          _noteService.findNotesByTag(tag).then((notes) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Overview(notes: notes, selectedTag: tag)
                )
            );
         });
        break;
      default:
        Navigator.pushNamed(context, '/AllNotes');
        break;
    }
  } 

  void openNote(Note note) {
    noteIsOpen = true;
  }

  void closeNote(BuildContext context){
    navigateBack(context);
    noteIsOpen = false;
  }

  void navigateBack(BuildContext context) {
    print('navigatBack');
    if(!noteIsOpen) {
      switch(navigationMode) {
        case NavigationMode.NOTES_IN_FOLDER_MODE:
          print('NOTES_IN_FOLDER_MODE');
          navigationMode = NavigationMode.FOLDERS_MODE;
          break;
        case NavigationMode.NOTES_WITH_TAG_MODE:
          print('NOTES_WITH_TAG_MODE');
          navigationMode = NavigationMode.TAGS_MODE;
          break;
      }
    }   
    Navigator.of(context).pop();
  }

  bool isAllNotesMode() => navigationMode == NavigationMode.ALL_NOTES_MODE;

  bool isTrashMode() => navigationMode == NavigationMode.TRASH_MODE;

  bool isStarredNotesMode() => navigationMode == NavigationMode.STARRED_NOTES_MODE;

  bool isFoldersMode() => navigationMode == NavigationMode.FOLDERS_MODE;

  bool isNotesInFolderMode() => navigationMode == NavigationMode.NOTES_IN_FOLDER_MODE;

  bool isTagsMode() => navigationMode == NavigationMode.TAGS_MODE;

  bool isNotesWithTagMode() => navigationMode == NavigationMode.NOTES_WITH_TAG_MODE;

}

abstract class NavigationMode {

  static const String TRASH_MODE =  'Trashed Notes';
  static const String ALL_NOTES_MODE = 'All Notes';
  static const String STARRED_NOTES_MODE = 'Starred Notes';
  static const String FOLDERS_MODE = 'Folders';
  static const String NOTES_IN_FOLDER_MODE = 'Notes in Folder';
  static const String TAGS_MODE = 'Tags'; 
  static const String NOTES_WITH_TAG_MODE = 'Notes with Tag';

}

