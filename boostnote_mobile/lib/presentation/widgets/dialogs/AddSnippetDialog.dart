import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AddSnippetDialog extends StatelessWidget {  //TODO StatelessWidget or StatefulWidget?

  final TextEditingController controller;
  final Function(String) onSnippetAdded;

  const AddSnippetDialog({Key key, this.controller, this.onSnippetAdded}) : super(key: key); //TODO Constructor

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _buildTitle(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return _buildContent();
        },
      ),
      actions: _buildActions(context),
    );
  }

  Container _buildTitle() {
    return Container( 
      alignment: Alignment.center,
      child: Text('Create a Code Snippet', style: TextStyle(color: Colors.black))
    );
  }


  Container _buildContent() {
     return Container(
      height: 75,
      child: Column(
        children: <Widget>[
          TextField(
            controller: controller,
            style: TextStyle(color: Colors.black),
          ), 
        ],
      ),
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
          if(controller.text.trim().length > 0){
            onSnippetAdded(controller.text); 
          }
        }
      )
    ];
  }

}
