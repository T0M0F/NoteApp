import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:boostnote_mobile/presentation/screens/editor/snippet_editor/widgets/OverflowButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CodeSnippetAppBar extends StatefulWidget implements PreferredSizeWidget{

  final Function() onNavigateBackCallback;
  final Function(String) selectedActionCallback;
  final Function(CodeSnippet) onSelectedSnippetChanged;

  SnippetNote note;
  CodeSnippet selectedCodeSnippet;

  CodeSnippetAppBar({@required this.note,@required this.selectedCodeSnippet, this.onNavigateBackCallback, this.selectedActionCallback, this.onSelectedSnippetChanged});

  @override
  _CodeSnippetAppBarState createState() => _CodeSnippetAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CodeSnippetAppBarState extends State<CodeSnippetAppBar> {
  @override
  Widget build(BuildContext context) { 
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).backgroundColor,
      brightness: Brightness.light,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryColorLight), 
        onPressed: widget.onNavigateBackCallback
      ),
      actions: _buildActions()
    );
  }


  List<Widget> _buildActions() {
    List<Widget> actions = <Widget>[
      OverflowButton(
        noteIsStarred: this.widget.note.isStarred, 
        selectedActionCallback: this.widget.selectedActionCallback
      )
    ];

    if(this.widget.selectedCodeSnippet != null) {

      Widget row = Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 5), 
            child: Icon(Icons.code,  color: Theme.of(context).primaryColorLight,)
          ),
          DropdownButton<CodeSnippet> (  
            value: widget.selectedCodeSnippet, 
            underline: Container(), 
            iconEnabledColor:  Colors.black,
            style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
            items: widget.note.codeSnippets.map<DropdownMenuItem<CodeSnippet>>((codeSnippet) {
              Widget item = DropdownMenuItem<CodeSnippet>(
                value: codeSnippet,
                child:  Text(
                  codeSnippet.name, 
                  style: TextStyle(
                    fontSize: 16, 
                    color: Colors.black, 
                    fontWeight: FontWeight.bold
                  )
                ),
              );
              return item;
            }).toList(),
            onChanged: (CodeSnippet codeSnippet) => widget.onSelectedSnippetChanged(codeSnippet),
          ),
        ],
      );

      actions.insert(0, row);
    }

    return actions;
  }
}