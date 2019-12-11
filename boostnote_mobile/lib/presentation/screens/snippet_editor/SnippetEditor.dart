

import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';

class SnippetEditor extends StatefulWidget{

  final SnippetNote _note;
  
  const SnippetEditor(this._note);
  
  @override
  State<StatefulWidget> createState() => SnippetEditorState();
    
}
  

class SnippetEditorState extends State<SnippetEditor>{

  int _tabIndex = 0;
  List<Widget> _tabs;
  List<BottomNavigationBarItem> _tabItems;

  @override
  void initState() {
    super.initState();
    _tabs = List();
    _tabItems = List();
    List<CodeSnippet> codeSnippets = this.widget._note.codeSnippets;
    for(CodeSnippet snippet in codeSnippets){
      _tabs.add(CodeTab(snippet));
      _tabItems.add(BottomNavigationBarItem(
        icon: Icon(Icons.code),
        title: Text(snippet.name+'.'+snippet.mode)
      ));
    }
    _tabItems.add(BottomNavigationBarItem(
      title: Text('Add'), 
      icon: Icon(Icons.add)
    ));
  }

  @override
  Widget build(BuildContext context) {

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
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            flex: 1, 
            child: Container(
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  border: InputBorder.none,
                  hintText: 'Description'
                ),
              ),
            )
          ),
          Divider(
            height: 1.0,
            thickness: 1,
            color: Colors.grey,
          ),
          Flexible(
            flex: 4,
            child: _tabs[_tabIndex],
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).accentColor,
        selectedIconTheme: IconThemeData(color: Theme.of(context).accentColor),
        unselectedItemColor: Color(0xFFF6F5F5),
        unselectedIconTheme: IconThemeData(color: Color(0xFFF6F5F5)),
        items: _tabItems,
        currentIndex: _tabIndex,
        backgroundColor: Theme.of(context).primaryColor,
        onTap: (int index) {
          if(index < _tabItems.length-1){
            setState(() {
              _tabIndex = index;
            });
          } else {
            CodeSnippet snippet = CodeSnippet(name: 'Test', mode: 'dart', content: '');
            setState(() {
              _tabs.insert(_tabs.length-1, CodeTab(snippet));
              _tabItems.insert(_tabs.length-1, BottomNavigationBarItem(
                                                icon: Icon(Icons.code),
                                                title: Text(snippet.name+'.'+snippet.mode)
                                              )
              );
            });
          }
        },
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