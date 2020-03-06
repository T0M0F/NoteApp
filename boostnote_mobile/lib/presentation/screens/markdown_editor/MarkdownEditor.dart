
import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/service/FolderService.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/data/entity/FolderEntity.dart';
import 'package:boostnote_mobile/presentation/NavigationService.dart';
import 'package:boostnote_mobile/presentation/NewNavigationService.dart';
import 'package:boostnote_mobile/presentation/screens/ActionConstants.dart';
import 'package:boostnote_mobile/presentation/screens/markdown_editor/widgets/MarkdownEditorAppBar.dart';
import 'package:boostnote_mobile/presentation/screens/note_overview/Refreshable.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/EditTagsDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/NoteInfoDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/markdown/MarkdownBody.dart';
import 'package:boostnote_mobile/presentation/widgets/markdown/MarkdownNoteHeader.dart';
import 'package:boostnote_mobile/presentation/widgets/markdown/MarkdownPreview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MarkdownEditor extends StatefulWidget {

  //final Refreshable _parentWidget;
  final MarkdownNote _note;

  MarkdownEditor(this._note);

  @override
  State<StatefulWidget> createState() => MarkdownEditorState();
}
  

class MarkdownEditorState extends State<MarkdownEditor> with WidgetsBindingObserver{

  NewNavigationService _newNavigationService;
  //NavigationService _navigatiorService;
  NoteService _noteService;
  FolderService _folderService;

  bool _previewMode = false;
  List<FolderEntity> _folders;
  FolderEntity _dropdownValueFolder;


  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();

    _newNavigationService = NewNavigationService();
    //_navigatiorService = NavigationService();
    _noteService = NoteService();
    _folderService = FolderService();
    _folders = List();
   
    _folderService.findAllUntrashed().then((folders) { 
      setState(() { 
        _folders = folders;
         _dropdownValueFolder = _folders.firstWhere((folder) => folder.id == this.widget._note.folder.id);
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();

    NoteService().save(this.widget._note);
   // _navigatiorService.noteIsOpen = false; //ABweichende Logik
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      NoteService().save(this.widget._note);    //mit bool überprüfen ob schon gesaved?
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _previewMode ? _buildMarkdownPreview() : _buildMarkdownEditor(),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return MarkdownEditorAppBar(
      isPreviewMode: _previewMode,
      isNoteStarred: this.widget._note.isStarred,
      onNavigateBackCallback: () => _newNavigationService.navigateBack(context),//_navigatiorService.closeNote(context),
      onViewModeSwitchedCallback: (bool value) {
         setState(() {
              _previewMode = value;
          });
      },
      selectedActionCallback: (String action) => _selectedAction(action)
    );
  }

  Widget _buildMarkdownPreview(){
    return ListView(
      children: <Widget>[
        MarkdownNoteHeader(
          note: this.widget._note,
          selectedFolder: _dropdownValueFolder,
          folders: _folders,
          onTitleChangedCallback: (String title) => this.widget._note.title = title,
          onFolderChangedCallback: (FolderEntity folder) {
            this.widget._note.folder = folder;
            _noteService.save(this.widget._note);
          },
          onTagClickedCallback: () => _showTagDialog(context, this.widget._note.tags),
          onInfoClickedCallback: () => _showNoteInfoDialog(this.widget._note),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: MarkdownPreview(this.widget._note.content, _launchURL),
        )
      ],
    );
  }


  Widget _buildMarkdownEditor(){ //use minLines for Textfield to make it work
    return ListView(
      children: <Widget>[
        MarkdownNoteHeader(
          note: this.widget._note,
          selectedFolder: _dropdownValueFolder,
          folders: _folders,
          onTitleChangedCallback: (String title) => this.widget._note.title = title,
          onFolderChangedCallback: (FolderEntity folder) {
            this.widget._note.folder = folder;
            _noteService.save(this.widget._note);
          },
          onTagClickedCallback: () => _showTagDialog(context, this.widget._note.tags),
          onInfoClickedCallback: () => _showNoteInfoDialog(this.widget._note),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: MarkdownBody(this.widget._note.content, _onTextChangedCallback),
        )
      ],
    );
  }

  //TODO: Unelegant / Presenter??
  void _selectedAction(String action){
      NoteService noteService = NoteService();
      if(action == ActionConstants.DELETE_ACTION){
        noteService.moveToTrash(this.widget._note);
        _newNavigationService.navigateBack(context);
      } else if(action == ActionConstants.SAVE_ACTION){
        noteService.save(this.widget._note);
         _newNavigationService.navigateBack(context);
      } else if(action == ActionConstants.MARK_ACTION){
        setState(() {
          this.widget._note.isStarred = true;
        });
        noteService.save(this.widget._note);
      } else if(action == ActionConstants.UNMARK_ACTION){
        setState(() {
          this.widget._note.isStarred = false;
        });
        noteService.save(this.widget._note);
      } 
  }

  void _onTextChangedCallback(String text){
       this.widget._note.content = text;
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
          selectedTags.forEach((t) => print(t));
          NoteService service = NoteService();  //TODO: Presenter
          service.save(this.widget._note);
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


/*
  Widget _buildMarkdownEditor(){
    return LayoutBuilder(
      builder: (context, constraint) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child:  DropdownButton<FolderEntity> (    //TODO FolderEntity
                          value: _dropdownValueFolder, 
                          underline: Container(), 
                          icon: Icon(Icons.folder_open),
                          items: _folders.map<DropdownMenuItem<FolderEntity>>((folder) => DropdownMenuItem<FolderEntity>(
                            value: folder,
                            child: Text(folder.name)
                          )).toList(),
                          onChanged: (folder) {
                              setState(() {
                                _dropdownValueFolder = folder;
                              });
                              this.widget._note.folder = folder;
                              _noteService.save(this.widget._note);
                            }
                        )
                      ),
                      Row(
                      children: <Widget>[
                        IconButton(icon: Icon(Icons.label_outline), onPressed: () => _showTagDialog(context, this.widget._note.tags)),
                        IconButton(icon: Icon(Icons.info_outline), onPressed: () {})
                        ],
                      ),
                    ],
                  ),
                  Expanded(
                    child:  MarkdownBody(this.widget._note.content, _onTextChangedCallback),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }*/


 
