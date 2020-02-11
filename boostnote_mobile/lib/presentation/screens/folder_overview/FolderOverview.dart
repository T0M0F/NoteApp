import 'package:boostnote_mobile/business_logic/model/Folder.dart';
import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/service/FolderService.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/presentation/NavigationService.dart';
import 'package:boostnote_mobile/presentation/screens/markdown_editor/Editor.dart';
import 'package:boostnote_mobile/presentation/screens/overview/Refreshable.dart';
import 'package:boostnote_mobile/presentation/screens/snippet_editor/SnippetTestEditor.dart';
import 'package:boostnote_mobile/presentation/widgets/AddFloatingActionButton.dart';
import 'package:boostnote_mobile/presentation/widgets/NavigationDrawer.dart';
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
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  NoteService _noteService;
  FolderService _folderService;
  NavigationService _navigationService;
  List<Folder> _folders;

  bool _isTablet = false;

  String _pageTitle = 'Folders';

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
  void initState() {
    super.initState();
    _folders = List();
    _noteService = NoteService();
    _navigationService = NavigationService();
    _folderService = FolderService();
    _folderService.findAllUntrashed().then((folders) {
      setState(() {
        _folders = folders;
      });
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        key: _drawerKey,
        appBar: _buildAppBar(context),
        drawer: _buildDrawer(context),
        body: _buildBody(context),
        floatingActionButton: AddFloatingActionButton(onPressed: () => _createNoteDialog())
      );

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(_pageTitle),
      leading: IconButton(
        icon: Icon(Icons.menu, color: Theme.of(context).accentColor),
        onPressed: () => _drawerKey.currentState.openDrawer(),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.create_new_folder),
          onPressed: _createFolderDialog,
        )
      ],
    );
  }

  Theme _buildDrawer(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          canvasColor: Theme.of(context).primaryColorLight,
          textTheme: TextTheme(
              body1: TextStyle(color: Theme.of(context).primaryColorLight)
            )
          ),
      child: _isTablet
          ? null : NavigationDrawer(),
    );
  }

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
          _navigationService.openNote(note, context, this, _isTablet);
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
    _navigationService.navigateTo(context, NavigationMode.NOTES_IN_FOLDER_MODE, folder: folder);
  }

  void _onFolderLongPress(Folder folder) {
    if (folder.id != 'Default'.hashCode && folder.id != 'Trash'.hashCode) {
      showModalBottomSheet(     //TODO extract Widget
        context: context,
        builder: (BuildContext buildContext) {
          return Container(
            child: Wrap(
              children: <Widget>[
                 ListTile(
                    leading:  Icon(Icons.delete),
                    title:  Text('Remove Folder'),
                    onTap: () {
                      Navigator.of(context).pop();
                      _removeFolder(folder);
                    }),
                 ListTile(
                    leading:  Icon(Icons.folder),
                    title:  Text('Rename Folder'),
                    onTap: () {
                      Navigator.of(context).pop();
                      _renameFolderDialog(folder);
                    }),
              ],
            ),
          );
        }
      );
    } else {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext buildContext) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    title:  Text(
                      'Folder can\'t be changed', 
                      style: TextStyle(color: Colors.red)
                    )
                )
              ],
            ),
          );
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



