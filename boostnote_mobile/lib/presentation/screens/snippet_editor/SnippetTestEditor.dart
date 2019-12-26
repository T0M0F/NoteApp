import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/presentation/screens/overview/OverviewView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/a11y-light.dart';


//TODO: REFACTOR!!!!!!!!!!!!!!!!!!!
class SnippetTestEditor extends StatefulWidget {

  final OverviewView _overview;

  final SnippetNote _note;

  int _index = 0;
  
  SnippetTestEditor(this._note, this._overview);

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
        _createDialog(context, (text){
            this.widget._note.description = text;
            _noteService.save(this.widget._note);
        });
      } else if(action == 'Change Current Snippet Name'){
        _changeCurrentSnippetName(context, _currentSnippet.name+'.'+_currentSnippet.mode, (text){
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
        _changeNoteName(context, this.widget._note, (note){
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
    
      
    
      
        return _tabs.length == 0 ? 
          Scaffold(
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
        )
        : Scaffold(
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
    
      List<Widget> _buildIcon(){
        return _editMode ?
        <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: (){
              setState(() {
                _editMode = false;
                //_tabs[_currentIndex]._editMode = false;
              });
            },
          )
        ]
        : <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                    _addSnippetDialog(context, (text){
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
    
      Future<String> _createDialog(BuildContext context, Function(String) callback) {
        TextEditingController textEditingController = TextEditingController();
        textEditingController.text = this.widget._note.description;
        
      
        return showDialog(context: context,  builder: (context){
          return AlertDialog(
              title: Container( 
              alignment: Alignment.center,
              child: Text('Description', style: TextStyle(color: Colors.black))
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  height: 250,
                  child: TextField(
                    style: TextStyle(),
                    controller: textEditingController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                      border: InputBorder.none,
                      hintText: 'Note'),
                      onChanged: (String text){
                        
                    },
                  ),
                );
              },
            ),
            actions: <Widget>[
              MaterialButton(
                minWidth:100,
                elevation: 5.0,
                color: Color(0xFFF6F5F5),
                child: Text('Cancel', style: TextStyle(color: Colors.black),),
                onPressed: (){
                  Navigator.of(context).pop();
                }
              ),
              MaterialButton(
                minWidth:100,
                elevation: 5.0,
                color: Theme.of(context).accentColor,
                child: Text('Save', style: TextStyle(color: Color(0xFFF6F5F5))),
                onPressed: (){
                  callback(textEditingController.text);
                  Navigator.of(context).pop();
                }
              )
            ],
          );
        });
      }
    
      Future<String> _changeCurrentSnippetName(BuildContext context, String currentName, Function(String) callback) {
        TextEditingController controller = TextEditingController();
        controller.text = currentName;
    
        return showDialog(context: context, 
        builder: (context){
          return AlertDialog(
              title: Container( 
              alignment: Alignment.center,
              child: Text('Change', style: TextStyle(color: Colors.black))
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  height: 75,
                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller: controller,
                        style: TextStyle(color: Colors.black),
                      ), 
                    ],
                  ),
                );
              },
            ),
            actions: <Widget>[
              MaterialButton(
                minWidth:100,
                elevation: 5.0,
                color: Color(0xFFF6F5F5),
                child: Text('Cancel', style: TextStyle(color: Colors.black),),
                onPressed: (){
                  Navigator.of(context).pop();
                }
              ),
              MaterialButton(
                minWidth:100,
                elevation: 5.0,
                color: Theme.of(context).accentColor,
                child: Text('Save', style: TextStyle(color: Color(0xFFF6F5F5))),
                onPressed: (){
                  if(controller.text.trim().length > 0){
                    callback(controller.text); 
                  }
                }
              )
            ],
          );
        });
        }
    
        Future<String> _addSnippetDialog(BuildContext context, Function(String) callback) {
        TextEditingController controller = TextEditingController();
    
        return showDialog(context: context, 
        builder: (context){
          return AlertDialog(
              title: Container( 
              alignment: Alignment.center,
              child: Text('Create a Code Snippet', style: TextStyle(color: Colors.black))
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  height: 75,
                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller: controller,
                        style: TextStyle(color: Colors.black),
                      ), 
                    ],
                  ),
                );
              },
            ),
            actions: <Widget>[
              MaterialButton(
                minWidth:100,
                elevation: 5.0,
                color: Color(0xFFF6F5F5),
                child: Text('Cancel', style: TextStyle(color: Colors.black),),
                onPressed: (){
                  Navigator.of(context).pop();
                }
              ),
              MaterialButton(
                minWidth:100,
                elevation: 5.0,
                color: Theme.of(context).accentColor,
                child: Text('Save', style: TextStyle(color: Color(0xFFF6F5F5))),
                onPressed: (){
                  if(controller.text.trim().length > 0){
                    callback(controller.text); 
                  }
                }
              )
            ],
          );
        });
        }
    
      Future<SnippetNote> _changeNoteName(BuildContext context, SnippetNote note, Function(SnippetNote) callback) {
        TextEditingController controller = TextEditingController();
        controller.text = note.title;
    
        return showDialog(context: context, 
          builder: (context){
            return AlertDialog(
              title: Container( 
                alignment: Alignment.center,
                child: Text('Edit Note', style: TextStyle(color: Colors.black))
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Container(
                    height: 75,
                    child: Column(
                      children: <Widget>[
                        TextField(
                          controller: controller,
                          style: TextStyle(color: Colors.black),
                        ), 
                      ],
                    ),
                  );
                },
              ),
              actions: <Widget>[
              MaterialButton(
                  minWidth:100,
                  elevation: 5.0,
                  color: Color(0xFFF6F5F5),
                  child: Text('Cancel', style: TextStyle(color: Colors.black),),
                  onPressed: (){
                    Navigator.of(context).pop();
                  }
                ),
                MaterialButton(
                  minWidth:100,
                  elevation: 5.0,
                  color: Theme.of(context).accentColor,
                  child: Text('Save', style: TextStyle(color: Color(0xFFF6F5F5))),
                  onPressed: (){
                    if(controller.text.trim().length > 0){
                      note.title = controller.text;
                      callback(note); 
                    }
                  }
                )
              ],
            );
        });
      }
}


class CodeTab extends StatefulWidget{

  final CodeSnippet _codeSnippet;
  bool _editMode;
  Function(String) _callback;
  Function(bool) _modeChange;

  CodeTab(this._codeSnippet, this._editMode, this._callback, this._modeChange);

  @override
  State<StatefulWidget> createState() => CodeTabState();
  
}
  
class CodeTabState extends State<CodeTab> {

  @override
  void initState(){
    super.initState();

  }
  
  @override
  Widget build(BuildContext context) {
  TextEditingController textEditingController = TextEditingController();
  textEditingController.text = this.widget._codeSnippet.content;

  return this.widget._editMode ? 
    Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      child: TextField(
        autofocus: true,
        autocorrect: true,
        style: TextStyle(),
        controller: textEditingController,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          border: InputBorder.none),
        onChanged: (String text){
          this.widget._callback(text);
        },
        onEditingComplete: (){
          print('EDITING COMPLETED');
        },
        onSubmitted: (text){
          print('SUBMITTED');
        },
      ),
    ) :
    GestureDetector(
      onTap: (){
        setState(() {
          print('onTap');
          this.widget._editMode = !this.widget._editMode;
          this.widget._modeChange(this.widget._editMode);
        });
      },
      child: HighlightView(
        this.widget._codeSnippet.content,
        language: this.widget._codeSnippet.mode,
        theme: a11yLightTheme,
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        textStyle: TextStyle(
                    fontFamily: 'My awesome monospace font',
                    fontSize: 16,
        )
      )
    );
  }
}