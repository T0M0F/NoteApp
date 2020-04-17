import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/SnippetNotifier.dart';
import 'package:boostnote_mobile/presentation/pages/code_editor/widgets/CodeSnippetAppBar.dart';
import 'package:boostnote_mobile/presentation/pages/folders/widgets/FoldersPageAppbar.dart';
import 'package:boostnote_mobile/presentation/pages/markdown_editor/widgets/MarkdownEditorAppBar.dart';
import 'package:boostnote_mobile/presentation/widgets/DeviceWidthService.dart';
import 'package:boostnote_mobile/presentation/widgets/appbars/EmptyAppbar.dart';
import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveChild.dart';
import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

/*
* This class combines the FoldersPage Appbar and the Code or MarkdownEditor Appbar 
* into one responsive row.
*/
class CombinedFoldersAndEditorAppbar extends StatefulWidget  implements PreferredSizeWidget{

  final Function() openDrawer;

  CombinedFoldersAndEditorAppbar({this.openDrawer});

  @override
  _CombinedFoldersAndEditorAppbarState createState() => _CombinedFoldersAndEditorAppbarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CombinedFoldersAndEditorAppbarState extends State<CombinedFoldersAndEditorAppbar> {

  NoteNotifier _noteNotifier;
  SnippetNotifier _snippetNotifier;

  @override
  Widget build(BuildContext context) {
    _initNotifiers();
    return _buildWidget(context);
  }

  void _initNotifiers() {
    _noteNotifier = Provider.of<NoteNotifier>(context);
    _snippetNotifier = Provider.of<SnippetNotifier>(context);
  }

  ResponsiveWidget _buildWidget(BuildContext context) {
    return ResponsiveWidget(
      showDivider: true,
      widgets: <ResponsiveChild> [
         ResponsiveChild(
              smallFlex: _noteNotifier.note == null ? 1 : 0, 
              largeFlex: _noteNotifier.isEditorExpanded ? 0 : 2, 
              child: FoldersPageAppbar(openDrawer: widget.openDrawer)
            ),
        ResponsiveChild(
          smallFlex: _noteNotifier.note == null ? 0 : 1, 
          largeFlex:  _noteNotifier.isEditorExpanded ? 1 : 3, 
          child: buildSecondChild(context)
        )
      ]
    );
  }

  Widget buildSecondChild(BuildContext context) {
    return _noteNotifier.note == null   //Throws for some reason an exception when extracting into seperate methods
      ? EmptyAppbar()
      : _noteNotifier.note is MarkdownNote
        ? MarkdownEditorAppBar()
        : _snippetNotifier.isEditMode
          ? AppBar(
              leading: _buildLeadingIcon(),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.check, color: Theme.of(context).buttonColor), 
                  onPressed: () => _snippetNotifier.isEditMode = !_snippetNotifier.isEditMode
                )
              ]
          )
          : CodeSnippetAppBar();
  }


  Widget _buildLeadingIcon() {
    if(DeviceWidthService(context).isTablet()) {
      return IconButton(
        icon: Icon(_noteNotifier.isEditorExpanded ? MdiIcons.chevronRight : MdiIcons.chevronLeft, color:  Theme.of(context).buttonColor), 
        onPressed:() {
          _noteNotifier.isEditorExpanded = !_noteNotifier.isEditorExpanded;
        },
      );
    } else {
      return IconButton(
        icon: Icon(Icons.arrow_back, color:  Theme.of(context).buttonColor), 
        onPressed:() {
          _noteNotifier.isEditorExpanded = false;
          _snippetNotifier.selectedCodeSnippet = null;
          _noteNotifier.note = null;
        },
      );
    }
  }
}