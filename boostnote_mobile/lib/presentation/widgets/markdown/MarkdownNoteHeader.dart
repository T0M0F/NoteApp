import 'package:boostnote_mobile/data/entity/FolderEntity.dart';
import 'package:boostnote_mobile/presentation/notifiers/MarkdownEditorNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteNotifier.dart';
import 'package:boostnote_mobile/presentation/pages/PageNavigator.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/EditTagsDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/NoteInfoDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class MarkdownNoteHeader extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _MarkdownNoteHeaderState();

}

class _MarkdownNoteHeaderState extends State<MarkdownNoteHeader> {

  TextEditingController _textEditingController;
  NoteNotifier _noteNotifier;
  MarkdownEditorNotifier _markdownEditorNotifier;
  PageNavigator _pageNavigator;

  @override
  void initState() {
    super.initState();

    _textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    _noteNotifier = Provider.of<NoteNotifier>(context);
    _markdownEditorNotifier = Provider.of<MarkdownEditorNotifier>(context);
    _pageNavigator = PageNavigator();
    _textEditingController.text = _noteNotifier.note.title; 
    _textEditingController.addListener(() => _noteNotifier.note.title = _textEditingController.text);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
        child: Column(
        children: _getWidgets()
      ),
    );
  }

  void _changeFolder(folder)  {
    _noteNotifier.note.folder = folder;
    _markdownEditorNotifier.selectedFolder = folder;
  }

  Future<List<String>> _showTagDialog(BuildContext context) => showDialog(
    context: context, 
    builder: (context){
      return EditTagsDialog();
  });

  Future<List<String>> _showNoteInfoDialog() => showDialog(
    context: context, 
    builder: (context){
      return NoteInfoDialog();
  });

  List<Widget> _getWidgets() {
    List<Widget> widgets = <Widget>[
      Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.only(left: 10),
          child: TextField(
            controller: _textEditingController,
            style: TextStyle(
              fontSize: 20, 
              color: Theme.of(context).textTheme.display3.color
            ),
            maxLength: 100,
            decoration: null
          ),
        ),
      ),
      FractionallySizedBox(
        widthFactor: 0.95,
        child: Container(
          height: 1,
          color: Theme.of(context).dividerColor
        ),
      )
    ];
    Widget widgetToBeInserted;
    if(_pageNavigator.pageNavigatorState == PageNavigatorState.TRASH) {
       widgetToBeInserted = Row( 
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            children: <Widget>[
                IconButton(
                  icon: Icon(
                    MdiIcons.tagOutline, 
                    color: Theme.of(context).iconTheme.color
                  ), 
                  onPressed: () => _showTagDialog(context)
                ),
                IconButton(
                  icon: Icon(
                    Icons.info_outline, 
                    color: Theme.of(context).iconTheme.color
                  ), 
                  onPressed: () => _showNoteInfoDialog()
                )
              ],
            ),
        ],
      );
    } else {
      widgetToBeInserted = Row( 
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 10),
            child:  Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 5), 
                  child: Icon(Icons.folder_open, color:  Theme.of(context).iconTheme.color),
                ),
                Container(
                  width: 130,
                  child: DropdownButton<FolderEntity> (    //TODO FolderEntity
                    value: _markdownEditorNotifier.selectedFolder, 
                    underline: Container(), 
                    iconEnabledColor: Colors.transparent,
                    style: TextStyle(fontSize: 16, color: Theme.of(context).textTheme.display3.color),
                    items: (_markdownEditorNotifier.folders ?? List()).map<DropdownMenuItem<FolderEntity>>((folder) => DropdownMenuItem<FolderEntity>(
                      value: folder,
                      child: Text(folder.name)
                  )).toList(),
                  onChanged: _changeFolder
                ),
              )
            ],
          )
        ),
        Row(
          children: <Widget>[
              IconButton(
                icon: Icon(
                  MdiIcons.tagOutline, 
                  color: Theme.of(context).iconTheme.color
                ), 
                onPressed: () => _showTagDialog(context)
              ),
              IconButton(
                icon: Icon(
                  Icons.info_outline, 
                  color: Theme.of(context).iconTheme.color
                ), 
                onPressed: () => _showNoteInfoDialog()
              )
            ],
          ),
        ],
      );
    }
    widgets.insert(1, widgetToBeInserted);
    return widgets;
  }

}