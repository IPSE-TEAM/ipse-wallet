import 'package:flutter/material.dart';


class MyPageRoute extends PageRoute {
  MyPageRoute({
    @required this.pageBuilder,
    this.myPageTransitionType = MyPageTransitionType.fadeIn,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.opaque = false,
    this.barrierDismissible = false,
    this.barrierColor,
    this.barrierLabel,
    this.maintainState = true,
  });

  final WidgetBuilder pageBuilder;

  final MyPageTransitionType myPageTransitionType;

  @override
  final Duration transitionDuration;

  @override
  final bool opaque;

  @override
  final bool barrierDismissible;

  @override
  final Color barrierColor;

  @override
  final String barrierLabel;

  @override
  final bool maintainState;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) => pageBuilder(context);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {

      if (myPageTransitionType == MyPageTransitionType.slideDown) {
        return new SlideTransition(
          position: new Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: const Offset(0.0, 0.0),
          ).animate(CurvedAnimation(parent: animation, curve: Curves.linear)),
          child: child,
        );
      }

      if (myPageTransitionType == MyPageTransitionType.slideUp) {
        return new SlideTransition(
          position: new Tween<Offset>(
            begin: const Offset(0.0, -1.0),
            end: const Offset(0.0, 0.0),
          ).animate(CurvedAnimation(parent: animation, curve: Curves.linear)),
          child: child,
        );
      }

      if (myPageTransitionType == MyPageTransitionType.slideLeft) {
        return new SlideTransition(
          position: new Tween<Offset>(
            begin: const Offset(-1.0, 0.0),
            end: const Offset(0.0, 0.0),
          ).animate(CurvedAnimation(parent: animation, curve: Curves.linear)),
          child: child,
        );
      }

      if (myPageTransitionType == MyPageTransitionType.slideRight) {
        return new SlideTransition(
          position: new Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: const Offset(0.0, 0.0),
          ).animate(CurvedAnimation(parent: animation, curve: Curves.linear)),
          child: child,
        );
      }

      return FadeTransition(
        opacity: animation,
        child: pageBuilder(context),
      );
  }

}

enum MyPageTransitionType {
  fadeIn, 

  slideLeft, 
  slideRight, 
  slideUp, 
  slideDown 
}