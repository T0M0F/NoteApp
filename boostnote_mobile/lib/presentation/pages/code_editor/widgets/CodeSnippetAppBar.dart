import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/SnippetNotifier.dart';
import 'package:boostnote_mobile/presentation/pages/code_editor/widgets/OverflowButton.dart';
import 'package:boostnote_mobile/presentation/responsive/DeviceWidthService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class CodeSnippetAppBar extends StatefulWidget implements PreferredSizeWidget{

  final Function(String) selectedActionCallback;

  CodeSnippetAppBar({this.selectedActionCallback});

  @override
  _CodeSnippetAppBarState createState() => _CodeSnippetAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CodeSnippetAppBarState extends State<CodeSnippetAppBar> {

  NoteNotifier _noteNotifier;
  SnippetNotifier _snippetNotifier;

  @override
  Widget build(BuildContext context) { 
    _initNotifiers();
    return _buildWidget();
  }

  void _initNotifiers() {
    _noteNotifier = Provider.of<NoteNotifier>(context);
    _snippetNotifier = Provider.of<SnippetNotifier>(context);
  }

  Widget _buildWidget() {
    return AppBar(
      leading: _buildLeadingIcon(),
      actions: _buildActions()
    );
  }
  
  List<Widget> _buildActions() {
    List<Widget> actions = <Widget>[
      OverflowButton(
        noteIsStarred: _noteNotifier.note.isStarred, 
        selectedActionCallback: this.widget.selectedActionCallback,
        snippetSelected: _snippetNotifier.selectedCodeSnippet != null,
      )
    ];

    if(_snippetNotifier.selectedCodeSnippet != null) {

      Widget row = Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 5), 
            child: Icon(Icons.code,  color: Theme.of(context).buttonColor,)
          ),
          DropdownButton<CodeSnippet> (  
            value: _snippetNotifier.selectedCodeSnippet, 
            underline: Container(), 
            iconEnabledColor:  Theme.of(context).buttonColor,
            style: TextStyle(fontSize: 16, color: Theme.of(context).textTheme.display1.color , fontWeight: FontWeight.bold),
            items: (_noteNotifier.note as SnippetNote).codeSnippets.map<DropdownMenuItem<CodeSnippet>>((codeSnippet) {
              Widget item = DropdownMenuItem<CodeSnippet>(
                value: codeSnippet,
                child:  Text(
                  codeSnippet.name ?? '', 
                  style: TextStyle(
                    fontSize: 16, 
                    color: Theme.of(context).textTheme.display1.color, 
                    fontWeight: FontWeight.bold
                  )
                ),
              );
              return item;
            }).toList(),
            onChanged: (CodeSnippet codeSnippet) => _snippetNotifier.selectedCodeSnippet = codeSnippet,
          ),
        ],
      );

      actions.insert(0, row);
    }

    return actions;
  }

   Widget _buildLeadingIcon() {
    if(DeviceWidthService(context).isTablet()) {
      return IconButton(
        icon: Icon(_noteNotifier.isEditorExpanded ? MdiIcons.chevronRight : MdiIcons.chevronLeft, color:  Theme.of(context).buttonColor), 
        onPressed:() {
          _noteNotifier.isEditorExpanded = !_noteNotifier.isEditorExpanded;
        },
      );
    } else {
      return IconButton(
        icon: Icon(Icons.arrow_back, color:  Theme.of(context).buttonColor), 
        onPressed:() {
          _noteNotifier.isEditorExpanded = false;
          _snippetNotifier.selectedCodeSnippet = null;
          _noteNotifier.note = null;
        },
      );
    }
  }
}