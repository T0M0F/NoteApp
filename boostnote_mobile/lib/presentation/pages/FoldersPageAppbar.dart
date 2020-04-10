import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/SnippetNotifier.dart';
import 'package:boostnote_mobile/presentation/pages/DeviceChecker.dart';
import 'package:boostnote_mobile/presentation/pages/EmptyAppbar.dart';
import 'package:boostnote_mobile/presentation/screens/editor/markdown_editor/widgets/MarkdownEditorAppBar.dart';
import 'package:boostnote_mobile/presentation/screens/editor/snippet_editor/widgets/CodeSnippetAppBar.dart';
import 'package:boostnote_mobile/presentation/widgets/appbar/FolderOverviewAppbar.dart';
import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveChild.dart';
import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class FoldersPageAppbar extends StatefulWidget  implements PreferredSizeWidget{

  final Function(String action) onSelectedActionCallback;
  final Function() openDrawer;

  FoldersPageAppbar({this.onSelectedActionCallback, this.openDrawer});

  @override
  _FoldersPageAppbarState createState() => _FoldersPageAppbarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _FoldersPageAppbarState extends State<FoldersPageAppbar> {

  NoteNotifier _noteNotifier;
  SnippetNotifier _snippetNotifier;

  @override
  Widget build(BuildContext context) {
    _noteNotifier = Provider.of<NoteNotifier>(context);
    _snippetNotifier = Provider.of<SnippetNotifier>(context);

    return _buildWiget(context);
  }

  ResponsiveWidget _buildWiget(BuildContext context) {
    return ResponsiveWidget(
      showDivider: true,
      widgets: <ResponsiveChild> [
         ResponsiveChild(
              smallFlex: _noteNotifier.note == null ? 1 : 0, 
              largeFlex: _noteNotifier.isEditorExpanded ? 0 : 2, 
              child: FolderOverviewAppbar(openDrawer: widget.openDrawer)
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
    return _noteNotifier.note == null   //Sonst fliegt komische exception, wenn in methode ausgelagert
      ? EmptyAppbar()
      : _noteNotifier.note is MarkdownNote
        ? MarkdownEditorAppBar(selectedActionCallback: widget.onSelectedActionCallback)
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
          : CodeSnippetAppBar(selectedActionCallback: widget.onSelectedActionCallback);
  }


  Widget _buildLeadingIcon() {
    if(DeviceChecker(context).isTablet()) {
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