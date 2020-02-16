
import 'package:boostnote_mobile/business_logic/service/TagService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditTagsDialog extends StatefulWidget {

  final List<String> tags;
  final Function cancelCallback;
  final Function(List<String>) saveCallback;

  const EditTagsDialog({Key key, this.tags, this.saveCallback, this.cancelCallback}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditTagsDialogState();
  
}
  
class _EditTagsDialogState extends State<EditTagsDialog>{

  TextEditingController _textEditingController;
  List<String> _selectedTags;
  List<String> _allTags;
  TagService _tagService;

  @override
  void initState() {
    super.initState();
    _tagService = TagService();
    _textEditingController = TextEditingController();
    _selectedTags = this.widget.tags;
    _allTags = _selectedTags;
    _tagService.findAll(). then((tags) {
      setState(() {
        _allTags = tags;
      });
    });
  }

  @override
  Widget build(BuildContext context) => 
   AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Container( 
        alignment: Alignment.center,
        child: Text('Select Tags', style: TextStyle(color: Colors.black))
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
                    decoration: InputDecoration(hintText: 'Add a new Tag', hintStyle: TextStyle(color: Colors.grey)),
                    textInputAction: TextInputAction.done,
                    controller: _textEditingController,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.check),
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
                          child: Text(_allTags[index]),)
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
        MaterialButton(
          minWidth:100,
          child: Text('Cancel', style: TextStyle(color: Colors.black),),
          onPressed: (){
            Navigator.of(context).pop();
          }
        ),
        MaterialButton(
          minWidth:100,
          elevation: 5.0,
          color: Theme.of(context).accentColor,
          child: Text('Save', style: TextStyle(color: Color(0xFFF6F5F5))),
          onPressed: (){
            this.widget.saveCallback(_selectedTags);
          }
        )
      ],
    );

  void _onRowTap(String tag) {
    setState(() {
      _selectedTags.contains(tag) ? _selectedTags.remove(tag) : _selectedTags.add(tag);
    });
  }
}