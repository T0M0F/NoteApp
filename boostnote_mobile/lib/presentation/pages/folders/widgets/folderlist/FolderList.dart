
import 'package:boostnote_mobile/business_logic/model/Folder.dart';
import 'package:boostnote_mobile/presentation/navigation/PageNavigator.dart';
import 'package:boostnote_mobile/presentation/notifiers/FolderNotifier.dart';
import 'package:boostnote_mobile/presentation/pages/folders/widgets/folderlist/FolderListTile.dart';
import 'package:boostnote_mobile/presentation/widgets/bottom_sheets/FolderOverviewBottomSheet.dart';
import 'package:boostnote_mobile/presentation/widgets/bottom_sheets/FolderOverviewErrorBottomSheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FolderList extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _FolderListState();

}
 
class _FolderListState extends State<FolderList> {

  FolderNotifier _folderNotifier;
  PageNavigator _pageNavigator = PageNavigator();
 
  @override
  Widget build(BuildContext context) {
    _folderNotifier = Provider.of<FolderNotifier>(context);
    
    return ListView.builder(
    itemCount: _folderNotifier.folders.length,
    itemBuilder: (context, index) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => _pageNavigator.navigateToNotesInFolder(context, _folderNotifier.folders[index]),
        onLongPress: () => _onFolderLongPress(_folderNotifier.folders[index]),
        child: FolderListTile(folder: _folderNotifier.folders[index])
      );
    },
  );
  }
  
  void _onFolderLongPress(Folder folder) {
    _folderNotifier.selectedFolder = folder;
    showModalBottomSheet(    
      context: context,
      builder: (BuildContext buildContext) {
        return (folder.id != 'Default'.hashCode && folder.id != 'Trash'.hashCode)
          ? FolderOverviewBottomSheet()
          : FolderOverviewErrorBottomSheet();
      }
    );
  
  }


}
