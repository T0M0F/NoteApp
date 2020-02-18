import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/data/entity/SnippetNoteEntity.dart';
import 'package:boostnote_mobile/presentation/screens/note_overview/Refreshable.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/AddSnippetDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/EditSnippetNameDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/EditSnippetNoteDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/SnippetDescriptionDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/snippet/CodeTab.dart';
import 'package:flutter/material.dart';


//TODO Refactor
class SnippetTestEditor extends StatefulWidget {

  final Refreshable _parentWidget;

  final SnippetNote _note;

  int _index = 0;
  
  SnippetTestEditor(this._note, this._parentWidget);  //TODO: Constructor

  SnippetTestEditor.startAt(this._note, this._index, this._parentWidget);

  @override
  _SnippetTestEditorState createState() => new _SnippetTestEditorState();
}

class _SnippetTestEditorState extends State<SnippetTestEditor> with TickerProviderStateMixin {

  int _screen = 0;
  
  List<CodeTab> _tabs;
  List<Widget> _tabNames;
  CodeSnippet _currentSnippet;
  int _currentIndex;

  bool _editMode = false;
  NoteService _noteService = NoteService();
  TabController _tabController;

  static const String MARK_ACTION = 'Mark Note';
  static const String UNMARK_ACTION = 'Unmark Note';

  @override
  void initState() {  
    super.initState();
    print('init');
    _currentIndex = this.widget._index;
    if(this.widget._note.codeSnippets.length > 0) {
     _currentSnippet = this.widget._note.codeSnippets[_currentIndex];
     print('current Snippet is ' + _currentSnippet.name);
    }

    _tabController = TabController(    
      initialIndex: widget._index,
      length: this.widget._note.codeSnippets.length, 
      vsync: this
    );

    _tabController.addListener((){
      setState(() {
        _editMode = false;
        _currentSnippet.content = _currentSnippet.content; //refresh content of previous snippet
        _currentIndex = _tabController.index;
        _currentSnippet = this.widget._note.codeSnippets[_currentIndex];
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    print('DISPOSE');
    NoteService().save(this.widget._note);
    this.widget._parentWidget.refresh();
  }

  List<CodeTab> _getTabs(){
    _tabs = List();
   
    List<CodeSnippet> codeSnippets = this.widget._note.codeSnippets;
    for(CodeSnippet snippet in codeSnippets){
      _tabs.add(CodeTab(snippet, _editMode, (text){
        print(text);
        _currentSnippet.content = text;
      },
      (bool){
         setState(() {
                _editMode = bool;
                _currentSnippet.content = _currentSnippet.content;
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
        _noteService.moveToTrash(this.widget._note);
        this.widget._parentWidget.refresh();
        Navigator.of(context).pop();
      }  else if(action == 'Delete Curent Tab'){
        /*
        setState(() {
          this.widget._note.codeSnippets.remove(_currentSnippet);
          _tabs.removeAt(_currentIndex);
          _tabNames.removeAt(_currentIndex);
          _currentSnippet = this.widget._note.codeSnippets[_currentIndex];
          _noteService.save(this.widget._note);
        });
        */
        this.widget._note.codeSnippets.remove(_currentSnippet);
        Route route;
        if(this.widget._note.codeSnippets.length > 0) {
          route = PageRouteBuilder(
            pageBuilder: (c, a1, a2) =>  SnippetTestEditor.startAt(this.widget._note, this.widget._note.codeSnippets.length-1, this.widget._parentWidget),
            transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
            transitionDuration: Duration(milliseconds: 0),
          );
        } else  {
          route = PageRouteBuilder(
            pageBuilder: (c, a1, a2) =>  SnippetTestEditor(this.widget._note, this.widget._parentWidget),
            transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
            transitionDuration: Duration(milliseconds: 0),
          );
        } 
        _noteService.save(this.widget._note);
        Navigator.of(context).pushReplacement(route);

      } else if(action == 'Save'){
        _noteService.save(this.widget._note);
        this.widget._parentWidget.refresh();       
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
              print(text);
              _currentSnippet.content = text;
            },
            (bool){
              setState(() {
                      _editMode = bool;
                      _currentSnippet.content = _currentSnippet.content;
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
      } else if (action == UNMARK_ACTION){
        this.widget._note.isStarred = false;
        _noteService.save(this.widget._note);
      } else if (action == MARK_ACTION){
        this.widget._note.isStarred = true;
        _noteService.save(this.widget._note);
      } 
    } 
     
  @override
  Widget build(BuildContext context) {
    _tabs = _getTabs();
    _tabNames = _getTabnames();

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
      body: _buildSnippetBody3(),
      /*Column(
        children: <Widget>[
          Flexible(flex: 1, child: 
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      IconButton(icon: Icon(Icons.folder_open), onPressed: () {}),
                      Text('Notizbuch', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                  children: <Widget>[
                    IconButton(icon: Icon(Icons.label_outline), onPressed: () {}),
                    IconButton(icon: Icon(Icons.info_outline), onPressed: () {})
                    ],
                  ),
                ],
              ),
            )
          ),
          Expanded(flex: 7,
            child: Container(
                    child: 
                      TabBarView(
                        controller: _tabController,
                        children: _tabs
                      )
                  )
          )
        ],
      ),*/
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
                isScrollable: _tabNames.length > 5 ? true : false,
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
        actions: _buildIcon()
      ),
      body:Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(icon: Icon(Icons.folder_open), onPressed: () {}),
                    Text('Notizbuch', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                children: <Widget>[
                  IconButton(icon: Icon(Icons.label_outline), onPressed: () {}),
                  IconButton(icon: Icon(Icons.info_outline), onPressed: () {})
                  ],
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildSnippetBody3(){
      return LayoutBuilder(
      builder: (context, constraint) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 100,
                    alignment: Alignment.center,
                    color: Colors.green,
                    child: Text("Header"),
                  ),
                 Expanded(
                    child:  TabBarView(
                        controller: _tabController,
                        children: <Widget>[
                          TextField(
                            expands: true,
                            maxLines: null,
                            decoration: InputDecoration(
                                fillColor: Colors.blue[200], filled: true),
                          ),
                          TextField(
                            expands: true,
                            maxLines: null,
                            decoration: InputDecoration(
                                fillColor: Colors.blue[200], filled: true),
                          ),
                          TextField(
                            expands: true,
                            maxLines: null,
                            decoration: InputDecoration(
                                fillColor: Colors.blue[200], filled: true),
                          ),
                        ]
                      )
                    )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSnippetBody(){
     return LayoutBuilder(
      builder: (context, constraint) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                children: <Widget>[
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            IconButton(icon: Icon(Icons.folder_open), onPressed: () {}),
                            Text('Notizbuch', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Row(
                        children: <Widget>[
                          IconButton(icon: Icon(Icons.label_outline), onPressed: () {}),
                          IconButton(icon: Icon(Icons.info_outline), onPressed: () {})
                          ],
                        ),
                      ],
                    ),
                  ),
                   Expanded(
                    child: TextField(
                      expands: true,
                      maxLines: null,
                      decoration: InputDecoration(
                          fillColor: Colors.blue[200], filled: true),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

   Widget _buildSnippetBody2(){
     return ListView(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
           Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      IconButton(icon: Icon(Icons.folder_open), onPressed: () {}),
                      Text('Notizbuch', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                  children: <Widget>[
                    IconButton(icon: Icon(Icons.label_outline), onPressed: () {}),
                    IconButton(icon: Icon(Icons.info_outline), onPressed: () {})
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
       Align(
        child: TextField(
                expands: true,
                maxLines: null,
                decoration: InputDecoration(
                    fillColor: Colors.blue[200], filled: true),
              ),
       )
      ],
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
              _currentSnippet.content = _currentSnippet.content;
              //_tabs[_currentIndex]._editMode = false;
            });
          },
        )
      ];
    } else if (this.widget._note.codeSnippets.length > 0 ) {
      return <Widget>[  
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
             _addCodeSnippet();
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
    } else {
      return <Widget>[  
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
             _addCodeSnippet();
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

  void _addCodeSnippet() {  
    _showAddSnippetDialog(context, (text){
      setState(() {
        List<String> s = text.split('.');
        if(s.length > 1){
            this.widget._note.codeSnippets.add(new CodeSnippetEntity(linesHighlighted: new List(),  //TODO CodeSnippetEntity...
                                                      name: s[0],
                                                      mode: s[1],
                                                      content: ''));
        } else {
            this.widget._note.codeSnippets.add(new CodeSnippetEntity(linesHighlighted: new List(),
                                                      name: text,
                                                      mode: '',
                                                      content: ''));
        }

        //This is neccessary, because tabcontrollers length can't change dynamically -> setState() doesn't work.
        Route route = PageRouteBuilder( 
              pageBuilder: (c, a1, a2) =>  SnippetTestEditor.startAt(this.widget._note, this.widget._note.codeSnippets.length-1, this.widget._parentWidget),
              transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: 0),
            );
        Navigator.of(context).pushReplacement(
          route
        );
        Navigator.of(context).removeRouteBelow(route);
      
      /* _tabs.add(Container());
        _tabNames.add(Tab( text: 'new'));*/
      });
    });
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





