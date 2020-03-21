import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateTagDialog extends StatefulWidget {

  final Function(String tag) saveCallback;
  final Function() cancelCallback;

  const CreateTagDialog({Key key, @required this.saveCallback, @required this.cancelCallback}) : super(key: key); //TODO: Constructor

  @override
  _CreateTagDialogState createState() => _CreateTagDialogState();
}

class _CreateTagDialogState extends State<CreateTagDialog> {

  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Container( 
        alignment: Alignment.center,
        child: Text(AppLocalizations.of(context).translate("create_tags"), style: TextStyle(color: Theme.of(context).textTheme.display1.color))
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context).translate('enter_name'),
                    hintStyle: Theme.of(context).textTheme.display2
                  ),
                  controller: _textEditingController,
                  style: TextStyle(color:  Theme.of(context).textTheme.display1.color),
                ), 
              ],
            ),
          );
        },
      ),
      actions: <Widget>[
       MaterialButton(
          minWidth:100,
          child: Text('Cancel', style: TextStyle(color:  Theme.of(context).textTheme.display1.color)),
          onPressed: (){
            this.widget.cancelCallback();
          }
        ),
        MaterialButton(
          minWidth:100,
          elevation: 5.0,
          color: Theme.of(context).accentColor,
          child: Text('Save', style: TextStyle(color:  Theme.of(context).accentTextTheme.display1.color)),
          onPressed: () {
            this.widget.saveCallback(_textEditingController.text);
          }
        )
      ],
    );
  }
}