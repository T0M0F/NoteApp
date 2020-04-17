import 'package:boostnote_mobile/presentation/notifiers/NoteNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/SnippetNotifier.dart';
import 'package:boostnote_mobile/presentation/widgets/DeviceWidthService.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class CodeSnippetAppBarEditMode extends StatefulWidget {
  @override
  _CodeSnippetAppBarEditModeState createState() => _CodeSnippetAppBarEditModeState();
}

class _CodeSnippetAppBarEditModeState extends State<CodeSnippetAppBarEditMode> {

  NoteNotifier _noteNotifier;
  SnippetNotifier _snippetNotifier;

  @override
  Widget build(BuildContext context) {
    _initNotifiers(context);
    return _buildWidget(context);
  }

  AppBar _buildWidget(BuildContext context) {
    return AppBar(       
      leading: _buildLeadingIcon(),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.check, color: Theme.of(context).buttonColor), 
          onPressed: () => _snippetNotifier.isEditMode = !_snippetNotifier.isEditMode
        )
      ]
    );
  }

  void _initNotifiers(BuildContext context) {
    _noteNotifier = Provider.of<NoteNotifier>(context);
    _snippetNotifier = Provider.of<SnippetNotifier>(context);
  }

  Widget _buildLeadingIcon() {
    if(DeviceWidthService(context).isTablet()) {
      return IconButton(
        icon: Icon(
          _noteNotifier.isEditorExpanded 
          ? MdiIcons.chevronRight 
          : MdiIcons.chevronLeft, 
          color:  Theme.of(context).buttonColor
        ), 
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
