import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/presentation/screens/overview/OverviewView.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/AddSnippetDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/EditSnippetNameDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/EditSnippetNoteDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/SnippetDescriptionDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/snippet/CodeTab.dart';
import 'package:flutter/material.dart';


//TODO Refactor
class SnippetTestEditor extends StatefulWidget {

  final OverviewView _overview;

  final SnippetNote _note;

  int _index = 0;
  
  SnippetTestEditor(this._note, this._overview);  //TODO: Constructor

  SnippetTestEditor.startAt(this._note, this._index, this._overview);

  @override
  _SnippetTestEditorState createState() => new _SnippetTestEditorState();
}

class _SnippetTestEditorState extends State<SnippetTestEditor> with TickerProviderStateMixin {

  int _screen = 0;
  
  List<CodeTab> _tabs;
  List<Widget> _tabNames;
  CodeSnippet _currentSnippet;
  int _currentIndex = 0;

  bool _editMode = false;
  NoteService _noteService = NoteService();
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _currentSnippet = this.widget._note.codeSnippets[0];

    _tabNames = _getTabnames();

    _tabController = TabController(    //TODO move to init
      initialIndex: widget._index,
      length: _tabNames.length, 
      vsync: this
    );
    _tabController.addListener((){
      print('Change');
      setState(() {
        _editMode = false;
      });
    });

  
  }

  List<CodeTab> _getTabs(){
    _tabs = List();
   
    List<CodeSnippet> codeSnippets = this.widget._note.codeSnippets;
    for(CodeSnippet snippet in codeSnippets){
      _tabs.add(CodeTab(snippet, _editMode, (text){
      
      },
      (bool){
         setState(() {
                _editMode = bool;
              });
      }));
    }
    return _tabs;
  }

  List<Widget> _getTabnames(){
    _tabNames = List();

    List<CodeSnippet> codeSnippets = this.widget._note.codeSnippets;
    for(CodeSnippet snippet in codeSnippets){
        _tabNames.add(Tab( text: snippet.name+'.'+snippet.mode));
    }
    return _tabNames;
  }

   void _selectedAction(String action){
      if(action == 'Delete Note'){
        _noteService.delete(this.widget._note);
        this.widget._overview.refresh();
        Navigator.of(context).pop();
      }  else if(action == 'Delete Curent Tab'){
        setState(() {
          this.widget._note.codeSnippets.remove(_currentSnippet);
          _tabs.removeAt(_currentIndex);
          _tabNames.removeAt(_currentIndex);
          _currentSnippet = this.widget._note.codeSnippets[_currentIndex];
          _noteService.save(this.widget._note);
        });
      } else if(action == 'Save'){
        _noteService.save(this.widget._note);
        this.widget._overview.refresh();
      Navigator.of(context).pop();
      } else if(action == 'Description'){
        _showDescriptionDialog(context, this.widget._note, (text){
            this.widget._note.description = text;
            _noteService.save(this.widget._note);
        });
      } else if(action == 'Change Current Snippet Name'){
        _showEditNameDialog(context, _currentSnippet.name+'.'+_currentSnippet.mode, (text){
          setState(() {
              List<String> s = text.split('.');
           if(s.length > 1){
             _currentSnippet.name = s[0];
             _currentSnippet.mode = s[1];
           } else {
              _currentSnippet.name = text;
              _currentSnippet.mode = '';
           }
           _noteService.save(this.widget._note);

            _tabs[_currentIndex] = CodeTab(_currentSnippet, _editMode, (text){
              
            },
            (bool){
              setState(() {
                _editMode = bool;
              });
            });
           _tabNames[_currentIndex] =  Tab( text: _currentSnippet.name+'.'+_currentSnippet.mode);
          });
           Navigator.of(context).pop();
        });
      } else if (action == 'Edit Note'){
        _showEditNoteDialog(context, this.widget._note, (note){
             setState((){
               setState(() {
                 this.widget._note.title = note.title;
               });
               _noteService.save(note);
             });
              Navigator.of(context).pop();
          });
        }
      }

        
          
  @override
  Widget build(BuildContext context) {
    _tabs = _getTabs();

    if (_tabs.length == 0) {
      return buildEmptyBody(context);
    } else {
      return buildBody(context);
    }
  }

  Scaffold buildBody(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text(this.widget._note.title),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Color(0xFFF6F5F5)), 
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      actions: _buildIcon()
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabs
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AnimatedCrossFade(
            firstChild: Material(
              color: Theme
                .of(context)
                .primaryColor,
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabs: _tabNames,
                onTap: (int) {
                  _currentSnippet = this.widget._note.codeSnippets[int];
                  _currentIndex = int;
                  setState(() {
                      _editMode = false;
                  });
                },
              ),
            ),
            secondChild: Container(),
            crossFadeState: _screen == 0
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  Scaffold buildEmptyBody(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text(this.widget._note.title),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Color(0xFFF6F5F5)), 
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            setState(() {
              this.widget._note.codeSnippets.add(new CodeSnippet(linesHighlighted: new List(),
                                                            name: 'Code',
                                                            mode: 'java',
                                                            content: 'content'));
              Navigator.of(context).pushReplacement(
                  PageRouteBuilder(
                      pageBuilder: (c, a1, a2) =>  SnippetTestEditor.startAt(this.widget._note, this.widget._note.codeSnippets.length-1, this.widget._overview),
                      transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                      transitionDuration: Duration(milliseconds: 0),
                  ),
              );
            });
          },
        ),
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert),
          onSelected: _selectedAction,
          itemBuilder: (BuildContext context) {
            return <PopupMenuEntry<String>>[
              PopupMenuItem(
                value: 'Save',
                child: ListTile(
                  title: Text('Save')
                )
              ),
              PopupMenuItem(
                value: 'Delete Note',
                child: ListTile(
                  title: Text('Delete')
                )
              ),
              PopupMenuItem(
                value: 'Delete Curent Tab',
                child: ListTile(
                  title: Text('Delete Curent Tab')
                )
              ),
              PopupMenuItem(
                value: 'Change Current Snippet Name',
                child: ListTile(
                  title: Text('Change Current Snippet Name')
                )
              ),
              PopupMenuItem(
                value: 'Description',
                child: ListTile(
                  title: Text('Description')
                )
              ),
              PopupMenuItem(
                value: 'Edit Note',
                child: ListTile(
                  title: Text('Edit Note')
                )
              )
            ];
          }
        )
      ],
      ),
      body:Container(),
    );
  }
    
  List<Widget> _buildIcon(){
    if (_editMode) {
      return <Widget>[
        IconButton(
          icon: Icon(Icons.check),
          onPressed: (){
            setState(() {
              _editMode = false;
              //_tabs[_currentIndex]._editMode = false;
            });
          },
        )
      ];
    } else {
      return <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
              _showAddSnippetDialog(context, (text){
                setState(() {
                  List<String> s = text.split('.');
                  if(s.length > 1){
                      this.widget._note.codeSnippets.add(new CodeSnippet(linesHighlighted: new List(),
                                                                name: s[0],
                                                                mode: s[1],
                                                                content: ''));
                  } else {
                      this.widget._note.codeSnippets.add(new CodeSnippet(linesHighlighted: new List(),
                                                                name: text,
                                                                mode: '',
                                                                content: ''));
                  }
                  
                  Navigator.of(context).pushReplacement(
                    PageRouteBuilder(
                        pageBuilder: (c, a1, a2) =>  SnippetTestEditor.startAt(this.widget._note, this.widget._note.codeSnippets.length-1, this.widget._overview),
                        transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                        transitionDuration: Duration(milliseconds: 0),
                      ),
                  );
                
                /* _tabs.add(Container());
                  _tabNames.add(Tab( text: 'new'));*/
                });
              });
          },
        ),
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert),
          onSelected: _selectedAction,
          itemBuilder: (BuildContext context) {
            return <PopupMenuEntry<String>>[
              PopupMenuItem(
                value: 'Save',
                child: ListTile(
                  title: Text('Save')
                )
              ),
              PopupMenuItem(
                value: 'Delete Note',
                child: ListTile(
                  title: Text('Delete')
                )
              ),
              PopupMenuItem(
                value: 'Delete Curent Tab',
                child: ListTile(
                  title: Text('Delete Curent Tab')
                )
              ),
              PopupMenuItem(
                value: 'Change Current Snippet Name',
                child: ListTile(
                  title: Text('Change Current Snippet Name')
                )
              ),
              PopupMenuItem(
                value: 'Description',
                child: ListTile(
                  title: Text('Description')
                )
              ),
              PopupMenuItem(
                value: 'Edit Note',
                child: ListTile(
                  title: Text('Edit Note')
                )
              )
            ];
          }
        )
      ];
    }
  }
    

  Future<String> _showDescriptionDialog(BuildContext context, SnippetNote note, Function(String) callback) =>
    showDialog(context: context,  builder: (context){
      return SnippetDescriptionDialog(textEditingController: TextEditingController(), note: note, onDescriptionChanged: callback);
  });


  Future<String> _showEditNameDialog(BuildContext context, String currentName, Function(String) callback) =>
    showDialog(context: context, 
      builder: (context){
        return EditSnippetNameDialog(textEditingController: TextEditingController(), noteTitle: currentName, onNameChanged: callback,);
  });
    

  Future<String> _showAddSnippetDialog(BuildContext context, Function(String) callback) =>
    showDialog(context: context, 
      builder: (context){
        return AddSnippetDialog(controller: TextEditingController(), onSnippetAdded: callback);
  });
    

  Future<SnippetNote> _showEditNoteDialog(BuildContext context, SnippetNote note, Function(SnippetNote) callback) => 
    showDialog(context: context, 
      builder: (context){
        return EditSnippetNoteDialog(textEditingController: TextEditingController(), note: note, onNoteChanged: callback);
  });
  
}





