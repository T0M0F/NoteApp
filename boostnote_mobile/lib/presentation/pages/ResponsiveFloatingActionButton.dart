import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/SnippetNotifier.dart';
import 'package:boostnote_mobile/presentation/widgets/buttons/AddFloatingActionButton.dart';
import 'package:boostnote_mobile/presentation/widgets/buttons/CreateNoteFloatingActionButton.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/AddSnippetDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/dialogs/NewNoteDialog.dart';
import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveChild.dart';
import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResponsiveFloatingActionButton extends StatefulWidget {
  @override
  _ResponsiveFloatingActionButtonState createState() => _ResponsiveFloatingActionButtonState();
}

class _ResponsiveFloatingActionButtonState extends State<ResponsiveFloatingActionButton> {

  NoteNotifier _noteNotifier;

  @override
  Widget build(BuildContext context) {
    _noteNotifier = Provider.of<NoteNotifier>(context);

    return _buildWidget(context);
  }

  ResponsiveWidget _buildWidget(BuildContext context) {
    return ResponsiveWidget(
      showDivider: true,
      divider: Container(width: 0.5, color: Colors.transparent),
      widgets: <ResponsiveChild> [
        ResponsiveChild(
          smallFlex: _noteNotifier.note == null ? 1 : 0,
          largeFlex: 2,
          child: Align(
            alignment: Alignment.bottomRight,
            child: CreateNoteFloatingActionButton(onPressed: _showNoteDialog)
          )
        ),
        ResponsiveChild(
          smallFlex: _noteNotifier.note == null ? 0 : 1,
          largeFlex: 3,
          child: _noteNotifier.note is SnippetNote 
            ? Align(
              alignment: Alignment.bottomRight,
              child: AddFloatingActionButton(onPressed: () => _showAddSnippetDialog(context))
            )
            : Container()
        )
      ]
    );
  }

  void _showNoteDialog() => showDialog(
    context: context,
    builder: (context) {
      return CreateNoteDialog();
  });

  Future<String> _showAddSnippetDialog(BuildContext context) =>
    showDialog(context: context, 
      builder: (context){
        return AddSnippetDialog();
  });          
}