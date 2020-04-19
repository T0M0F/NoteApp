import 'package:boostnote_mobile/presentation/pages/tags/widgets/TagsPageAppbar.dart';
import 'package:boostnote_mobile/presentation/pages/tags/widgets/taglist/TagList.dart';
import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveBaseView.dart';
import 'package:flutter/material.dart';

class TagsPage extends StatefulWidget {
  @override
  _TagsPageState createState() => _TagsPageState();
}

class _TagsPageState extends State<TagsPage> {

  @override
  Widget build(BuildContext context) {
    return ResponsiveBaseView(
      leftSideAppBar: TagsPageAppbar(),
      leftSideChild: TagList()
    );
  }
}