import 'package:boostnote_mobile/business_logic/model/Folder.dart';
import 'package:boostnote_mobile/business_logic/service/FolderService.dart';
import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:boostnote_mobile/presentation/notifiers/FolderNotifier.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/RenameFolderDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FolderOverviewBottomSheet extends StatelessWidget {

  final Function() removeFolderCallback;
  final Function() renameFolderCallback;

  FolderOverviewBottomSheet({this.removeFolderCallback, this.renameFolderCallback});

  FolderService _folderService = FolderService();
  FolderNotifier _folderNotifier;

  @override
  Widget build(BuildContext context) {
    _folderNotifier = Provider.of<FolderNotifier>(context);

    return Container(
      child: Wrap(
        children: <Widget>[
            ListTile(
              leading:  Icon(Icons.delete, color: Theme.of(context).buttonColor),
              title:  Text(AppLocalizations.of(context).translate('remove_folder'), style: Theme.of(context).textTheme.display1),
              onTap: () => _removeFolder(context)
            ),
            ListTile(
              leading:  Icon(Icons.folder, color: Theme.of(context).buttonColor),
              title:  Text(AppLocalizations.of(context).translate('rename_folder'), style: Theme.of(context).textTheme.display1),
              onTap:  () => _renameFolderDialog(context)
            ),
        ],
      ),
    );
  }

  void _removeFolder(BuildContext context) {
    Navigator.of(context).pop();
    _folderService
      .delete(_folderNotifier.selectedFolder)
      .whenComplete(() => refresh(context));
  }

  void refresh(BuildContext context) {
    List<Folder> folders = _folderNotifier.folders;
    folders.remove(_folderNotifier.selectedFolder);
    _folderNotifier.folders = folders;
  }

  void _renameFolderDialog(BuildContext context) {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (context) {
        return RenameFolderDialog();
    });
  }
}