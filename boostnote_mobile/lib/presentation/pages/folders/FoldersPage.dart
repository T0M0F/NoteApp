import 'package:boostnote_mobile/presentation/pages/folders/widgets/FoldersPageAppbar.dart';
import 'package:boostnote_mobile/presentation/pages/folders/widgets/folderlist/FolderList.dart';
import 'package:boostnote_mobile/presentation/widgets/base/ResponsiveBaseView.dart';
import 'package:flutter/material.dart';

class FoldersPage extends StatefulWidget {
  @override
  _FoldersPageState createState() => _FoldersPageState();
}

class _FoldersPageState extends State<FoldersPage> {

  @override
  Widget build(BuildContext context) {
    return ResponsiveBaseView( 
      leftSideAppBar: FoldersPageAppbar(), 
      leftSideChild: FolderList()
    );
  }
}