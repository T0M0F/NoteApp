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

  @override
  Widget build(BuildContext context) {

    _isTablet = MediaQuery.of(context).size.width > this.widget.breakPoint;

    return Row(
      children: getWidgets(),
    );

  }

  List<Widget> getWidgets() {

    List<Widget> result = List();

     for(ResponsiveChild responsiveChild in this.widget.widgets) {

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
}