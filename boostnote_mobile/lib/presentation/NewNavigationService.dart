import 'package:boostnote_mobile/business_logic/model/Folder.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/presentation/NavigationService.dart';
import 'package:boostnote_mobile/presentation/screens/folder_overview/FolderOverview.dart';
import 'package:boostnote_mobile/presentation/screens/markdown_editor/MarkdownEditor.dart';
import 'package:boostnote_mobile/presentation/screens/note_overview/NotesInFolderOverview.dart';
import 'package:boostnote_mobile/presentation/screens/note_overview/NotesWithTagOverview.dart';
import 'package:boostnote_mobile/presentation/screens/note_overview/Overview.dart';
import 'package:boostnote_mobile/presentation/screens/note_overview/Refreshable.dart';
import 'package:boostnote_mobile/presentation/screens/note_overview/StarredOverview.dart';
import 'package:boostnote_mobile/presentation/screens/note_overview/TrashOverview.dart';
import 'package:boostnote_mobile/presentation/screens/settings/Settings.dart';
import 'package:boostnote_mobile/presentation/screens/snippet_editor/CodeSnippetEditor.dart';
import 'package:boostnote_mobile/presentation/screens/tag_overview/TagOverview.dart';
import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveChild.dart';
import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewNavigationService {

  /*TODO
  Problem: wenn zu trash oder starred navigiert wird, wird init nicht aufgerufen
    Open NOte from Dialog
    Folder und TagOverview
    Navigate Back wenn mehrfach gepresset
    Tablet testen
    Manchmal Exception??
    Manchmal lädt notes für overview nicht richtig
   */

  List<List<ResponsiveChild>> widgetHistory;
  List<String> navigationModeHistory;
  bool noteIsOpen;
  ResponsiveWidgetState responsiveWidget;
  NoteService _noteService;

  static final NewNavigationService navigationService = new NewNavigationService._internal();

  NewNavigationService._internal(){
    widgetHistory = List();
    navigationModeHistory = List();
    _noteService = NoteService();
    noteIsOpen = false;
  }

  factory NewNavigationService(){
    return navigationService;
  }

  void init(ResponsiveWidgetState responsiveWidgetState) {
    this.responsiveWidget = responsiveWidgetState;
  }

  void navigateTo({@required String destinationMode, Folder folder, String tag, Note note}) {
    //check if destinationMode is known

    switch(destinationMode) {
      case NavigationMode2.TRASH_MODE:
        _noteService.findTrashed().then((notes) {
          print('Trash note lenght: ' + notes.length.toString());
           ResponsiveChild widget = ResponsiveChild(
              smallFlex: 1, 
              largeFlex: 2, 
              child: TrashOverview(notes: notes)
           );
           navigate(destinationWidget:  widget, destinationMode: destinationMode);
        });
        break;
      case NavigationMode2.TAGS_MODE:
        ResponsiveChild widget = ResponsiveChild(
          smallFlex: 1, 
          largeFlex: 2, 
          child: TagOverview()
        );
        navigate(destinationWidget:  widget, destinationMode: destinationMode);
        break;
      case NavigationMode2.ALL_NOTES_MODE:
        _noteService.findNotTrashed().then((notes) {
           ResponsiveChild widget = ResponsiveChild(
              smallFlex: 1, 
              largeFlex: 2, 
              child: Overview(notes: notes)
           );
           navigate(destinationWidget:  widget, destinationMode: destinationMode);
        });
        break;
      case NavigationMode2.FOLDERS_MODE:
        ResponsiveChild widget = ResponsiveChild(
          smallFlex: 1, 
          largeFlex: 2, 
          child: FolderOverview()
        );
        navigate(destinationWidget:  widget, destinationMode: destinationMode);
        break;
      case NavigationMode2.STARRED_NOTES_MODE:
        _noteService.findStarred().then((notes) {
           ResponsiveChild widget = ResponsiveChild(
              smallFlex: 1, 
              largeFlex: 2, 
              child: StarredOverview(notes: notes)
           );
           navigate(destinationWidget:  widget, destinationMode: destinationMode);
        });
        break;
      case NavigationMode2.NOTES_IN_FOLDER_MODE:
      //check if folder is null
        _noteService.findNotesIn(folder).then((notes) {
           ResponsiveChild widget = ResponsiveChild(
              smallFlex: 1, 
              largeFlex: 2, 
              child: NotesInFolderOverview(notes: notes, selectedFolder: folder,)
           );
           navigate(destinationWidget:  widget, destinationMode: destinationMode);
        });
       break;
      case NavigationMode2.NOTES_WITH_TAG_MODE:
      //check if tag is null
        _noteService.findNotesByTag(tag).then((notes) {
            ResponsiveChild widget = ResponsiveChild(
              smallFlex: 1, 
              largeFlex: 2, 
              child: NotesWithTagOverview(notes: notes, selectedTag: tag)
            );
            navigate(destinationWidget:  widget, destinationMode: destinationMode);
        });
        break;
      case NavigationMode2.MARKDOWN_NOTE:
      //check if note is null or resfreshable is null
        ResponsiveChild widget = ResponsiveChild(
              smallFlex: 1, 
              largeFlex: 2, 
              child: MarkdownEditor(note)
           );
        navigate(destinationWidget:  widget, destinationMode: destinationMode);
        break;
      case NavigationMode2.SNIPPET_NOTE:
      //check if note is null or resfreshable is null
        ResponsiveChild widget = ResponsiveChild(
              smallFlex: 1, 
              largeFlex: 2, 
              child: CodeSnippetEditor(note)
           );
        navigate(destinationWidget:  widget, destinationMode: destinationMode);
        break;
      case NavigationMode2.SETTINGS_MODE:
        ResponsiveChild widget = ResponsiveChild(
          smallFlex: 1, 
          largeFlex: 1, 
          child: Settings()
        );
        navigate(destinationWidget:  widget, destinationMode: destinationMode);
        break;
    }
  } 

  void navigate({@required ResponsiveChild destinationWidget,@required String destinationMode}) {
    //check if destinationMode is known
    List<ResponsiveChild> widgets = List();
    if(destinationMode == NavigationMode2.SETTINGS_MODE) {
      widgets.add(destinationWidget);
      navigationModeHistory.add(destinationMode);
    } else {
      widgets.addAll(responsiveWidget.widgets);
      if(destinationMode == NavigationMode2.SNIPPET_NOTE || destinationMode == NavigationMode2.MARKDOWN_NOTE) {
        widgets.first = ResponsiveChild(smallFlex: 0, largeFlex:  widgets.first.largeFlex, child:  widgets.first.child);
        widgets[1] = destinationWidget;
        noteIsOpen = true;
      } else {
        widgets.first = destinationWidget;
        navigationModeHistory.add(destinationMode);
      }
    }
    
    widgetHistory.add(widgets);
    //NavigationService().navigationMode = destinationMode; //delete
    responsiveWidget.update(widgets);
  }

  void navigateBack(BuildContext context) {
    widgetHistory.removeLast();

    if(noteIsOpen){
      noteIsOpen = false;
    } else {
      navigationModeHistory.removeLast();
    }

    if(widgetHistory.isNotEmpty) {
     // NavigationService().navigationMode = navigationModeHistory.last;  //delete
      responsiveWidget.update(widgetHistory.last);
    } else {
      SystemNavigator.pop();
    }
  }

  bool isAllNotesMode() => navigationModeHistory.last == NavigationMode2.ALL_NOTES_MODE;

  bool isTrashMode() => navigationModeHistory.last == NavigationMode2.TRASH_MODE;

  bool isStarredNotesMode() => navigationModeHistory.last == NavigationMode2.STARRED_NOTES_MODE;

  bool isFoldersMode() => navigationModeHistory.last == NavigationMode2.FOLDERS_MODE;

  bool isNotesInFolderMode() => navigationModeHistory.last == NavigationMode2.NOTES_IN_FOLDER_MODE;

  bool isTagsMode() => navigationModeHistory.last == NavigationMode2.TAGS_MODE;

  bool isNotesWithTagMode() => navigationModeHistory.last == NavigationMode2.NOTES_WITH_TAG_MODE;

  bool isNoteOpen() => noteIsOpen;
}

abstract class NavigationMode2 {

  static const String TRASH_MODE = 'Trashed Notes';
  static const String ALL_NOTES_MODE = 'All Notes';
  static const String STARRED_NOTES_MODE = 'Starred Notes';
  static const String FOLDERS_MODE = 'Folders';
  static const String NOTES_IN_FOLDER_MODE = 'Notes in Folder';
  static const String TAGS_MODE = 'Tags'; 
  static const String NOTES_WITH_TAG_MODE = 'Notes with Tag';
  static const String SNIPPET_NOTE = 'Snippet Note';
  static const String MARKDOWN_NOTE = 'Markdown Note';
  static const String SETTINGS_MODE = 'Settings';

}