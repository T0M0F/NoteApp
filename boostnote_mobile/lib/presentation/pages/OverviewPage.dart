import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/data/entity/SnippetNoteEntity.dart';
import 'package:boostnote_mobile/presentation/pages/CodeSnippetEditor.dart';
import 'package:boostnote_mobile/presentation/pages/MarkdownEditor.dart';
import 'package:boostnote_mobile/presentation/pages/Overview.dart';
import 'package:boostnote_mobile/presentation/pages/OverviewPageAppbar.dart';
import 'package:boostnote_mobile/presentation/screens/ActionConstants.dart';
import 'package:boostnote_mobile/presentation/widgets/NavigationDrawer.dart';
import 'package:boostnote_mobile/presentation/widgets/buttons/AddFloatingActionButton.dart';
import 'package:boostnote_mobile/presentation/widgets/buttons/CreateNoteFloatingActionButton.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/AddSnippetDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/EditSnippetNameDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/EditTagsDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/NewNoteDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/NoteInfoDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/SnippetDescription.dart';
import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveChild.dart';
import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveWidget.dart';
import 'package:flutter/material.dart';

class OverviewPage extends StatefulWidget {

  Note note;

  OverviewPage({this.note});

  @override
  _OverviewPageState createState() => _OverviewPageState();

}

class _OverviewPageState extends State<OverviewPage> {

  NoteService _noteService = NoteService();

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  bool _tilesAreExpanded = false;
  bool _showListView = true;
  bool _markdownEditorPreviewMode = false;
  bool _snippetEditorEditMode = false;
  String _pageTitle = 'All Notes';
  List<Note> _notes = List();

  CodeSnippet selectedCodeSnippet;

  @override
  void initState() {
    super.initState();

    if(widget.note is SnippetNote) {
      selectedCodeSnippet = (widget.note as SnippetNote).codeSnippets.isNotEmpty 
        ? (widget.note as SnippetNote).codeSnippets.first
        : null;
    }

    _noteService.findNotTrashed().then((result) { 
      update(result);
    });
  }

  void update(List<Note> notes){
    setState(() {
      if(_notes != null){
        _notes.replaceRange(0, _notes.length, notes);
      } else {
        _notes = notes;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        key: _drawerKey,
        appBar: _buildAppBar(),
        drawer: NavigationDrawer(), 
        body: _buildBody(), 
        floatingActionButton: _buildFloatingActionButton()
      ),
      
      onWillPop: () { 
       
      }
    );
  }

  PreferredSizeWidget _buildAppBar() { 
     return OverviewPageAppbar(
        pageTitle: _pageTitle,
        notes: List<Note>.from(_notes),
        note: widget.note,
        selectedCodeSnippet: selectedCodeSnippet,
        tilesAreExpanded: _tilesAreExpanded,
        showListView: _showListView,
        markdownEditorPreviewMode: _markdownEditorPreviewMode,
        snippetEditorEditMode: _snippetEditorEditMode,
        onSelectedCodeSnippetChanged: (snippet){
          setState(() {
            selectedCodeSnippet = snippet;
          });
        },
        onMenuClickCallback: () => _drawerKey.currentState.openDrawer(),
        onNaviagteBackCallback: () {}, 
        closeNote: () {
          setState(() {
            widget.note = null;
          });
        },
        onSelectedActionCallback: (String action) => _selectedAction(action),
        onSearchCallback: (filteredNotes) {
          update(filteredNotes);
        },
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
      );
  }

  void _selectedAction(String action){
    switch (action) {
      case ActionConstants.COLLPASE_ACTION:
        setState(() {
            _tilesAreExpanded = false;
          });
        break;
      case ActionConstants.EXPAND_ACTION:
        setState(() {
            _tilesAreExpanded = true;
          });
        break;
      case ActionConstants.SHOW_GRIDVIEW_ACTION:
        setState(() {
          _showListView = false;
        });
        break;
      case ActionConstants.SHOW_LISTVIEW_ACTION:
        setState(() {
          _showListView = true;
        });
        break;
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

  ResponsiveWidget _buildBody() {
    return ResponsiveWidget(
      widgets: <ResponsiveChild> [
        ResponsiveChild(
          smallFlex: widget.note == null ? 1 : 0, 
          largeFlex: 2, 
          child: Overview(
            notes: _notes, 
            showListView: _showListView, 
            tilesAreExpanded: _tilesAreExpanded,
            openNote: (note){
              setState(() {
                this.widget.note = note;
                if(widget.note is SnippetNote) {
                  selectedCodeSnippet = (widget.note as SnippetNote).codeSnippets.isNotEmpty 
                    ? (widget.note as SnippetNote).codeSnippets.first
                    : null;
                }
              });
            },
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

   Future<String> _createNoteDialog() {
    return showDialog(context: context, 
      builder: (context){
        return CreateNoteDialog(
          cancelCallback: () {
            Navigator.of(context).pop();
          }, 
          saveCallback: (Note note) {
            _noteService.save(note);
            setState(() {
              _notes.add(note);
              this.widget.note = note;
            });
            Navigator.of(context).pop();
          },
        );
    });
  }

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