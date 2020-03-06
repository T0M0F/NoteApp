import 'package:boostnote_mobile/business_logic/model/Folder.dart';
import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:boostnote_mobile/business_logic/service/FolderService.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/presentation/NavigationService.dart';
import 'package:boostnote_mobile/presentation/NewNavigationService.dart';
import 'package:boostnote_mobile/presentation/screens/note_overview/Refreshable.dart';
import 'package:boostnote_mobile/presentation/widgets/AddFloatingActionButton.dart';
import 'package:boostnote_mobile/presentation/widgets/NavigationDrawer.dart';
import 'package:boostnote_mobile/presentation/widgets/appbar/FolderOverviewAppbar.dart';
import 'package:boostnote_mobile/presentation/widgets/bottom_sheets/FolderOverviewBottomSheet.dart';
import 'package:boostnote_mobile/presentation/widgets/bottom_sheets/FolderOverviewErrorBottomSheet.dart';
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
  NewNavigationService _newNavigationService;
  //NavigationService _navigationService;
  List<Folder> _folders;

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _folders = List();
    _noteService = NoteService();
    _newNavigationService = NewNavigationService();
   // _navigationService = NavigationService();
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
       //TODO update navigationListCache??
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
      onCreateFolderCallback: () => _createFolderDialog(),
      onMenuClickCallback: () => _drawerKey.currentState.openDrawer()
    ),
    drawer: NavigationDrawer(),
    body: _buildBody(context),
    floatingActionButton: AddFloatingActionButton(onPressed: () => _createNoteDialog())
  );

  Widget _buildBody(BuildContext context) {
    return Container(
        child: FolderList(
            folders: _folders,
            onRowTap: _onFolderTap,
            onRowLongPress: _onFolderLongPress
        )
    );
  }

  void _createNoteDialog() => showDialog(
    context: context,
    builder: (context) {
      return CreateNoteDialog(
        cancelCallback: () {
          Navigator.of(context).pop();
        },
        saveCallback: (Note note) {
          Navigator.of(context).pop();
          _createNote(note);
          //_navigationService.openNote(note, context, this);
          if(note is MarkdownNote) {
            _newNavigationService.navigateTo(destinationMode: NavigationMode2.MARKDOWN_NOTE, note: note);
          } else if(note is SnippetNote) {
            _newNavigationService.navigateTo(destinationMode: NavigationMode2.SNIPPET_NOTE, note: note);
          }
        },
      );
  });
  
  void _createFolderDialog() => showDialog(
    context: context,
    builder: (context) {
      return CreateFolderDialog(
        cancelCallback: () {
          Navigator.of(context).pop();
        },
        saveCallback: (String folderName) {
          Navigator.of(context).pop();
          _createFolder(folderName);
        },
      );
  });

  void _renameFolderDialog(Folder folder) => showDialog(
    context: context,
    builder: (context) {
      return RenameFolderDialog(
        folder: folder,
        cancelCallback: () {
          Navigator.of(context).pop();
        },
        saveCallback: (String newFolderName) {
          Navigator.of(context).pop();
          _renameFolder(folder, newFolderName);
        },
      );
  });

  void _onFolderTap(Folder folder) {
    //_navigationService.navigateTo(context, NavigationMode.NOTES_IN_FOLDER_MODE, folder: folder);
    _newNavigationService.navigateTo(destinationMode: NavigationMode2.NOTES_IN_FOLDER_MODE, folder: folder);
  }

  void _onFolderLongPress(Folder folder) {
    if (folder.id != 'Default'.hashCode && folder.id != 'Trash'.hashCode) {
      showModalBottomSheet(    
        context: context,
        builder: (BuildContext buildContext) {
          return FolderOverviewBottomSheet(
            removeFolderCallback: () {
              Navigator.of(context).pop();
              _removeFolder(folder);
            },
            renameFolderCallback: () {
              Navigator.of(context).pop();
              _renameFolderDialog(folder);
            },
          );
        }
      );
    } else {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext buildContext) {
          return FolderOverviewErrorBottomSheet();
        }
      );
    }
  }

  void _createFolder(String folderName) {
    _folderService
        .createFolderIfNotExisting(Folder(name: folderName))
        .whenComplete(() => refresh());
  }

  void _renameFolder(Folder oldFolder, String newName) {
    _folderService
        .renameFolder(oldFolder, newName)
        .whenComplete(() => refresh());
  }

  void _removeFolder(Folder folder) {
    _folderService
        .delete(folder)
        .whenComplete(() => refresh());
  }

  void _createNote(Note note) {
    _noteService
        .createNote(note)
        .whenComplete(() => refresh());
  }
}



