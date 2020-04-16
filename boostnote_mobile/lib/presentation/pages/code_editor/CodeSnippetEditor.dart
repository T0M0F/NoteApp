import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:boostnote_mobile/business_logic/service/FolderService.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/data/entity/FolderEntity.dart';
import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/SnippetNotifier.dart';
import 'package:boostnote_mobile/presentation/pages/code_editor/widgets/CodeTab.dart';
import 'package:boostnote_mobile/presentation/pages/code_editor/widgets/SnippetNoteHeader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CodeSnippetEditor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CodeSnippetEditorState();
}
  

class CodeSnippetEditorState extends State<CodeSnippetEditor> with WidgetsBindingObserver {

  NoteService _noteService;
  FolderService _folderService;

  NoteNotifier _noteNotifier;
  SnippetNotifier _snippetNotifier;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();

    _noteService = NoteService();
    _folderService = FolderService(); 

    _folderService.findAllUntrashed().then((folders) { 
      _snippetNotifier.folders = folders;
      _snippetNotifier.selectedFolder = folders.firstWhere((folder) => folder.id == _noteNotifier.note.folder.id, orElse: () => null);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _noteNotifier = Provider.of<NoteNotifier>(context);
    _snippetNotifier = Provider.of<SnippetNotifier>(context);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();

    if(_noteNotifier.note != null) {
      _noteService.save(_noteNotifier.note);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      if(_noteNotifier.note != null) {  
        _noteService.save(_noteNotifier.note);   //TODO double save?
      }  
    }
  }

  @override
  Widget build(BuildContext context) {
    if(_snippetNotifier.selectedCodeSnippet == null) { 
      if((_noteNotifier.note as SnippetNote).codeSnippets != null && (_noteNotifier.note as SnippetNote).codeSnippets.isNotEmpty) {
        _snippetNotifier.selectedCodeSnippet = (_noteNotifier.note as SnippetNote).codeSnippets.first;
      }
    }
    
    return _snippetNotifier.selectedCodeSnippet == null ? _buildEmptyBody() : _buildBody();
  }

  Widget _buildEmptyBody(){ 
    return Stack(
      children: <Widget>[
        SnippetNoteHeader(),
        Center(
          child: Text(
            AppLocalizations.of(context).translate('add_snippet'),
            style: TextStyle(color: Theme.of(context).textTheme.display1.color, fontSize: 18)
          )
        )
      ]
    );
  }
 
  Widget _buildBody(){ 
    return ListView(
      children: <Widget>[
        SnippetNoteHeader(),
        Align(
          alignment: Alignment.topLeft,
          child: CodeTab()
        )
      ],
    );
  }
}





 
