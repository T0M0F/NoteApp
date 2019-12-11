import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';



class SnippetTestEditor extends StatefulWidget {

  final SnippetNote _note;

  int _index = 0;
  
  SnippetTestEditor(this._note);

  SnippetTestEditor.startAt(this._note, this._index);

  @override
  _SnippetTestEditorState createState() => new _SnippetTestEditorState();
}

/*
const List<String> tabNames = const<String>[
  'foo', 'bar', 'baz', 'quox', 'quuz', 'corge', 'grault', 'garply', 'waldo'
];
*/

class _SnippetTestEditorState extends State<SnippetTestEditor> {

  int _screen = 0;

  int _tabIndex = 0;
  
  List<Widget> _tabs;
  List<Widget> _tabNames;

  @override
  void initState() {
    super.initState();

    _tabs = List();
    _tabNames = List();

    List<CodeSnippet> codeSnippets = this.widget._note.codeSnippets;
    for(CodeSnippet snippet in codeSnippets){
      _tabs.add(CodeTab(snippet));
      _tabNames.add(Tab( text: snippet.name+'.'+snippet.mode));
    }
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: this.widget._index,
      length: _tabNames.length,
      child: Scaffold(
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
                       pageBuilder: (c, a1, a2) =>  SnippetTestEditor.startAt(this.widget._note, this.widget._note.codeSnippets.length-1),
                       transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                       transitionDuration: Duration(milliseconds: 0),
                    ),
                );
               
               /* _tabs.add(Container());
                _tabNames.add(Tab( text: 'new'));*/
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          )
        ],
       ),
        body: TabBarView(
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
                  isScrollable: true,
                  tabs: _tabNames
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
      ),
    );
  }
}

class CodeTab extends StatefulWidget{

  final CodeSnippet _codeSnippet;

  CodeTab(this._codeSnippet);

  @override
  State<StatefulWidget> createState() => CodeTabState();
  
}
  
class CodeTabState extends State<CodeTab>{
  
  @override
  Widget build(BuildContext context) {
    return HighlightView(
      this.widget._codeSnippet.content,
      language: this.widget._codeSnippet.mode,
      theme: githubTheme,
      padding: EdgeInsets.all(10),
      textStyle: TextStyle(
                  fontFamily: 'My awesome monospace font',
                  fontSize: 16,
      )
    );
  }
}