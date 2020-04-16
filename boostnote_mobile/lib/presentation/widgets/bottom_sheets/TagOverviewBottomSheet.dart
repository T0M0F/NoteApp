import 'package:boostnote_mobile/business_logic/service/TagService.dart';
import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TagOverviewBottomSheet extends StatelessWidget {

  TagServiceV2 _tagService;

  @override
  Widget build(BuildContext context) {
    _tagService = TagServiceV2();
    
    return Container(
      child: Wrap(
        children: <Widget>[
            new ListTile(
              leading: Icon(Icons.delete, color: Theme.of(context).primaryColorLight),
              title: Text(AppLocalizations.of(context).translate('remove_tag'), style: Theme.of(context).textTheme.display1),
              onTap: () {
                
              }       
            ),
            new ListTile(
              leading: new Icon(Icons.label, color: Theme.of(context).primaryColorLight),
              title: new Text(AppLocalizations.of(context).translate('rename_tag'), style: Theme.of(context).textTheme.display1),
              onTap: () {

              }   
            ),
        ],
      ),
    );
  }

/*
  void _removeTag(String tag) => _tagService
    .delete(tag)
    .whenComplete(() => refresh());

  
  void _renameTagDialog(String tag) {
   showDialog(context: context, 
    builder: (context){
      return RenameTagDialog(
        tag: tag,
        cancelCallback: () {
          Navigator.of(context).pop();
        }, 
        saveCallback: (String newTag) {
          Navigator.of(context).pop();
          //_renameTag(tag, newTag);
        },
      );
    });
  } 
*/
}
