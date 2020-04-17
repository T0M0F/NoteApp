import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/SnippetNotifier.dart';
import 'package:boostnote_mobile/presentation/pages/code_editor/widgets/CodeSnippetAppBar.dart';
import 'package:boostnote_mobile/presentation/pages/code_editor/widgets/CodeSnippetAppbarEditMode.dart';
import 'package:boostnote_mobile/presentation/pages/markdown_editor/widgets/MarkdownEditorAppBar.dart';
import 'package:boostnote_mobile/presentation/widgets/appbars/EmptyAppbar.dart';
import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveChild.dart';
import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResponsiveBaseAppbar extends StatefulWidget  implements PreferredSizeWidget{

  final PreferredSizeWidget leftSideAppbar;

  ResponsiveBaseAppbar({@required this.leftSideAppbar});

  @override
  _ResponsiveBaseAppbarState createState() => _ResponsiveBaseAppbarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _ResponsiveBaseAppbarState extends State<ResponsiveBaseAppbar> {

  NoteNotifier _noteNotifier;
  SnippetNotifier _snippetNotifier;

  @override
  Widget build(BuildContext context) {
    _initNotifiers(context);
    return _buildWidget(context);
  }

  void _initNotifiers(BuildContext context) {
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
              child: widget.leftSideAppbar
            ),
        ResponsiveChild(
          smallFlex: _noteNotifier.note == null ? 0 : 1, 
          largeFlex: _noteNotifier.isEditorExpanded ? 1 : 3, 
          child: _buildRightAppbar(context)
        )
      ]
    );
  }

  Widget _buildRightAppbar(BuildContext context) {
    return _noteNotifier.note == null   //Throws for some reason an exception when extracting into seperate methods
      ? EmptyAppbar()
      : _noteNotifier.note is MarkdownNote
        ? MarkdownEditorAppBar()
        : _snippetNotifier.isEditMode
          ? CodeSnippetAppBarEditMode()
          : CodeSnippetAppBar();
  }
}
