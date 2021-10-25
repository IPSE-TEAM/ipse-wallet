import 'package:flutter/material.dart';
import 'package:ipsewallet/utils/adapt.dart';

class GredientBg extends StatelessWidget {
  GredientBg({
    @required this.child,
    this.title = '',
    this.colors = const [Color(0xFF0399DD),
            Color(0xFF38A0DB),
            Color(0xFF38A0DB),
            Color(0XFFF8F8F8)],
    this.action,
    this.height,
    this.onBack,
  });
  final String title;
  final Widget child;
  final Function onBack;
  final Widget action;
  final double height;

  final List<Color> colors;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          child: Container(
            height: height ?? Adapt.px(419),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: colors,
              ),
            ),
          ),
        ),
        Positioned(
          child: SafeArea(
            top: true,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  onPressed: onBack!=null?onBack:() {
                    Navigator.pop(context);
                  },
                  icon: Image.asset('assets/images/a/back-fff.png'),
                ),
                Expanded(
                  child: Text(
                    title ?? '',
                    style: TextStyle(color: Colors.white, fontSize: 21),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
                action??Container(
                  width: 45.0,
                  child: Text(''),
                ),
              ],
            ),
          ),
        ),
        // main
        Positioned(
          child: SafeArea(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(15, 60, 15, 0),
                    child: child
                    // SingleChildScrollView(child: child),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
