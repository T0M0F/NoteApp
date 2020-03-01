import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/presentation/NavigationService.dart';
import 'package:boostnote_mobile/presentation/screens/note_overview/Overview.dart';
import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveChild.dart';
import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveWidget.dart';
import 'package:flutter/material.dart';

class NewNavigationService {

  List<List<ResponsiveChild>> widgetHistory;
  List<String> navigationModeHistory;
  ResponsiveWidgetState responsiveWidget;

  static final NewNavigationService navigationService = new NewNavigationService._internal();

  NewNavigationService._internal(){
    widgetHistory = List();
    navigationModeHistory = List();
  }

  void init(ResponsiveWidgetState responsiveWidgetState) {
    this.responsiveWidget = responsiveWidgetState;
  }

  factory NewNavigationService(){
    return navigationService;
  }

  void navigateTo({@required ResponsiveChild destinationWidget,@required String destinationMode}) {
    //check if destinationMode is known

    List<ResponsiveChild> widgets = List();
    widgets.addAll(responsiveWidget.widgets);

    switch(destinationMode) {
      case NavigationMode2.TRASH_MODE:
        widgets.first = destinationWidget;
        break;
      case NavigationMode2.TAGS_MODE:
        widgets.first = destinationWidget;
        break;
      default:
        widgets.first = destinationWidget;
        break;
    }

    widgetHistory.add(widgets);
    navigationModeHistory.add(destinationMode);
    NavigationService().navigationMode = destinationMode;
    responsiveWidget.update(widgets);
  } 

  void navigateBack() {
    print('back');
    widgetHistory.removeLast();
    navigationModeHistory.removeLast();
    NavigationService().navigationMode = navigationModeHistory.last;
    responsiveWidget.update(widgetHistory.last);
  }
}

abstract class NavigationMode2 {

  static const String TRASH_MODE =  'Trashed Notes';
  static const String ALL_NOTES_MODE = 'All Notes';
  static const String STARRED_NOTES_MODE = 'Starred Notes';
  static const String FOLDERS_MODE = 'Folders';
  static const String NOTES_IN_FOLDER_MODE = 'Notes in Folder';
  static const String TAGS_MODE = 'Tags'; 
  static const String NOTES_WITH_TAG_MODE = 'Notes with Tag';

}