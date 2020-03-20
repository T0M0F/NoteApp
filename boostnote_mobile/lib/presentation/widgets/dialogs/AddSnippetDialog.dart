import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AddSnippetDialog extends StatelessWidget {  //TODO StatelessWidget or StatefulWidget?

  final TextEditingController controller;
  final Function(String) onSnippetAdded;

  const AddSnippetDialog({Key key, this.controller, this.onSnippetAdded}) : super(key: key); //TODO Constructor

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _buildTitle(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return _buildContent(context);
        },
      ),
      actions: _buildActions(context),
    );
  }

  Container _buildTitle(BuildContext context) {
    return Container( 
      alignment: Alignment.center,
      child: Text('Create a Code Snippet', style: TextStyle(color: Theme.of(context).textTheme.display1.color))
    );
  }


  Container _buildContent(BuildContext context) {
     return Container(
      height: 75,
      child: Column(
        children: <Widget>[
          TextField(
            controller: controller,
            style: TextStyle(color: Theme.of(context).textTheme.display1.color),
          ), 
        ],
      ),
    );
  }


  List<Widget> _buildActions(BuildContext context) {
    return <Widget>[
      MaterialButton(
        minWidth:100,
        child: Text('Cancel', style: TextStyle(color:  Theme.of(context).textTheme.display1.color),),
        onPressed: (){
          Navigator.of(context).pop();
        }
      ),
      MaterialButton(
        minWidth:100,
        elevation: 5.0,
        color: Theme.of(context).accentColor,
        child: Text('Save', style: TextStyle(color: Theme.of(context).accentTextTheme.display1.color)),
        onPressed: (){
          if(controller.text.trim().length > 0){
            onSnippetAdded(controller.text); 
          }
        }
      )
    ];
  }

}
