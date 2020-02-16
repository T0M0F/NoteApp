import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SnippetDescriptionDialog extends StatefulWidget {

  final TextEditingController textEditingController;
  final Function(String) onDescriptionChanged;
  final SnippetNote note;

  const SnippetDescriptionDialog({Key key, this.textEditingController, this.onDescriptionChanged, this.note}) : super(key: key); //TODO: Constructor

  @override
  _SnippetDescriptionDialogState createState() => _SnippetDescriptionDialogState();
}

class _SnippetDescriptionDialogState extends State<SnippetDescriptionDialog> {
  @override
  Widget build(BuildContext context) {

    this.widget.textEditingController.text = this.widget.note.description;

    return AlertDialog(
      title: _buildTitle(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: _buildContent(),
      actions: _buildActions(context),
    );
  }

  Container _buildTitle() {
    return Container( 
      alignment: Alignment.center,
      child: Text('Description', style: TextStyle(color: Colors.black))
    );
  }

  StatefulBuilder _buildContent() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Container(
          height: 250,
          child: TextField(
            style: TextStyle(),
            controller: widget.textEditingController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(0),
              border: InputBorder.none,
              hintText: 'Note'),
              onChanged: (String text){
                
            },
          ),
        );
      },
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return <Widget>[
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
          this.widget.onDescriptionChanged(widget.textEditingController.text);
          Navigator.of(context).pop();
        }
      )
    ];
  }
}
