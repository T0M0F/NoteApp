import 'package:boostnote_mobile/data/entity/FolderEntity.dart';
import 'package:boostnote_mobile/presentation/notifiers/MarkdownEditorNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteNotifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class MarkdownNoteHeader extends StatefulWidget {

  final Function() onInfoClickedCallback;
  final Function() onTagClickedCallback;

  MarkdownNoteHeader({this.onInfoClickedCallback, this.onTagClickedCallback});

  @override
  State<StatefulWidget> createState() => _MarkdownNoteHeaderState();

}

class _MarkdownNoteHeaderState extends State<MarkdownNoteHeader> {

  TextEditingController _textEditingController;
  NoteNotifier _noteNotifier;
  MarkdownEditorNotifier _markdownEditorNotifier;

  @override
  void initState() {
    super.initState();

    _textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    _noteNotifier = Provider.of<NoteNotifier>(context);
    _markdownEditorNotifier = Provider.of<MarkdownEditorNotifier>(context);
    _textEditingController.text = _noteNotifier.note.title; 
    _textEditingController.addListener(() => _noteNotifier.note.title = _textEditingController.text);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Column(
      children: <Widget>[
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
        Row( 
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
                  onPressed: this.widget.onTagClickedCallback
                ),
                IconButton(
                  icon: Icon(
                    Icons.info_outline, 
                    color: Theme.of(context).iconTheme.color
                  ), 
                  onPressed: this.widget.onInfoClickedCallback
                )
              ],
            ),
          ],
        ),
        FractionallySizedBox(
          widthFactor: 0.95,
          child: Container(
            height: 1,
            color: Theme.of(context).dividerColor
          ),
        )
      ],
    ),
    );
  }

  void _changeFolder(folder)  {
                      _noteNotifier.note.folder = folder;
                      _markdownEditorNotifier.selectedFolder = folder;
                    }

}