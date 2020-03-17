import 'package:boostnote_mobile/presentation/navigation/NavigationService.dart';
import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveChild.dart';
import 'package:flutter/material.dart';

class ResponsiveWidget extends StatefulWidget {

  final int breakPoint;
  final List<ResponsiveChild> widgets;
  final bool showDivider;

  ResponsiveWidget({this.showDivider = true, this.breakPoint = 1200, @required this.widgets});

  @override
  State<StatefulWidget> createState() => ResponsiveWidgetState();

}
  
class ResponsiveWidgetState extends State<ResponsiveWidget> {

  bool _isTablet;
  List<ResponsiveChild> widgets;

  @override
  void initState() {
    super.initState();
    widgets = this.widget.widgets;
    NavigationService().init(this);
    NavigationService().widgetHistory.add(widgets);
    NavigationService().navigationModeHistory.add(NavigationMode2.ALL_NOTES_MODE);
  }

  @override
  Widget build(BuildContext context) {

    _isTablet = MediaQuery.of(context).size.width > this.widget.breakPoint;

    return Row(
      children: _getWidgets(),
    );

  }

  List<Widget> _getWidgets() {
    List<Widget> result = List();

     for(ResponsiveChild responsiveChild in widgets) {

      int flex = _isTablet? responsiveChild.largeFlex : responsiveChild.smallFlex;

      if(flex > 0) {
        result.add(
          Flexible(
            flex: flex,
            child: responsiveChild.child
          )
        );
        if(this.widget.showDivider){
          result.add(Container(width: 0.5, color: Colors.grey));
        }
      } 

    }

    result.removeLast();

    return result;
  }

  void update(List<ResponsiveChild> newWidgets) {
    print('update widget');
    setState(() {
      this.widgets = newWidgets;
    });
  }
}