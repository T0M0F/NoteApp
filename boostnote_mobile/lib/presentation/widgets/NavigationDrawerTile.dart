import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationDrawerTile extends StatefulWidget{

  final IconData icon;
  final String title;
  final AnimationController animationController;
  final bool isSelected;
  final Function onTap;


  NavigationDrawerTile({
    @required this.title,
    @required this.icon,
    @required this.animationController, 
    this.isSelected = false, 
    this.onTap
  });

  @override
  _NavigationDrawerTileState createState() => _NavigationDrawerTileState();

}

class _NavigationDrawerTileState extends State<NavigationDrawerTile> {

  Animation<double> widthAnimation, sizedBoxAnimation;


  @override
  void initState(){
    super.initState();

    widthAnimation = Tween<double>(begin: 220, end: 80).animate(widget.animationController);
    sizedBoxAnimation = Tween<double>(begin: 10, end: 0).animate(widget.animationController);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.widget.onTap,
      child: Container(
        width: widthAnimation.value,
        margin:  EdgeInsets.symmetric(horizontal: 8),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          color: this.widget.isSelected ? Theme.of(context).accentColor : Theme.of(context).buttonColor,
        ),
        child: Row(
          children: <Widget>[
            Icon(this.widget.icon),
            SizedBox(width: 10,),
            (widthAnimation.value >=200)
                ? Text(this.widget.title)
                : Container()
          ],
        )
      )
    );
  }
}