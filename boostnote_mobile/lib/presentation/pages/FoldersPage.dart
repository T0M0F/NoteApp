import 'package:boostnote_mobile/business_logic/model/Folder.dart';
import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:boostnote_mobile/business_logic/service/FolderService.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/data/entity/SnippetNoteEntity.dart';
import 'package:boostnote_mobile/presentation/navigation/NavigationService.dart';
import 'package:boostnote_mobile/presentation/pages/CodeSnippetEditor.dart';
import 'package:boostnote_mobile/presentation/pages/FoldersPageAppbar.dart';
import 'package:boostnote_mobile/presentation/pages/MarkdownEditor.dart';
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


class FoldersPage extends StatefulWidget {

  Note note;

  FoldersPage({this.note});

  @override
  _FoldersPageState createState() => _FoldersPageState();

}

class _FoldersPageState extends State<FoldersPage> {

  NoteService _noteService;
  FolderService _folderService;
  NavigationService _newNavigationService;
  List<Folder> _folders;

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  bool _markdownEditorPreviewMode = false;
  bool _snippetEditorEditMode = false;

  CodeSnippet selectedCodeSnippet;

  @override
  void initState() {
    super.initState();

    _folders = List();
    _noteService = NoteService();
    _newNavigationService = NavigationService();
    _folderService = FolderService();

    if(widget.note is SnippetNote) {
      selectedCodeSnippet = (widget.note as SnippetNote).codeSnippets.isNotEmpty 
        ? (widget.note as SnippetNote).codeSnippets.first
        : null;
    }

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
  Widget build(BuildContext context) => Scaffold(
    key: _drawerKey,
    appBar: _buildAppBar(context),
    drawer: NavigationDrawer(),
    body: _buildBody(context),
    floatingActionButton: _buildFloatingActionButton()
  );

  Widget _buildAppBar(BuildContext context) {
     return FoldersPageAppbar(
        note: widget.note,
        selectedCodeSnippet: selectedCodeSnippet,
        markdownEditorPreviewMode: _markdownEditorPreviewMode,
        snippetEditorEditMode: _snippetEditorEditMode,
        onSelectedCodeSnippetChanged: (snippet){
          setState(() {
            selectedCodeSnippet = snippet;
          });
        },
        onSelectedActionCallback: (String action) => _selectedAction(action),
        onMarkdownEditorViewModeSwitchedCallback: (bool value) {
          setState(() {
            _markdownEditorPreviewMode = value;
          });
        },
        onSnippetEditorViewModeSwitched: () {
          setState(() {
            _snippetEditorEditMode = !_snippetEditorEditMode;
          });
        },
        closeNote: () { 
          setState(() {
            widget.note = null;
          });},
        onCreateFolderCallback: () => _createFolderDialog(),
        onMenuClickCallback: () => _drawerKey.currentState.openDrawer(),
      );
  }

   void _selectedAction(String action){
    switch (action) {
      case ActionConstants.SAVE_ACTION:
        setState(() {
          widget.note = null;
        });
        _noteService.save(widget.note);
        break;
      case ActionConstants.MARK_ACTION:
       setState(() {
          widget.note.isStarred = true;
        });
        _noteService.save(widget.note);
        break;
      case ActionConstants.UNMARK_ACTION:
        setState(() {
          widget.note.isStarred = false;
        });
        _noteService.save(widget.note);
        break;
      case ActionConstants.RENAME_CURRENT_SNIPPET:
       _showRenameSnippetDialog(context, (String name){
          setState(() {
            selectedCodeSnippet.name = name;
          });
          Navigator.of(context).pop();
          _noteService.save(widget.note);
        });
        break;
      case ActionConstants.DELETE_CURRENT_SNIPPET:
        setState(() {
          (widget.note as SnippetNote).codeSnippets.remove(selectedCodeSnippet);
          selectedCodeSnippet = (widget.note as SnippetNote).codeSnippets.isNotEmpty ? (widget.note as SnippetNote).codeSnippets.last : null;
        });
        _noteService.save(widget.note);
        break;
      case ActionConstants.DELETE_CURRENT_SNIPPET:
         setState(() {
          (widget.note as SnippetNote).codeSnippets.remove(selectedCodeSnippet);
          selectedCodeSnippet = (widget.note as SnippetNote).codeSnippets.isNotEmpty ? (widget.note as SnippetNote).codeSnippets.last : null;
        });
        _noteService.save(widget.note);
        break;
    }
  }

  Widget _buildBody(BuildContext context) {
    return ResponsiveWidget(
      widgets: <ResponsiveChild> [
        ResponsiveChild(
          smallFlex: widget.note == null ? 1 : 0, 
          largeFlex: 2, 
          child: FolderList(
            folders: _folders,
            onRowTap: _onFolderTap,
            onRowLongPress: _onFolderLongPress
          )
        ),
        ResponsiveChild(
          smallFlex: widget.note == null ? 0 : 1, 
          largeFlex: 3, 
          child: this.widget.note == null
            ? Container()
            : this.widget.note is MarkdownNote
              ? MarkdownEditor(
                note: this.widget.note, 
                previedMode: _markdownEditorPreviewMode,
                onEditTags: (tags) {
                  widget.note.tags = tags;
                  _noteService.save(widget.note);
                }
              )
              : CodeSnippetEditor(
                note: this.widget.note,
                isEditMode: _snippetEditorEditMode,
                selectedCodeSnippet: selectedCodeSnippet,
                onAddTag: (tags) {
                  widget.note.tags = tags;
                  _noteService.save(widget.note);
                },
                onChangeSnippetDescription: (description) {
                  setState(() {
                    (widget.note as SnippetNote).description = description;
                    _noteService.save(widget.note);
                  });
                },
                onSnippetEditorViewModeSwitched: () {
                    setState(() {
                      _snippetEditorEditMode = !_snippetEditorEditMode;
                    });
                  }
                )
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
          smallFlex: widget.note == null ? 1 : 0,
          largeFlex: 2,
          child: Align(
            alignment: Alignment.bottomRight,
            child: CreateNoteFloatingActionButton(onPressed: () => _createNoteDialog())
          )
        ),
        ResponsiveChild(
          smallFlex: widget.note == null ? 0 : 1,
          largeFlex: 3,
          child: widget.note is SnippetNote 
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
                        (widget.note as SnippetNote).codeSnippets.add(codeSnippet);
                    } else {
                      codeSnippet = CodeSnippetEntity(linesHighlighted: '',  //TODO CodeSnippetEntity...
                                                                name: text,
                                                                mode: '',
                                                                content: '');
                        (widget.note as SnippetNote).codeSnippets.add(codeSnippet);
                    }
                    selectedCodeSnippet = codeSnippet;
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
      return CreateNoteDialog(
        cancelCallback: () {
          Navigator.of(context).pop();
        },
        saveCallback: (Note note) {
          Navigator.of(context).pop();
          _createNote(note);
          setState(() {
            widget.note = note;
          });
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

  void _onFolderTap(Folder folder) => _newNavigationService.navigateTo(destinationMode: NavigationMode2.NOTES_IN_FOLDER_MODE, folder: folder);
  
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

  Future<String> _showRenameSnippetDialog(BuildContext context, Function(String) callback) =>
    showDialog(context: context, 
      builder: (context){
        return EditSnippetNameDialog(textEditingController: TextEditingController(), onNameChanged: callback, noteTitle: selectedCodeSnippet.name);
  });     

  Future<String> _showAddSnippetDialog(BuildContext context, Function(String) callback) =>
    showDialog(context: context, 
      builder: (context){
        return AddSnippetDialog(controller: TextEditingController(), onSnippetAdded: callback);
  });                               

}



