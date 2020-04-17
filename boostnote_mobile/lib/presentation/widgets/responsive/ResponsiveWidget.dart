import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveChild.dart';
import 'package:flutter/material.dart';

class ResponsiveWidget extends StatefulWidget {

  final int breakPoint;
  final List<ResponsiveChild> widgets;
  final bool showDivider;
  final Widget divider;

  ResponsiveWidget({this.showDivider = true, this.breakPoint = 1200, @required this.widgets, this.divider});

  @override
  ResponsiveWidgetState createState() => ResponsiveWidgetState();

}
  
class ResponsiveWidgetState extends State<ResponsiveWidget> {

  bool _isTablet;
  List<ResponsiveChild> widgets;
  Widget divider;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.divider == null) {
      divider = Container(width: 0.5, color: Theme.of(context).dividerColor);
    } else {
      divider = widget.divider;
    }

    widgets = this.widget.widgets;
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
          result.add(divider);
        }
      } 
    }

    result.removeLast();

    return result;
  }
}