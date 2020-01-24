
import 'package:boostnote_mobile/presentation/widgets/taglist/TagListTile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TagList extends StatefulWidget {   //TODO make generic

  final List<String> tags;
  final Function(String) onRowTap;
  final Function(String) onRowLongPress;

  TagList({@required this.tags, @required this.onRowTap, this.onRowLongPress}); //TODO: constructor
  
  @override
  State<StatefulWidget> createState() => _TagListState();

}

class _TagListState extends State<TagList> {

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
    itemCount: this.widget.tags.length,
    itemBuilder: (context, index) {
      return GestureDetector(
        onTap: () => this.widget.onRowTap(this.widget.tags[index]),
        onLongPress: () => this.widget.onRowLongPress(this.widget.tags[index]),
        child: TagListTile(tag: this.widget.tags[index])
      );
    },
  );
  }
  

}
