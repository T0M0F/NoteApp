import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:boostnote_mobile/business_logic/service/FolderService.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/data/entity/FolderEntity.dart';
import 'package:boostnote_mobile/data/entity/SnippetNoteEntity.dart';
import 'package:boostnote_mobile/presentation/NavigationService.dart';
import 'package:boostnote_mobile/presentation/screens/note_overview/Refreshable.dart';
import 'package:boostnote_mobile/presentation/widgets/AddFloatingActionButton.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/AddSnippetDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/EditTagsDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/NoteInfoDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/SnippetDescription.dart';
import 'package:boostnote_mobile/presentation/widgets/snippet/CodeTab.dart';
import 'package:boostnote_mobile/presentation/widgets/snippet/SnippetNoteHeader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CodeSnippetEditor extends StatefulWidget {

  final Refreshable _parentWidget;
  final SnippetNote _note;

  CodeSnippetEditor(this._note, this._parentWidget);

  @override
  State<StatefulWidget> createState() => CodeSnippetEditorState();
}
  

class CodeSnippetEditorState extends State<CodeSnippetEditor> {

  NavigationService _navigatiorService;
  NoteService _noteService;
  FolderService _folderService;

  List<FolderEntity> _folders;
  FolderEntity _dropdownValueFolder;
  bool _editMode;
  CodeSnippet _selectedCodeSnippet;

  static const String DELETE_ACTION = 'Delete';
  static const String SAVE_ACTION = 'Save';
  /*static const String EDIT_ACTION = 'Edit Note';*/
  static const String MARK_ACTION = 'Mark Note';
  static const String UNMARK_ACTION = 'Unmark Note';

  @override
  void initState() {
    super.initState();
    _navigatiorService = NavigationService();
    _noteService = NoteService();
    _folderService = FolderService();
    _folders = List();
    _editMode = false;
    _selectedCodeSnippet = this.widget._note.codeSnippets.first;
   
    _folderService.findAllUntrashed().then((folders) { 
      setState(() { 
        _folders = folders;
         _dropdownValueFolder = _folders.firstWhere((folder) => folder.id == this.widget._note.folder.id);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    print('DISPOSE');
    NoteService().save(this.widget._note);
    _navigatiorService.noteIsOpen = false; //ABweichende Logik
    //this.widget._parentWidget.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _selectedCodeSnippet == null ? _buildEmptyBody() : _buildBody(),
      floatingActionButton: _editMode ? null : AddFloatingActionButton(
        onPressed: () => _showAddSnippetDialog(context, (text){
          setState(() {
            List<String> s = text.split('.');
            CodeSnippet codeSnippet;
            if(s.length > 1){
               codeSnippet = CodeSnippetEntity(linesHighlighted: new List(),  //TODO CodeSnippetEntity...
                                                        name: s[0],
                                                        mode: s[1],
                                                        content: '');
                this.widget._note.codeSnippets.add(codeSnippet);
            } else {
              codeSnippet = CodeSnippetEntity(linesHighlighted: new List(),  //TODO CodeSnippetEntity...
                                                        name: text,
                                                        mode: '',
                                                        content: '');
                this.widget._note.codeSnippets.add(codeSnippet);
            }
            _selectedCodeSnippet = codeSnippet;
          });
          Navigator.of(context).pop();
        })
       )
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    List<Widget> actions;

    if(_editMode) {
      actions = <Widget>[
        IconButton(
          icon: Icon(Icons.check), 
          onPressed: () {
            setState(() {
              _editMode = !_editMode;
            });
          }
        )
      ];
    } else {
      actions = <Widget>[
        Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 5), 
              child: Icon(Icons.code)
            ),
            DropdownButton<CodeSnippet> (  
              value: _selectedCodeSnippet, 
              underline: Container(), 
              iconEnabledColor: Colors.white,
              style: TextStyle(fontSize: 16, color:  Colors.white, fontWeight: FontWeight.bold),
              selectedItemBuilder: (BuildContext context) {
                String snippetName = _selectedCodeSnippet.name.length > 10 ? _selectedCodeSnippet.name.substring(0,10) : _selectedCodeSnippet.name;
                Widget item = DropdownMenuItem<CodeSnippet>(
                  value: _selectedCodeSnippet,
                  child: Row(
                    children: <Widget>[
                      Text(snippetName + '    '),
                    ],
                  )
                );
                return <DropdownMenuItem<CodeSnippet>>[item];
              },
              items: this.widget._note.codeSnippets.map<DropdownMenuItem<CodeSnippet>>((codeSnippet) {
                
                Widget item = DropdownMenuItem<CodeSnippet>(
                  value: codeSnippet,
                  child: Row(
                    children: <Widget>[
                      Text(codeSnippet.name, style: TextStyle(fontSize: 16, color:  Colors.black, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: Icon(Icons.delete), 
                        onPressed: () {
                           this.widget._note.codeSnippets.remove(codeSnippet);
                        })
                    ],
                  )
                );
                return item;
              }).toList(),
              onChanged: (CodeSnippet codeSnippet) {
                setState(() {
                  _selectedCodeSnippet = codeSnippet;
                });
              },
            ),
          ],
        ),
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert),
          onSelected: _selectedAction,
          itemBuilder: (BuildContext context) {
            return <PopupMenuEntry<String>>[
              PopupMenuItem(
                value: SAVE_ACTION,
                child: ListTile(
                  title: Text(SAVE_ACTION)
                )
              ),
              PopupMenuItem(
                value: DELETE_ACTION,
                child: ListTile(
                  title: Text(DELETE_ACTION)
                )
              ),
              PopupMenuItem(
                value: this.widget._note.isStarred ?  UNMARK_ACTION : MARK_ACTION,
                child: ListTile(
                  title: Text(this.widget._note.isStarred ?  UNMARK_ACTION : MARK_ACTION)
                )
              )
            ];
          }
        )
      ];
    }

    return AppBar(
      /*title: Text(this.widget._note.title),*/
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Color(0xFFF6F5F5)), 
        onPressed: () {
          _navigatiorService.closeNote(context);
        },
      ),
      actions: actions
    );
  }

  //TODO: Presenter??
  void _selectedAction(String action){
      NoteService noteService = NoteService();
      if(action == DELETE_ACTION){
        noteService.moveToTrash(this.widget._note);
        this.widget._parentWidget.refresh();
        Navigator.of(context).pop();
      } else if(action == SAVE_ACTION){
        noteService.save(this.widget._note);
        this.widget._parentWidget.refresh();
        Navigator.of(context).pop();
      }/* else if(action == EDIT_ACTION){
        _showEditNoteDialog(context, this.widget._note, (note){
          setState(() {
            this.widget._note.title = note.title;
          });
          noteService.save(this.widget._note);
          Navigator.of(context).pop();
        });
      } */else if(action == MARK_ACTION){
        this.widget._note.isStarred = true;
        noteService.save(this.widget._note);
      } else if(action == UNMARK_ACTION){
        this.widget._note.isStarred = false;
        noteService.save(this.widget._note);
      } 
  }

  Widget _buildBody(){ 
    this.widget._note.codeSnippets.forEach((s) => print(s.name));
    return ListView(
      children: <Widget>[
        SnippetNoteHeader(
          note: this.widget._note,
          selectedFolder: _dropdownValueFolder,
          selectedCodeSnippet: _selectedCodeSnippet,
          folders: _folders,
          onTitleChangedCallback: (String title) => this.widget._note.title = title,
          onFolderChangedCallback: (FolderEntity folder) {
            this.widget._note.folder = folder;
            _noteService.save(this.widget._note);
          },
          onCodeSnippetChangedCallback: (CodeSnippet codeSnippet) {
            setState(() {
              _selectedCodeSnippet = codeSnippet;
            });
          },
          onTagClickedCallback: () => _showTagDialog(context, this.widget._note.tags),
          onInfoClickedCallback: () => _showNoteInfoDialog(this.widget._note),
          onDescriptionClickCallback: () => _showDescriptionDialog(
            context, 
            this.widget._note,  
            (text){
              this.widget._note.description = text;
              _noteService.save(this.widget._note);
            }
          )
        ),
        Align(
          alignment: Alignment.topLeft,
          child: CodeTab(
            _selectedCodeSnippet, 
            _editMode, 
            (String text) => _onTextChangedCallback(text), 
            (bool editMode) {
              setState(() {
                _editMode = editMode;
              });
            }
          )
        )
      ],
    );
  }

  Widget _buildEmptyBody(){ 
    return ListView(
      children: <Widget>[
        SnippetNoteHeader(
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
         Padding(
          padding: EdgeInsets.only(left: 10),
          child:  Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 5), 
                child: Icon(Icons.code)
              ),
              DropdownButton<CodeSnippet> (  
                value: _selectedCodeSnippet, 
                underline: Container(), 
                iconEnabledColor: Colors.transparent,
                style: TextStyle(fontSize: 16, color: Colors.black54, fontWeight: FontWeight.bold),
                items: this.widget._note.codeSnippets.map<DropdownMenuItem<CodeSnippet>>((codeSnippet) => DropdownMenuItem<CodeSnippet>(
                  value: codeSnippet,
                  child: Text(codeSnippet.name)
                )).toList(),
                onChanged: (folder) {
                  
                }
              ),
            ],
          )
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Container()
        )
      ],
    );
  }

  void _onTextChangedCallback(String text){
       _selectedCodeSnippet.content = text;
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

  Future<List<String>> _showNoteInfoDialog(SnippetNote note) => showDialog(
    context: context, 
    builder: (context){
      return NoteInfoDialog(note);
  });

  Future<String> _showDescriptionDialog(BuildContext context, SnippetNote note, Function(String) callback) =>
    showDialog(context: context,  builder: (context){
      return SnippetDescriptionDialog(textEditingController: TextEditingController(), note: note, onDescriptionChanged: callback);
  });

  Future<String> _showAddSnippetDialog(BuildContext context, Function(String) callback) =>
    showDialog(context: context, 
      builder: (context){
        return AddSnippetDialog(controller: TextEditingController(), onSnippetAdded: callback);
  });

}





 
