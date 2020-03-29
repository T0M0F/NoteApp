
import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/service/FolderService.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/data/entity/FolderEntity.dart';
import 'package:boostnote_mobile/presentation/navigation/NavigationService.dart';
import 'package:boostnote_mobile/presentation/screens/ActionConstants.dart';
import 'package:boostnote_mobile/presentation/screens/editor/markdown_editor/widgets/MarkdownEditorAppBar.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/EditTagsDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/NoteInfoDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/markdown/MarkdownBody.dart';
import 'package:boostnote_mobile/presentation/widgets/markdown/MarkdownNoteHeader.dart';
import 'package:boostnote_mobile/presentation/widgets/markdown/MarkdownPreview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MarkdownEditor extends StatefulWidget {

  final MarkdownNote note;
  bool previedMode;
  Function(List<String>) onEditTags;

  MarkdownEditor({this.note, this.previedMode, this.onEditTags});

  @override
  State<StatefulWidget> createState() => MarkdownEditorState();
}
  

class MarkdownEditorState extends State<MarkdownEditor> with WidgetsBindingObserver{

  FolderService _folderService;

  List<FolderEntity> _folders;
  FolderEntity _dropdownValueFolder;


  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    
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

    NoteService().save(this.widget.note);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      NoteService().save(this.widget.note);    //mit bool überprüfen ob schon gesaved?
    }
  }

  @override
  Widget build(BuildContext context) => widget.previedMode ? _buildMarkdownPreview() : _buildMarkdownEditor();

  Widget _buildMarkdownPreview(){
    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: MarkdownNoteHeader(
            note: this.widget.note,
            selectedFolder: _dropdownValueFolder,
            folders: _folders,
            onTitleChangedCallback: (String title) => this.widget.note.title = title,
            onFolderChangedCallback: (FolderEntity folder) {
              this.widget.note.folder = folder;
              //_noteService.save(this.widget._note); brauch ich hier wirklich saven?
            },
            onTagClickedCallback: () => _showTagDialog(context, this.widget.note.tags),
            onInfoClickedCallback: () => _showNoteInfoDialog(this.widget.note),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: MarkdownPreview(this.widget.note.content, _launchURL),
        )
      ],
    );
  }

 
  Widget _buildMarkdownEditor(){ //use minLines for Textfield to make it work
    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: MarkdownNoteHeader(
            note: this.widget.note,
            selectedFolder: _dropdownValueFolder,
            folders: _folders,
            onTitleChangedCallback: (String title) => this.widget.note.title = title,
            onFolderChangedCallback: (FolderEntity folder) {
              this.widget.note.folder = folder;
               //_noteService.save(this.widget._note); brauch ich hier wirklich saven?
            },
            onTagClickedCallback: () => _showTagDialog(context, this.widget.note.tags),
            onInfoClickedCallback: () => _showNoteInfoDialog(this.widget.note),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: MarkdownBody(this.widget.note.content, _onTextChangedCallback),
        )
      ],
    );
  }

  void _onTextChangedCallback(String text){
       this.widget.note.content = text;
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<List<String>> _showTagDialog(BuildContext context, List<String> tags) => showDialog(
    context: context, 
    builder: (context){
      return EditTagsDialog(
        tags: tags, 
        saveCallback: (selectedTags){
          widget.onEditTags(tags);
          Navigator.of(context).pop();
        },
        cancelCallback: (){
          Navigator.of(context).pop();
        },
      );
  });

  Future<List<String>> _showNoteInfoDialog(MarkdownNote note) => showDialog(
    context: context, 
    builder: (context){
      return NoteInfoDialog(note);
  });

}