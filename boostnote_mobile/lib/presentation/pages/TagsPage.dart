import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/business_logic/service/TagService.dart';
import 'package:boostnote_mobile/data/entity/SnippetNoteEntity.dart';
import 'package:boostnote_mobile/presentation/navigation/NavigationService.dart';
import 'package:boostnote_mobile/presentation/pages/CodeSnippetEditor.dart';
import 'package:boostnote_mobile/presentation/pages/MarkdownEditor.dart';
import 'package:boostnote_mobile/presentation/screens/ActionConstants.dart';
import 'package:boostnote_mobile/presentation/screens/note_overview/Refreshable.dart';
import 'package:boostnote_mobile/presentation/widgets/NavigationDrawer.dart';
import 'package:boostnote_mobile/presentation/widgets/appbar/TagOverviewAppbar.dart';
import 'package:boostnote_mobile/presentation/widgets/bottom_sheets/TagOverviewBottomSheet.dart';
import 'package:boostnote_mobile/presentation/widgets/buttons/AddFloatingActionButton.dart';
import 'package:boostnote_mobile/presentation/widgets/buttons/CreateNoteFloatingActionButton.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/AddSnippetDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/CreateTagDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/EditSnippetNameDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/NewNoteDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/RenameTagDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveChild.dart';
import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveWidget.dart';
import 'package:boostnote_mobile/presentation/widgets/taglist/TagList.dart';
import 'package:flutter/material.dart';

import 'TagsPageAppbar.dart';


class TagsPage extends StatefulWidget {  

  Note note;

  TagsPage({this.note});

  @override
  _TagsPageState createState() => _TagsPageState();

}
 
class _TagsPageState extends State<TagsPage> implements Refreshable{

  NavigationService _newNavigationService;
  NoteService _noteService;
  TagService _tagService;
  List<String> _tags;

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  bool _markdownEditorPreviewMode = false;
  bool _snippetEditorEditMode = false;

  CodeSnippet selectedCodeSnippet;

  @override
  void initState(){
    super.initState();

    _tags = List();
    _newNavigationService = NavigationService();
    _noteService = NoteService();
    _tagService = TagService();

    if(widget.note is SnippetNote) {
      selectedCodeSnippet = (widget.note as SnippetNote).codeSnippets.isNotEmpty 
        ? (widget.note as SnippetNote).codeSnippets.first
        : null;
    }

    _tagService.findAll().then((tags) {
      setState((){ 
        _tags = tags;
      });
    });
  }

  @override
  void refresh() {
    _tagService.findAll().then((tags) {
      setState((){ 
        if(_tags != null){
            _tags.replaceRange(0, _tags.length, tags);
        } else {
          _tags = tags;
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
    return TagsPageAppbar(
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
      onCreateTagCallback: () => _createTagDialog(),
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
          child: TagList(
            tags: _tags, 
            onRowTap: _onRowTap, 
            onRowLongPress: _onRowLongPress
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
          Navigator.of(context).pop();
          _createNote(note);
          if(note is MarkdownNote) {
            _newNavigationService.navigateTo(destinationMode: NavigationMode2.MARKDOWN_NOTE, note: note);
          } else if(note is SnippetNote) {
            _newNavigationService.navigateTo(destinationMode: NavigationMode2.SNIPPET_NOTE, note: note);
          }
          
        },
      );
    });
  }

  void _createTagDialog() {
   showDialog(context: context, 
    builder: (context){
      return CreateTagDialog(
        cancelCallback: () {
          Navigator.of(context).pop();
        }, 
        saveCallback: (String tag) {
          Navigator.of(context).pop();
          _createTag(tag);
        },
      );
    });
  }

  void _renameTagDialog(String tag) {
   showDialog(context: context, 
    builder: (context){
      return RenameTagDialog(
        tag: tag,
        cancelCallback: () {
          Navigator.of(context).pop();
        }, 
        saveCallback: (String newTag) {
          Navigator.of(context).pop();
          _renameTag(tag, newTag);
        },
      );
    });
  }

  void _onRowTap(String tag) => _newNavigationService
                                      .navigateTo(destinationMode: NavigationMode2.NOTES_WITH_TAG_MODE, tag: tag);


  void _onRowLongPress(String tag) {
    showModalBottomSheet(     
      context: context,
      builder: (BuildContext buildContext){
        return TagOverviewBottomSheet(
          removeTagCallback: () {
            Navigator.of(context).pop();
            _removeTag(tag);
          } ,
          renameTagCallback: () {
            Navigator.of(context).pop();
            _renameTagDialog(tag);
          } 
        );
      }
    );
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

  void _createTag(String tag) => _tagService
                                    .createTagIfNotExisting(tag)
                                    .whenComplete(() => refresh());
                              
  void _renameTag(String oldTag, String newTag) => _tagService
                                                      .renameTag(oldTag, newTag)
                                                      .whenComplete(() => refresh());
  
  void _removeTag(String tag) => _tagService
                                      .delete(tag)
                                      .whenComplete(() => refresh());
  
  void _createNote(Note note) => _noteService
                                      .createNote(note)
                                      .whenComplete(() => refresh());
}