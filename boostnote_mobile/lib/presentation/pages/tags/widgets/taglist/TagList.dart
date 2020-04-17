
import 'package:boostnote_mobile/presentation/navigation/PageNavigator.dart';
import 'package:boostnote_mobile/presentation/notifiers/TagsNotifier.dart';
import 'package:boostnote_mobile/presentation/pages/tags/widgets/taglist/TagListTile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TagList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TagListState();
}

class _TagListState extends State<TagList> {

  TagsNotifier _tagsNotifier;

  @override
  Widget build(BuildContext context) {
    _tagsNotifier = Provider.of<TagsNotifier>(context);
    return _buildWidget();
  }

  ListView _buildWidget() {
    return ListView.builder(
      itemCount: _tagsNotifier.tags.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => _onRowTap(_tagsNotifier.tags[index]),
          child: TagListTile(tag: _tagsNotifier.tags[index])
        );
      },
    );
  }

  void _onRowTap(String tag) => PageNavigator().navigateToNotesWithTag(context, tag);

}
