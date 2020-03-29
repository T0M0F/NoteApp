import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:boostnote_mobile/business_logic/service/FolderService.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/data/entity/FolderEntity.dart';
import 'package:boostnote_mobile/data/entity/SnippetNoteEntity.dart';
import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:boostnote_mobile/presentation/navigation/NavigationService.dart';
import 'package:boostnote_mobile/presentation/screens/ActionConstants.dart';
import 'package:boostnote_mobile/presentation/screens/editor/snippet_editor/widgets/CodeSnippetAppBar.dart';
import 'package:boostnote_mobile/presentation/widgets/buttons/AddFloatingActionButton.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/AddSnippetDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/EditSnippetNameDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/EditTagsDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/NoteInfoDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/SnippetDescription.dart';
import 'package:boostnote_mobile/presentation/widgets/snippet/CodeTab.dart';
import 'package:boostnote_mobile/presentation/widgets/snippet/SnippetNoteHeader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CodeSnippetEditor extends StatefulWidget {

  final SnippetNote note;
  bool isEditMode;
  Function() onSnippetEditorViewModeSwitched;
  Function(List<String>) onAddTag;
  Function(String description) onChangeSnippetDescription;
  CodeSnippet selectedCodeSnippet;

  CodeSnippetEditor({this.note, this.isEditMode, this.onSnippetEditorViewModeSwitched, this.selectedCodeSnippet, this.onAddTag, this.onChangeSnippetDescription});

  @override
  State<StatefulWidget> createState() => CodeSnippetEditorState();
}
  

class CodeSnippetEditorState extends State<CodeSnippetEditor> with WidgetsBindingObserver {

  NoteService _noteService;
  FolderService _folderService;

  List<FolderEntity> _folders;
  FolderEntity _dropdownValueFolder;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();

    _noteService = NoteService();
    _folderService = FolderService();
    _folders = List();

    _folderService.findAllUntrashed().then((folders) { 
      setState(() { 
        _folders = folders;
         _dropdownValueFolder = _folders.firstWhere((folder) => folder.id == this.widget.note.folder.id);
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();

    _noteService.save(this.widget.note);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _noteService.save(this.widget.note);    //TODO double save?
    }
  }

  @override
  Widget build(BuildContext context) => widget.selectedCodeSnippet == null ? _buildEmptyBody() : _buildBody();
 
  Widget _buildBody(){ 
    return ListView(
      children: <Widget>[
        SnippetNoteHeader(
            note: this.widget.note,
            selectedFolder: _dropdownValueFolder,
            selectedCodeSnippet: widget.selectedCodeSnippet,
            folders: _folders,
            onTitleChangedCallback: (String title) => this.widget.note.title = title,
            onFolderChangedCallback: (FolderEntity folder) {
              this.widget.note.folder = folder;
              _noteService.save(this.widget.note);
            },
            onCodeSnippetChangedCallback: (CodeSnippet codeSnippet) {
              setState(() {
                widget.selectedCodeSnippet = codeSnippet;
              });
            },
            onTagClickedCallback: () => _showTagDialog(context, this.widget.note.tags),
            onInfoClickedCallback: () => _showNoteInfoDialog(this.widget.note),
            onDescriptionClickCallback: () => _showDescriptionDialog(
              context, 
              this.widget.note,  
              (text){
                this.widget.note.description = text;
                _noteService.save(this.widget.note);
              }
            )
        ),
        Align(
          alignment: Alignment.topLeft,
          child: CodeTab(
            widget.selectedCodeSnippet, 
            widget.isEditMode, 
            (String text) => _onTextChangedCallback(text), 
            widget.onSnippetEditorViewModeSwitched
          )
        )
      ],
    );
  }

  Widget _buildEmptyBody(){ 
    return Stack(
      children: <Widget>[
        SnippetNoteHeader(
          note: this.widget.note,
          selectedFolder: _dropdownValueFolder,
          folders: _folders,
          onTitleChangedCallback: (String title) => this.widget.note.title = title,
          onFolderChangedCallback: (FolderEntity folder) {
            this.widget.note.folder = folder;
            _noteService.save(this.widget.note);
          },
          onTagClickedCallback: () => _showTagDialog(context, this.widget.note.tags),
          onInfoClickedCallback: () => _showNoteInfoDialog(this.widget.note),
          onDescriptionClickCallback: () => _showDescriptionDialog(
              context, 
              this.widget.note,  
              (text){
                widget.onChangeSnippetDescription(text);
              }
            )
        ),
        Center(
          child: Text(
            AppLocalizations.of(context).translate('add_snippet'),
            style: TextStyle(color: Theme.of(context).textTheme.display1.color, fontSize: 18)
          )
        )
      ]
    );
  }

  void _onTextChangedCallback(String text){
       widget.selectedCodeSnippet.content = text;
  }

  Future<List<String>> _showNoteInfoDialog(SnippetNote note) => showDialog(
    context: context, 
    builder: (context){
      return NoteInfoDialog(note);
  });

  Future<List<String>> _showTagDialog(BuildContext context, List<String> tags) => showDialog(
    context: context, 
    builder: (context){
      return EditTagsDialog(
        tags: tags, 
        saveCallback: (selectedTags){
          widget.onAddTag(selectedTags);
          Navigator.of(context).pop();
        },
        cancelCallback: (){
          Navigator.of(context).pop();
        },
      );
  });
  
  Future<String> _showDescriptionDialog(BuildContext context, SnippetNote note, Function(String) callback) =>
    showDialog(
      context: context,  
      builder: (context){
        return SnippetDescriptionDialog(textEditingController: TextEditingController(), note: note, onDescriptionChanged: callback);
  });

}





 
