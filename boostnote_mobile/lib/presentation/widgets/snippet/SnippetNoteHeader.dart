import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:boostnote_mobile/data/entity/FolderEntity.dart';
import 'package:boostnote_mobile/not_in_use/SnippetDescriptionDialog.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteNotifier.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/EditTagsDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/NoteInfoDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class SnippetNoteHeader extends StatefulWidget {
 
  final Function(FolderEntity) onFolderChangedCallback;

  List<FolderEntity> folders;
  FolderEntity selectedFolder;

  SnippetNoteHeader({this.folders, this.selectedFolder, this.onFolderChangedCallback});

  @override
  State<StatefulWidget> createState() => _SnippetNoteHeaderState();

}

class _SnippetNoteHeaderState extends State<SnippetNoteHeader> {

  TextEditingController _textEditingController;
  NoteNotifier _noteNotifier;

  @override
  void initState() {
    super.initState();

    _textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    _noteNotifier = Provider.of<NoteNotifier>(context);
    _textEditingController.text = _noteNotifier.note.title; 
    _textEditingController.addListener((){
      _noteNotifier.note.title = _textEditingController.text;
    });

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
                    child: Icon(Icons.folder_open, color: Theme.of(context).iconTheme.color),
                  ),
                  Container(
                    width: 130,
                    child: DropdownButton<FolderEntity> (    //TODO FolderEntity
                      value: this.widget.selectedFolder, 
                      underline: Container(), 
                      iconEnabledColor: Colors.transparent,
                      style: TextStyle(fontSize: 16, color: Theme.of(context).textTheme.display3.color),
                      items: this.widget.folders.map<DropdownMenuItem<FolderEntity>>((folder) => DropdownMenuItem<FolderEntity>(
                        value: folder,
                        child: Text(folder.name)
                      )).toList(),
                      onChanged: (folder) {
                          setState(() {
                            this.widget.selectedFolder = folder;
                          });
                          this.widget.onFolderChangedCallback(folder);
                        }
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
                onPressed: _showTagDialog
              ),
              IconButton(
                icon: Icon(
                  Icons.info_outline, 
                  color: Theme.of(context).iconTheme.color
                ), 
                onPressed: _showNoteInfoDialog
              ),
              IconButton(
                icon: Icon(
                  Icons.description, 
                  color: Theme.of(context).iconTheme.color
                ), 
                onPressed: _showDescriptionDialog)
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

  Future<List<String>> _showNoteInfoDialog() => showDialog(
    context: context, 
    builder: (context){
      return NoteInfoDialog();
  });

  Future<List<String>> _showTagDialog() => showDialog(
    context: context, 
    builder: (context){
      return EditTagsDialog(
        tags: _noteNotifier.note.tags, 
      );
  });
  
  Future<String> _showDescriptionDialog() =>
    showDialog(
      context: context,  
      builder: (context){
        return SnippetDescriptionDialog();
  });

}