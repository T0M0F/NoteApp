import 'package:boostnote_mobile/business_logic/model/Folder.dart';
import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:boostnote_mobile/business_logic/service/FolderService.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/presentation/navigation/NavigationService.dart';
import 'package:boostnote_mobile/presentation/screens/note_overview/Refreshable.dart';
import 'package:boostnote_mobile/presentation/widgets/NavigationDrawer.dart';
import 'package:boostnote_mobile/presentation/widgets/appbar/FolderOverviewAppbar.dart';
import 'package:boostnote_mobile/presentation/widgets/bottom_sheets/FolderOverviewBottomSheet.dart';
import 'package:boostnote_mobile/presentation/widgets/bottom_sheets/FolderOverviewErrorBottomSheet.dart';
import 'package:boostnote_mobile/presentation/widgets/buttons/CreateNoteFloatingActionButton.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/CreateFolderDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/NewNoteDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/RenameFolderDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/folderlist/FolderList.dart';
import 'package:flutter/material.dart';


class FolderOverview extends StatefulWidget {

  @override
  _FolderOverviewState createState() => _FolderOverviewState();

}

class _FolderOverviewState extends State<FolderOverview> implements Refreshable {

  NoteService _noteService;
  FolderService _folderService;
  NavigationService _newNavigationService;
  List<Folder> _folders;

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _folders = List();
    _noteService = NoteService();
    _newNavigationService = NavigationService();
    _folderService = FolderService();

    _folderService.findAllUntrashed().then((folders) {
      setState(() {
        _folders = folders;
      });
    });
  }

  @override
  void refresh() {
    _folderService.findAllUntrashed().then((folders) {
      setState(() {
        if (_folders != null) {
          _folders.replaceRange(0, _folders.length, folders);
        } else {
          _folders = folders;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    key: _drawerKey,
    appBar: FolderOverviewAppbar(
     
    
    ),
    drawer: NavigationDrawer(),
    body: _buildBody(context),
    floatingActionButton: CreateNoteFloatingActionButton(onPressed: () => _createNoteDialog())
  );

  Widget _buildBody(BuildContext context) {
    return Container(
        child: FolderList()
    );
  }

  void _createNoteDialog() => showDialog(
    context: context,
    builder: (context) {
      return CreateNoteDialog( );
  });
  
}



