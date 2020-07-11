import 'package:flutter/material.dart';
/// Unknown if will be used
/// Added in order to commit animations folder
class CustomFadeTransition {

  static Route createRoute(Widget nextPage) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => nextPage,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      }
    );
  }

}