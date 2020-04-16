import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/presentation/BoostnoteApp.dart';
import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:boostnote_mobile/presentation/notifiers/FolderNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/MarkdownEditorNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteOverviewNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/SnippetNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/TagsNotifier.dart';
import 'package:boostnote_mobile/presentation/themes/ThemeNotifier.dart';
import 'package:boostnote_mobile/presentation/themes/ThemeService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  ThemeService().getThemeData().then((themeData){
    NoteService().findNotTrashed().then((notes){

      runApp(
        MultiProvider(
          providers: _initProviders(themeData, notes),
          child: BoostnoteApp()
      ));

    });
  });
}

List<ChangeNotifierProvider> _initProviders(ThemeData themeData, List<Note> notes) {
  return [
    ChangeNotifierProvider<ThemeNotifier>(
      create: (context) => ThemeNotifier(themeData),
    ),
    ChangeNotifierProvider<NoteNotifier>(
      create: (context) => NoteNotifier(),
    ),
    ChangeNotifierProvider<SnippetNotifier>(
      create: (context) => SnippetNotifier(false),
    ),
    ChangeNotifierProvider<MarkdownEditorNotifier>(
      create: (context) => MarkdownEditorNotifier(false),
    ),
    ChangeNotifierProvider<NoteOverviewNotifier>(
      create: (context) => NoteOverviewNotifier.withNotes(false,true, notes),
    ),
    ChangeNotifierProvider<FolderNotifier>(
      create: (context) => FolderNotifier(),
    ),
    ChangeNotifierProvider<TagsNotifier>(
      create: (context) => TagsNotifier(),
    )
  ];
}


