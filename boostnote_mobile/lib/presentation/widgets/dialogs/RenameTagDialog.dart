import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RenameTagDialog extends StatefulWidget {    //TODO make generic

  final String tag;
  final Function(String newTag) saveCallback;
  final Function() cancelCallback;

  const RenameTagDialog({Key key, @required this.saveCallback, @required this.cancelCallback, @required this.tag}) : super(key: key); //TODO: Constructor

  @override
  _CreateTagDialogState createState() => _CreateTagDialogState();
}

class _CreateTagDialogState extends State<RenameTagDialog> {

  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Container( 
        alignment: Alignment.center,
        child: Text(AppLocalizations.of(context).translate('rename_tag') + ' ' + this.widget.tag, style: TextStyle(color: Colors.black))
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: 100,
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _textEditingController,
                  style: TextStyle(color: Colors.black),
                ), 
              ],
            ),
          );
        },
      ),
      actions: <Widget>[
       MaterialButton(
          minWidth:100,
          child: Text('Cancel', style: TextStyle(color: Colors.black),),
          onPressed: (){
            this.widget.cancelCallback();
          }
        ),
        MaterialButton(
          minWidth:100,
          elevation: 5.0,
          color: Theme.of(context).accentColor,
          child: Text('Save', style: TextStyle(color: Color(0xFFF6F5F5))),
          onPressed: () {
            this.widget.saveCallback(_textEditingController.text);
          }
        )
      ],
    );
  }
}