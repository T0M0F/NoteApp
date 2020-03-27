import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'NavigationDrawerTile.dart';

class CustomNavigationDrawer extends StatefulWidget{
  @override
  _CustomNavigationDrawerState createState() => _CustomNavigationDrawerState();
}

class _CustomNavigationDrawerState extends State<CustomNavigationDrawer> with SingleTickerProviderStateMixin{

  double maxWidth = 220;
  double minWidth = 70;
  bool isCollpased = false;
  AnimationController animationController;
  Animation<double> widthAnimation;
  int currentSelectedIndex;

  @override
  void initState(){
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300) 
    );
    widthAnimation = Tween<double>(begin: maxWidth, end: minWidth).animate(animationController);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController, builder: (context, widget) => _getWidget());
  }

  Widget _getWidget() {
    return Material(
      elevation: 70,
      child: Container(
        width: 250,
        color: Theme.of(context).primaryColor,
        child: Column(
        children: <Widget>[
           NavigationDrawerTile(
              title: 'Boostnote',
              icon: Icons.note,
              animationController: animationController
            ),
            Divider(height: 12,),
            Expanded(
              child: ListView.separated(
                separatorBuilder:  (context, counter) => Divider(height: 12,),
                itemBuilder: (context, counter){
                  return NavigationDrawerTile(
                    title: 'test',
                    icon: Icons.note,
                    animationController: animationController,
                    isSelected: currentSelectedIndex == counter,
                    onTap: (){
                      setState(() {
                        currentSelectedIndex = counter;
                      });
                    }
                  );
                }, 
                itemCount: 1,
              ) 
            ),
            IconButton(
              icon: AnimatedIcon(
                icon: AnimatedIcons.close_menu,
                progress: animationController,
                size: 50, 
                ),
              onPressed: (){
                isCollpased = !isCollpased;
                isCollpased ? animationController.reverse() : animationController.forward();
              }, 
            ),
            SizedBox(height: 50,)
          ]
        )
      ),
    );
  }
}