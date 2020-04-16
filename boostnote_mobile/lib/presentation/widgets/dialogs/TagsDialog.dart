
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/TagsNotifier.dart';
import 'package:boostnote_mobile/presentation/widget/buttons/CancelButton.dart';
import 'package:boostnote_mobile/presentation/widgets/buttons/SaveButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TagsDialog extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _TagsDialogState();
}

class _TagsDialogState extends State<TagsDialog> {
  TextEditingController _textEditingController;
  List<String> _tags;

  NoteNotifier _noteNotifier;
  TagsNotifier _tagsNotifier;

  @override
  Widget build(BuildContext context) {
    _noteNotifier = Provider.of<NoteNotifier>(context);
    _tagsNotifier = Provider.of<TagsNotifier>(context);
    _textEditingController = TextEditingController();
    _textEditingController.text = _convertTagListToTagString(_noteNotifier.note.tags);
    _tags = _noteNotifier.note.tags;

    return AlertDialog(
      title: _buildTitle(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: _buildContent(),
      actions: _buildActions(context),
    );
  }

  String _convertTagListToTagString(List<String> tags) {
    tags.forEach((tag) => print(tag));
    List<String> tagsWithHashtag = tags.map((tag) => '#'+tag+' ').toList();
    String tagString = '';
    tagsWithHashtag.forEach((tag) => tagString = tagString + tag);
    print(tagString);
    return tagString;
  }

  Container _buildTitle() {
    return Container( 
      alignment: Alignment.center,
      child: Text(AppLocalizations.of(context).translate('tags'), style: TextStyle(color: Theme.of(context).textTheme.display1.color))
    );
  }

  StatefulBuilder _buildContent() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return TextField(
            style: Theme.of(context).textTheme.display1,
            controller: _textEditingController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(0),
              border: InputBorder.none,
              hintText: '#' + AppLocalizations.of(context).translate('tag')
            ),
            onChanged: (String tags){
              _tags = convertTagStringToTagList(tags);
            },
          );
      },
    );
  }

  List<String> convertTagStringToTagList(String tagsString) {
    List<String> tagsList = tagsString.trim().split('#');
    tagsList.removeWhere((tag) => tag.isEmpty);
    tagsList.forEach((tag) => tag.trim());
    return tagsList;
  }

  List<Widget> _buildActions(BuildContext context) {
    return <Widget>[
      CancelButton(),
      SaveButton(save: () {
        _tagsNotifier.tags = _tags ?? List();
        _noteNotifier.note.tags = _tags ?? List();
        NoteService().save(_noteNotifier.note);
        Navigator.of(context).pop();
      })
    ];
  }
  
}