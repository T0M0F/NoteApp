import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/data/entity/FolderEntity.dart';
import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/SnippetNotifier.dart';
import 'package:boostnote_mobile/presentation/widgets/snippet/CodeTab.dart';
import 'package:boostnote_mobile/presentation/widgets/snippet/SnippetNoteHeader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CodeSnippetEditor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CodeSnippetEditorState();
}
  

class CodeSnippetEditorState extends State<CodeSnippetEditor> with WidgetsBindingObserver {

  NoteService _noteService;

  List<FolderEntity> _folders;
  FolderEntity _dropdownValueFolder;

  NoteNotifier _noteNotifier;
  SnippetNotifier _snippetNotifier;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();

    _noteService = NoteService();
    _folders = List();

    /*_folderService.findAllUntrashed().then((folders) { 
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

    _noteService.save(_noteNotifier.note);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _noteService.save(_noteNotifier.note);    //TODO double save?
    }
  }

  @override
  Widget build(BuildContext context) {
    _noteNotifier = Provider.of<NoteNotifier>(context);
    _snippetNotifier = Provider.of<SnippetNotifier>(context);

    return _snippetNotifier.selectedCodeSnippet == null ? _buildEmptyBody() : _buildBody();
  }

  Widget _buildEmptyBody(){ 
    return Stack(
      children: <Widget>[
        SnippetNoteHeader(
          selectedFolder: _dropdownValueFolder,
          folders: _folders,
          onFolderChangedCallback: (FolderEntity folder) {
            _noteNotifier.note.folder = folder;
            _noteService.save(_noteNotifier.note);
          },
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
 
  Widget _buildBody(){ 
    return ListView(
      children: <Widget>[
        SnippetNoteHeader(
            selectedFolder: _dropdownValueFolder,
            folders: _folders,
            onFolderChangedCallback: (FolderEntity folder) {
              _noteNotifier.note.folder = folder;
              _noteService.save(_noteNotifier.note);
            },
        ),
        Align(
          alignment: Alignment.topLeft,
          child: CodeTab()
        )
      ],
    );
  }
}





 
