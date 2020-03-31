import 'package:boostnote_mobile/business_logic/model/Folder.dart';
import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:boostnote_mobile/business_logic/service/FolderService.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/data/entity/SnippetNoteEntity.dart';
import 'package:boostnote_mobile/presentation/navigation/NavigationService.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteOverviewNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/SnippetNotifier.dart';
import 'package:boostnote_mobile/presentation/pages/CodeSnippetEditor.dart';
import 'package:boostnote_mobile/presentation/pages/FoldersPageAppbar.dart';
import 'package:boostnote_mobile/presentation/pages/MarkdownEditor.dart';
import 'package:boostnote_mobile/presentation/pages/PageNavigator.dart';
import 'package:boostnote_mobile/presentation/screens/ActionConstants.dart';
import 'package:boostnote_mobile/presentation/screens/note_overview/Refreshable.dart';
import 'package:boostnote_mobile/presentation/widgets/NavigationDrawer.dart';
import 'package:boostnote_mobile/presentation/widgets/appbar/FolderOverviewAppbar.dart';
import 'package:boostnote_mobile/presentation/widgets/bottom_sheets/FolderOverviewBottomSheet.dart';
import 'package:boostnote_mobile/presentation/widgets/bottom_sheets/FolderOverviewErrorBottomSheet.dart';
import 'package:boostnote_mobile/presentation/widgets/buttons/AddFloatingActionButton.dart';
import 'package:boostnote_mobile/presentation/widgets/buttons/CreateNoteFloatingActionButton.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/AddSnippetDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/CreateFolderDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/EditSnippetNameDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/NewNoteDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/RenameFolderDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/folderlist/FolderList.dart';
import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveChild.dart';
import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class FoldersPage extends StatefulWidget {
  @override
  _FoldersPageState createState() => _FoldersPageState();

}

class _FoldersPageState extends State<FoldersPage> {

  NoteService _noteService;
  FolderService _folderService;
  PageNavigator _pageNavigator;
  List<Folder> _folders;

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  NoteNotifier _noteNotifier;
  NoteOverviewNotifier _noteOverviewNotifier;
  SnippetNotifier _snippetNotifier;

  @override
  void initState() {
    super.initState();

    _folders = List();
    _noteService = NoteService();
    _pageNavigator = PageNavigator();
    _folderService = FolderService();

/*
    if(widget.note is SnippetNote) {
      selectedCodeSnippet = (widget.note as SnippetNote).codeSnippets.isNotEmpty 
        ? (widget.note as SnippetNote).codeSnippets.first
        : null;
    }*/

    _folderService.findAllUntrashed().then((folders) {  //macht untrashed sinn bei folders????
      setState(() {
        _folders = folders;
      });
    });
  }

  void refresh() {
    _folderService.findAllUntrashed().then((folders) {
      setState(() {
        if(_folders != null){
            _folders.replaceRange(0, _folders.length, folders);
        } else {
          _folders = folders;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _noteNotifier = Provider.of<NoteNotifier>(context);
    _snippetNotifier = Provider.of<SnippetNotifier>(context);
    _noteOverviewNotifier = Provider.of<NoteOverviewNotifier>(context);

    return Scaffold(
      key: _drawerKey,
      appBar: _buildAppBar(context),
      drawer: NavigationDrawer(),
      body: _buildBody(context),
      floatingActionButton: _buildFloatingActionButton()
    );
  }

  Widget _buildAppBar(BuildContext context) {
     return FoldersPageAppbar(
        onSelectedActionCallback: (String action) => _selectedAction(action),
        onCreateFolderCallback: () => _createFolderDialog(),
      );
  }

   void _selectedAction(String action){
    switch (action) {
      case ActionConstants.SAVE_ACTION:
        _noteNotifier.note = null;
        _noteService.save(_noteNotifier.note);
        break;
      case ActionConstants.MARK_ACTION:
        _noteNotifier.note.isStarred = true;
        _noteService.save(_noteNotifier.note);
        break;
      case ActionConstants.UNMARK_ACTION:
          _noteNotifier.note.isStarred = false;
        _noteService.save(_noteNotifier.note);
        break;
      case ActionConstants.RENAME_CURRENT_SNIPPET:
       _showRenameSnippetDialog(context);
        break;
      case ActionConstants.DELETE_CURRENT_SNIPPET:
        (_noteNotifier.note as SnippetNote).codeSnippets.remove(_snippetNotifier.selectedCodeSnippet);
        _snippetNotifier.selectedCodeSnippet = (_noteNotifier.note as SnippetNote).codeSnippets.isNotEmpty ? (_noteNotifier.note as SnippetNote).codeSnippets.last : null;
        _noteService.save(_noteNotifier.note);
        break;
      case ActionConstants.DELETE_CURRENT_SNIPPET:
        (_noteNotifier.note as SnippetNote).codeSnippets.remove(_snippetNotifier.selectedCodeSnippet);
        _snippetNotifier.selectedCodeSnippet = (_noteNotifier.note as SnippetNote).codeSnippets.isNotEmpty ? (_noteNotifier.note as SnippetNote).codeSnippets.last : null;
        _noteService.save(_noteNotifier.note);
        break;
    }
  }

  Widget _buildBody(BuildContext context) {
    return ResponsiveWidget(
      widgets: <ResponsiveChild> [
        ResponsiveChild(
          smallFlex: _noteNotifier.note == null ? 1 : 0, 
          largeFlex: 2, 
          child: FolderList(
            folders: _folders,
            onRowTap: _onFolderTap,
            onRowLongPress: _onFolderLongPress
          )
        ),
        ResponsiveChild(
          smallFlex: _noteNotifier.note == null ? 0 : 1, 
          largeFlex: 3, 
          child: _noteNotifier.note == null
            ? Container()
            : _noteNotifier.note is MarkdownNote
              ? MarkdownEditor()
              : CodeSnippetEditor()
        )
      ]
    );
  }

   ResponsiveWidget _buildFloatingActionButton() {
    return ResponsiveWidget(
      showDivider: true,
      divider: Container(width: 0.5, color: Colors.transparent),
      widgets: <ResponsiveChild> [
        ResponsiveChild(
          smallFlex: _noteNotifier.note == null ? 1 : 0,
          largeFlex: 2,
          child: Align(
            alignment: Alignment.bottomRight,
            child: CreateNoteFloatingActionButton(onPressed: () => _createNoteDialog())
          )
        ),
        ResponsiveChild(
          smallFlex: _noteNotifier.note == null ? 0 : 1,
          largeFlex: 3,
          child: _noteNotifier.note is SnippetNote 
            ? Align(
              alignment: Alignment.bottomRight,
              child: AddFloatingActionButton(
                onPressed: () => _showAddSnippetDialog(context, (text){
                  setState(() {
                    List<String> s = text.split('.');
                    CodeSnippet codeSnippet;
                    if(s.length > 1){
                      codeSnippet = CodeSnippetEntity(linesHighlighted: '',  //TODO CodeSnippetEntity...
                                                                name: s[0],
                                                                mode: s[1],
                                                                content: '');
                        (_noteNotifier.note as SnippetNote).codeSnippets.add(codeSnippet);
                    } else {
                      codeSnippet = CodeSnippetEntity(linesHighlighted: '',  //TODO CodeSnippetEntity...
                                                                name: text,
                                                                mode: '',
                                                                content: '');
                        (_noteNotifier.note as SnippetNote).codeSnippets.add(codeSnippet);
                    }
                    _snippetNotifier.selectedCodeSnippet = codeSnippet;
                  });
                  Navigator.of(context).pop();
                })
              )
            )
            : Container()
        )
      ]
    );
  }

  void _createNoteDialog() => showDialog(
    context: context,
    builder: (context) {
      return CreateNoteDialog();
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

  void _onFolderTap(Folder folder) => _pageNavigator.navigateToNotesInFolder(context, folder);
  
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

  void _createFolder(String folderName) => _folderService
                                                .createFolderIfNotExisting(Folder(name: folderName))
                                                .whenComplete(() => refresh());

  void _renameFolder(Folder oldFolder, String newName) =>  _folderService
                                                              .renameFolder(oldFolder, newName)
                                                              .whenComplete(() => refresh());
  void _removeFolder(Folder folder) =>  _folderService
                                            .delete(folder)
                                            .whenComplete(() => refresh());
  
  void _createNote(Note note) => _noteService
                                      .createNote(note)
                                      .whenComplete(() => refresh());

  Future<String> _showRenameSnippetDialog(BuildContext context) =>
    showDialog(context: context, 
      builder: (context){
        return EditSnippetNameDialog();
  });     

  Future<String> _showAddSnippetDialog(BuildContext context, Function(String) callback) =>
    showDialog(context: context, 
      builder: (context){
        return AddSnippetDialog(controller: TextEditingController(), onSnippetAdded: callback);
  });                               

}



