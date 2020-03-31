
import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/service/FolderService.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/data/entity/FolderEntity.dart';
import 'package:boostnote_mobile/presentation/notifiers/MarkdownEditorNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteNotifier.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/EditTagsDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/NoteInfoDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/markdown/MarkdownBody.dart';
import 'package:boostnote_mobile/presentation/widgets/markdown/MarkdownNoteHeader.dart';
import 'package:boostnote_mobile/presentation/widgets/markdown/MarkdownPreview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MarkdownEditor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MarkdownEditorState();
}
  

class MarkdownEditorState extends State<MarkdownEditor> with WidgetsBindingObserver{

  List<FolderEntity> _folders;
  FolderEntity _dropdownValueFolder;

  NoteNotifier _noteNotifier;
  MarkdownEditorNotifier _markdownEditorNotifier;


  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    
    _folders = List();
   
   /*
    _folderService.findAllUntrashed().then((folders) { 
      setState(() { 
        _folders = folders;
         _dropdownValueFolder = _folders.firstWhere((folder) => folder.id == this.widget.note.folder.id);
      });
    });*/
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();

    NoteService().save(_noteNotifier.note);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      NoteService().save(_noteNotifier.note);    //mit bool überprüfen ob schon gesaved?
    }
  }

  @override
  Widget build(BuildContext context) {
    _noteNotifier = Provider.of<NoteNotifier>(context);
    _markdownEditorNotifier = Provider.of<MarkdownEditorNotifier>(context);
    return _markdownEditorNotifier.isPreviewMode ? _buildMarkdownPreview() : _buildMarkdownEditor();
  }

  Widget _buildMarkdownPreview(){
    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: MarkdownNoteHeader(
            selectedFolder: _dropdownValueFolder,
            folders: _folders,
            onTagClickedCallback: () => _showTagDialog(context),
            onInfoClickedCallback: () => _showNoteInfoDialog(),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: MarkdownPreview(),
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
            selectedFolder: _dropdownValueFolder,
            folders: _folders,
            onTagClickedCallback: () => _showTagDialog(context),
            onInfoClickedCallback: () => _showNoteInfoDialog(),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: MarkdownBody(),
        )
      ],
    );
  }

  Future<List<String>> _showTagDialog(BuildContext context) => showDialog(
    context: context, 
    builder: (context){
      return EditTagsDialog(tags: _noteNotifier.note.tags);
  });

  Future<List<String>> _showNoteInfoDialog() => showDialog(
    context: context, 
    builder: (context){
      return NoteInfoDialog();
  });

}