import 'package:boostnote_mobile/presentation/screens/ActionConstants.dart';
import 'package:boostnote_mobile/presentation/screens/note_overview/widgets/OverviewAppbar.dart';
import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveChild.dart';
import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget  implements PreferredSizeWidget{
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      widgets: <ResponsiveChild> [
         ResponsiveChild(
              smallFlex: 1, 
              largeFlex: 1, 
              child: OverviewAppbar(
              
                notes: List(),
                actions: {
                  'EXPAND_ACTION': ActionConstants.EXPAND_ACTION, 
                  'COLLPASE_ACTION': ActionConstants.COLLPASE_ACTION, 
                  'SHOW_LISTVIEW_ACTION': ActionConstants.SHOW_LISTVIEW_ACTION, 
                  'SHOW_GRIDVIEW_ACTION' : ActionConstants.SHOW_GRIDVIEW_ACTION},
              )
            ),
            ResponsiveChild(
              smallFlex: 0, 
              largeFlex: 1, 
              child: OverviewAppbar(
              
                notes: List(),
                actions: {
                  'EXPAND_ACTION': ActionConstants.EXPAND_ACTION, 
                  'COLLPASE_ACTION': ActionConstants.COLLPASE_ACTION, 
                  'SHOW_LISTVIEW_ACTION': ActionConstants.SHOW_LISTVIEW_ACTION, 
                  'SHOW_GRIDVIEW_ACTION' : ActionConstants.SHOW_GRIDVIEW_ACTION},
              )
            )
      ]
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

}