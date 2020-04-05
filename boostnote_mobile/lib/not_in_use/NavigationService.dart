
import 'package:boostnote_mobile/business_logic/model/Folder.dart';
import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/presentation/screens/folder_overview/FolderOverview.dart';
import 'package:boostnote_mobile/presentation/screens/editor/markdown_editor/MarkdownEditor.dart';
import 'package:boostnote_mobile/presentation/screens/note_overview/Overview.dart';
import 'package:boostnote_mobile/presentation/screens/note_overview/OverviewView.dart';
import 'package:boostnote_mobile/presentation/screens/editor/snippet_editor/CodeSnippetEditor.dart';
import 'package:boostnote_mobile/presentation/screens/tag_overview/TagOverview.dart';
import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveChild.dart';
import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveWidget.dart';
import 'package:flutter/material.dart';

class NavigationService {

  String navigationMode;
  bool noteIsOpen;

  List<Note> noteListCache;

  NoteService _noteService;

  static final NavigationService navigationService = new NavigationService._internal();

  NavigationService._internal(){
    navigationMode = NavigationMode.ALL_NOTES_MODE;
    _noteService = NoteService();
    noteIsOpen = false;
    noteListCache = List();
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
            noteListCache = notes;
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
                  child: Scaffold(
                   appBar: AppBar(),
                   body: Container()
                  )
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
        } else {
          if(overviewView == null) throw Exception('OverviewView must be provided to navigate to ' + overviewMode +'. Current mode is ' + this.navigationMode);
          else {
            this.navigationMode = NavigationMode.ALL_NOTES_MODE;
            _noteService.findNotTrashed().then((notes) {
              noteListCache = notes;
              overviewView.update(notes);
            });
          }
        }
        break;

      case NavigationMode.TRASH_MODE:
        if(this.navigationMode == NavigationMode.FOLDERS_MODE || this.navigationMode == NavigationMode.TAGS_MODE) {
          this.navigationMode = NavigationMode.TRASH_MODE;
          _noteService.findTrashed().then((notes) {
            noteListCache = notes;
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
                  child: Scaffold(
                   appBar: AppBar(),
                   body: Container()
                  )
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
        } else {
          if(overviewView == null) throw Exception('OverviewView must be provided to navigate to ' + overviewMode +'. Current mode is ' + this.navigationMode);
          else {
            this.navigationMode = NavigationMode.TRASH_MODE;
            _noteService.findTrashed().then((notes) {
              noteListCache = notes;
              overviewView.update(notes);
            });
          }
        }
        break;

      case NavigationMode.STARRED_NOTES_MODE:
        if(this.navigationMode == NavigationMode.FOLDERS_MODE || this.navigationMode == NavigationMode.TAGS_MODE) {
          this.navigationMode = NavigationMode.STARRED_NOTES_MODE;
            _noteService.findStarred().then((notes) {
              noteListCache = notes;
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
                    child: Scaffold(
                    appBar: AppBar(),
                    body: Container()
                    )
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
        } else {
          if(overviewView == null) throw Exception('OverviewView must be provided to navigate to ' + overviewMode +'. Current mode is ' + this.navigationMode);
          else {
            this.navigationMode = NavigationMode.STARRED_NOTES_MODE;
            _noteService.findStarred().then((notes) {
              noteListCache = notes;
              overviewView.update(notes);
            });
          }
        }
        break;

      case NavigationMode.FOLDERS_MODE:
        this.navigationMode = NavigationMode.FOLDERS_MODE;
        Route route = PageRouteBuilder( 
          pageBuilder: (c, a1, a2) =>  ResponsiveWidget(widgets: <ResponsiveChild> [
                ResponsiveChild(
                  smallFlex: 1, 
                  largeFlex: 2, 
                  child: FolderOverview()
                ),
                ResponsiveChild(
                  smallFlex: 0, 
                  largeFlex: 3, 
                  child: Scaffold(
                   appBar: AppBar(),
                   body: Container()
                  )
                )
               ]
              ),
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
            noteListCache = notes;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ResponsiveWidget(widgets: <ResponsiveChild> [
                      ResponsiveChild(
                        smallFlex: 1, 
                        largeFlex: 2, 
                        child: Overview(notes: notes, selectedFolder: folder)
                      ),
                      ResponsiveChild(
                        smallFlex: 0, 
                        largeFlex: 3, 
                        child: Scaffold(
                        appBar: AppBar(),
                        body: Container()
                        )
                      )
                    ]
                  ),
                )
            );
         });
        break;

      case NavigationMode.TAGS_MODE:
        this.navigationMode = NavigationMode.TAGS_MODE;
        Route route = PageRouteBuilder( 
              pageBuilder: (c, a1, a2) => ResponsiveWidget(widgets: <ResponsiveChild> [
                ResponsiveChild(
                  smallFlex: 1, 
                  largeFlex: 2, 
                  child: TagOverview()
                ),
                ResponsiveChild(
                  smallFlex: 0, 
                  largeFlex: 3, 
                  child: Scaffold(
                   appBar: AppBar(),
                   body: Container()
                  )
                )
               ]
              ),
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
            noteListCache = notes;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ResponsiveWidget(widgets: <ResponsiveChild> [
                      ResponsiveChild(
                        smallFlex: 1, 
                        largeFlex: 2, 
                        child: Overview(notes: notes, selectedTag: tag)
                      ),
                      ResponsiveChild(
                        smallFlex: 0, 
                        largeFlex: 3, 
                        child: Scaffold(
                        appBar: AppBar(),
                        body: Container()
                        )
                      )
                    ]
                  ),
                )
            );
         });
        break;

      default:
        Navigator.pushNamed(context, '/');
        break;
    }
  } 

  void openNoteResponsive(List<Note> notes, Note note,  BuildContext context) { //TODO isTablet remove?
   /* noteIsOpen = true;
    Widget editor = note is MarkdownNote
        ? MarkdownEditor()
        : CodeSnippetEditor();

    Widget responisveWidget = ResponsiveWidget(widgets: <ResponsiveChild> [
     ResponsiveChild(
       smallFlex: 0, 
       largeFlex: 2, 
       child: Overview(notes: notes)
      ),
      ResponsiveChild(
       smallFlex: 1, 
       largeFlex: 3, 
       child: editor
      )
    ]
   );
   
   Route route = PageRouteBuilder( 
            pageBuilder: (c, a1, a2) =>  responisveWidget,
            transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
            transitionDuration: Duration(milliseconds: 0),
          );
   Navigator.of(context).push(route);*/
  }

  void openNote(Note note,  BuildContext context) {
    openNoteResponsive(noteListCache, note, context);
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

