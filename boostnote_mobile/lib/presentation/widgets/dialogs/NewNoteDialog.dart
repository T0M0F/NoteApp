import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:boostnote_mobile/business_logic/service/FolderService.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:boostnote_mobile/presentation/notifiers/FolderNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteOverviewNotifier.dart';
import 'package:boostnote_mobile/presentation/widgets/buttons/CancelButton.dart';
import 'package:boostnote_mobile/presentation/widgets/buttons/SaveButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateNoteDialog extends StatefulWidget {

  static const int _MARKDOWNNOTE = 1;
  static const int _SNIPPETNOTE = 2;

  @override
  _CreateNoteDialogState createState() => _CreateNoteDialogState();
}

class _CreateNoteDialogState extends State<CreateNoteDialog> {

  final TextEditingController controller = TextEditingController();
  NoteService _noteService = NoteService();
  NoteNotifier _noteNotifier;
  FolderNotifier _folderNotifier;
  NoteOverviewNotifier _noteOverviewNotifier;

  int groupvalue = CreateNoteDialog._MARKDOWNNOTE;

  @override
  Widget build(BuildContext context) {
    _folderNotifier = Provider.of<FolderNotifier>(context);
    _noteNotifier = Provider.of<NoteNotifier>(context);
    _noteOverviewNotifier = Provider.of<NoteOverviewNotifier>(context);

    return AlertDialog(
      title: Container( 
        alignment: Alignment.center,
        child: Text(AppLocalizations.of(context).translate('make_a_note'), style: TextStyle(color:  Theme.of(context).textTheme.display1.color))
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context).translate('enter_title'),
                    hintStyle: Theme.of(context).textTheme.display2
                  ),
                  controller: controller,
                  style: TextStyle(color:  Theme.of(context).textTheme.display1.color),
                ), 
                RadioListTile(
                  title: Text(AppLocalizations.of(context).translate('markdown_note'), style: TextStyle(color:  Theme.of(context).textTheme.display1.color)),
                  value: 1,
                  groupValue: groupvalue,
                  onChanged: (int value) {
                    setState(() {
                      groupvalue = CreateNoteDialog._MARKDOWNNOTE;
                    });
                  },
                ),
                RadioListTile(
                  title: Text(AppLocalizations.of(context).translate('snippet_note'), style: TextStyle(color:  Theme.of(context).textTheme.display1.color)),
                  groupValue: groupvalue,
                  value: 2,
                  onChanged: (int value) {
                    setState(() {
                      groupvalue = CreateNoteDialog._SNIPPETNOTE;
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
      actions: <Widget>[
        CancelButton(),
        SaveButton(save: _save)
      ],
    );
  }
 
  void _save(){
    if(controller.text.trim().length > 0){
      if(_folderNotifier.selectedFolder != null) {
        Note note;
        if(groupvalue == CreateNoteDialog._MARKDOWNNOTE){
          note = MarkdownNote(
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            folder: _folderNotifier.selectedFolder,
            title: controller.text.trim(),
            tags: [],
            isStarred: false,
            isTrashed: false,
            content: ''
          );
        } else {
          note = SnippetNote(
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            folder: _folderNotifier.selectedFolder,
            title: controller.text.trim(),
            tags: [],
            isStarred: false,
            isTrashed: false,
            description: '',
            codeSnippets: []
          );
        }
        //if(widget.tag != null) note.tags.add(widget.tag); //TODO
        // if(widget.folder != null) note.folder = widget.folder;  //TODO
        _noteService.save(note);
        _noteOverviewNotifier.notes.add(note);
        _noteOverviewNotifier.notesCopy.add(note);
        _noteNotifier.note = note;
        Navigator.of(context).pop();
          
      } else {
        FolderService().findDefaultFolder().then((folder) {
          Note note;
          if(groupvalue == CreateNoteDialog._MARKDOWNNOTE){
            note = MarkdownNote(
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              folder: folder,
              title: controller.text.trim(),
              tags: [],
              isStarred: false,
              isTrashed: false,
              content: ''
            );
          } else {
            note = SnippetNote(
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              folder: folder,
              title: controller.text.trim(),
              tags: [],
              isStarred: false,
              isTrashed: false,
              description: '',
              codeSnippets: []
            );
          }
          //if(widget.tag != null) note.tags.add(widget.tag); //TODO
          // if(widget.folder != null) note.folder = widget.folder;  //TODO
          _noteService.save(note);
          _noteOverviewNotifier.notes.add(note);
          _noteOverviewNotifier.notesCopy.add(note);
          _noteNotifier.note = note;
          Navigator.of(context).pop();
        });
      }
    }
  }
}