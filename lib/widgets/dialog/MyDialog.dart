import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ipsewallet/config/config.dart';
import 'package:ipsewallet/widgets/dialog/MyPageRoute.dart';

AnimationController _animationController;
Animation _animation;

class MyDialog {

  static MyDialog getInstance(){
    MyDialog instance  = new MyDialog();
    return instance;
  }

  void bottomSheet(BuildContext context, {
      @required Widget child,
      Color bgColor,
      Color wrapBgColor = Colors.white,
      bool clickBack = true,
      bool btnBack = true,
      double height = 0.5,
      double width = 1.0,
      num duration = 300,
      String slideTo = 'down',
      String infoOffset = 'bottomLeft',
  }){
    Navigator.of(context).push(
        MyPageRoute(
          transitionDuration: Duration(milliseconds: duration),
          myPageTransitionType: MyPageTransitionType.fadeIn,
          pageBuilder: (context) => new _MyDialog(
            child: child,
            bgColor: bgColor,
            wrapBgColor: wrapBgColor,
            clickBack: clickBack,
            btnBack: btnBack,
            height: height,
            width: width,
            duration: duration,
            slideTo: slideTo,
            infoOffset: infoOffset
          )
        )
    );
  }

  void mask(BuildContext context, {
    @required Widget child,
    Color bgColor = const Color.fromRGBO(0, 0, 0, 0.4),
    num duration = 300
  }){
    Navigator.of(context).push(
      MyPageRoute(
        transitionDuration: Duration(milliseconds: duration),
        myPageTransitionType: MyPageTransitionType.fadeIn,
        pageBuilder: (context) => Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: <Widget>[
              SizedBox.expand(child: new GestureDetector(
                child: new Container(color: bgColor),
                onTap: () {
                  if (Navigator.of(context).canPop()) Navigator.of(context).pop();
                }
              )),
              child
            ]
          )
        )
      )
    );
  }

}

class _MyDialog extends StatefulWidget {
  final Widget child;
  final Color bgColor;
  final Color wrapBgColor;
  final bool clickBack;
  final bool btnBack;
  final double height;
  final double width;
  final num duration;
  final String slideTo;
  final String infoOffset;

  _MyDialog({
    Key key,
    @required this.child,
    this.bgColor,
    this.wrapBgColor,
    this.clickBack,
    this.btnBack,
    this.height,
    this.width,
    this.duration,
    this.slideTo = 'down',
    this.infoOffset = 'bottomLeft',
  }) : assert(child != null),
      assert(height > 0.0 && height <= 1.0),
      super(key: key);

  @override
  _MyDialogState createState() => _MyDialogState();
}
class _MyDialogState extends State<_MyDialog> with TickerProviderStateMixin {
  final Map<String, List<Offset>> _tween = {
    'left': [const Offset(-1.0, 0.0), const Offset(0.0, 0.0)],
    'down': [const Offset(0.0, 1.0), const Offset(0.0, 0.0)],
  };
  final Map<String, Alignment> _alignment = {
    'bottomLeft': Alignment.bottomLeft,
    'center': Alignment.center,
  };

  @override
  void initState() {
    super.initState();

    _animationController = new AnimationController(vsync: this, duration: Duration(milliseconds: widget.duration));
    _animation = new Tween<Offset>(
      begin: _tween[widget.slideTo][0],
      end: _tween[widget.slideTo][1],
    ).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void close() {
    if (_animationController == null) return;
    _animationController.reverse();
    if (Navigator.of(context).canPop()) Navigator.of(context).pop();
  }

  
  Future<bool> _onWillPop() {
    if (!widget.btnBack){
      return Future.value(false);
    }
    _animationController.reverse();
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: new Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
                alignment: _alignment[widget.infoOffset] ?? Alignment.bottomLeft,
                children: <Widget>[
                  SizedBox.expand(child: new GestureDetector(
                    child: new Container(color: widget.bgColor ?? Color.fromRGBO(0, 0, 0, 0.6)),
                    onTap: () {
                      if (!widget.clickBack) return;
                      close();
                    },
                  )),
                  new SlideTransition(
                      position: _animation,
                      child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(11.0),
                            topRight: Radius.circular(11.0),
                            bottomLeft: widget.infoOffset == 'center' ? Radius.circular(11.0) : Radius.zero,
                            bottomRight: widget.infoOffset == 'center' ? Radius.circular(11.0) : Radius.zero,
                          ),
                          child: new Container(
                              color: widget.wrapBgColor,
                              width: MediaQuery.of(context).size.width * widget.width,
                              height: MediaQuery.of(context).size.height * widget.height,
                              child: Stack(
                                alignment: Alignment.topRight,
                                children: <Widget>[
                                  widget.child,
                                  IconButton(
                                    icon: Icon(Icons.close, size: 30, color: Config.color999),
                                    onPressed: close
                                  )
                                ],
                              )
                          )
                      )
                  )
                ]
            )
        ),
        onWillPop: _onWillPop
    );
  }
}
