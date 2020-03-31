import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/presentation/BoostnoteApp.dart';
import 'package:boostnote_mobile/presentation/notifiers/MarkdownEditorNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteOverviewNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/SnippetNotifier.dart';
import 'package:boostnote_mobile/presentation/theme/ThemeNotifier.dart';
import 'package:boostnote_mobile/presentation/theme/ThemeService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  ThemeService().getThemeData().then((themeData){
    NoteService().findNotTrashed().then((notes){
      runApp(
      MultiProvider(
        providers: [
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
          )
        ],
        child: BoostnoteApp()
    ));
    });
  });
}


