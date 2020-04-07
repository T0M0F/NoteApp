import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/business_logic/service/TagService.dart';
import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/TagsNotifier.dart';
import 'package:boostnote_mobile/presentation/widgets/buttons/CancelButton.dart';
import 'package:boostnote_mobile/presentation/widgets/buttons/SaveButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditTagsDialog extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _EditTagsDialogState();
}

class _EditTagsDialogState extends State<EditTagsDialog> {
  TextEditingController _textEditingController;
  List<String> _allTags;
  TagServiceV2 _tagService;

  NoteNotifier _noteNotifier;
  TagsNotifier _tagsNotifier;

  @override
  void initState() {
    super.initState();
    _tagService = TagServiceV2();
    _textEditingController = TextEditingController();
    _allTags = List();
    _tagService.findAll().then((tags) {
      setState(() {
        _allTags = tags;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _noteNotifier = Provider.of<NoteNotifier>(context);
    _tagsNotifier = Provider.of<TagsNotifier>(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Container(
        alignment: Alignment.center,
        child: Text(AppLocalizations.of(context).translate("select_tags"),
            style: TextStyle(
                color: Theme.of(context).textTheme.display1.color))),
      content: ListView.builder(
        itemCount: _allTags.length +1,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                if(index > 0) {
                    _onRowTap(_allTags[index]);
                } 
              },
              child: _buildRow(index)
          );
        },
      ),
      actions: <Widget>[
        CancelButton(),
        SaveButton(save: () {
          Navigator.of(context).pop();
        })
      ],
    );
  }
/*
  @override
  Widget build(BuildContext context) => 
   AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Container( 
        alignment: Alignment.center,
        child: Text(AppLocalizations.of(context).translate("select_tags"), style: TextStyle(color:  Theme.of(context).textTheme.display1.color))
      ),
      content: ConstrainedBox(
        constraints: new BoxConstraints(
          minHeight: 50,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min ,
          children: <Widget>[
            Row(
              children: <Widget>[
                SizedBox(
                  width: 160,
                  child:  TextField(
                    decoration: InputDecoration(hintText: AppLocalizations.of(context).translate("add_tag"), hintStyle: TextStyle(color:  Theme.of(context).textTheme.display2.color)),
                    textInputAction: TextInputAction.done,
                    controller: _textEditingController,
                    style: TextStyle(color: Theme.of(context).textTheme.display1.color),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.check, color: Theme.of(context).buttonColor),
                  onPressed: (){
                    setState(() {
                      _allTags.add(_textEditingController.text);
                    });
                    TagService().createTagIfNotExisting(_textEditingController.text);
                    _textEditingController.clear();
                  },
                )
             ],
            ),
            Container(
              child:  ListView.builder(
                shrinkWrap: true,
                itemCount: _allTags.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _onRowTap(_allTags[index]),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          child: Checkbox(
                            value: _selectedTags.contains(_allTags[index]),
                            onChanged: (bool selected) {
                              setState(() {
                                selected ? _selectedTags.add(_allTags[index]) : _selectedTags.remove(_allTags[index]);
                              });
                            }
                          ),
                        ), 
                        Flexible(
                          flex: 3,
                          child: Text(_allTags[index], style: TextStyle(color: Theme.of(context).textTheme.display1.color))
                        )
                      ],
                    )
                  );
                },
              )
            )
          ],
        ),
       ),
      actions: <Widget>[
        MaterialButton(   //Auslagern
          minWidth:100,
          child: Text(AppLocalizations.of(context).translate("cancel"), style: TextStyle(color: Theme.of(context).textTheme.display1.color)),
          onPressed: (){
            Navigator.of(context).pop();
          }
        ),
        MaterialButton(  //Auslagern
          minWidth:100,
          elevation: 5.0,
          color: Theme.of(context).accentColor,
          child: Text(AppLocalizations.of(context).translate("save"), style: TextStyle(color: Theme.of(context).accentTextTheme.display1.color)),
          onPressed: (){
            this.widget.saveCallback(_selectedTags);
          }
        )
      ],
    );
*/

  void _onRowTap(String tag) {
    _noteNotifier.note.tags.contains(tag)
        ? _noteNotifier.note.tags.remove(tag)
        : _noteNotifier.note.tags.add(tag);
  }

  Widget _buildRow(int index) {
    var selectedTags = _noteNotifier.note.tags;
    if(index > 0) {
      return Row(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Checkbox(
              value: selectedTags.contains(_allTags[index-1]),
              onChanged: (bool selected) {
                List<String> selectedTags;
                if(selected) {
                  selectedTags.add(_allTags[index-1]);
                  _noteNotifier.note.tags = selectedTags;
                } else {
                  selectedTags.remove(_allTags[index-1]);
                  _noteNotifier.note.tags = selectedTags;
                }
              }),
          ),
          Flexible(
            flex: 3,
            child: Text(_allTags[index-1],
              style: TextStyle(
                  color: Theme.of(context)
                      .textTheme
                      .display1
                      .color)
              )
          )
        ],
      );
    } else {
      return Row(
        children: <Widget>[
          SizedBox(
            width: 160,
            child:  TextField(
              decoration: InputDecoration(hintText: AppLocalizations.of(context).translate("add_tag"), hintStyle: TextStyle(color:  Theme.of(context).textTheme.display2.color)),
              textInputAction: TextInputAction.done,
              controller: _textEditingController,
              style: TextStyle(color: Theme.of(context).textTheme.display1.color),
            ),
          ),
          IconButton(
            icon: Icon(Icons.check, color: Theme.of(context).buttonColor),
            onPressed: (){
              setState(() {
                _allTags.add(_textEditingController.text);
              });
              _tagsNotifier.tags = _allTags;
              List<String> selectedTags = _noteNotifier.note.tags;
              selectedTags.add(_textEditingController.text);
              _noteNotifier.note.tags = selectedTags;
              NoteService().save(_noteNotifier.note);
             // TagService().createTagIfNotExisting(_textEditingController.text);
              _textEditingController.clear();
            },
          )
        ],
      );
    }
  }
}
