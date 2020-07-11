import 'package:flutter/material.dart';
/// Unknown if will be used
/// Added in order to commit animations folder
class CustomFadeTransition {

  static Route createRoute(Widget nextPage, {Object args: null}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => nextPage,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      settings: RouteSettings(
        arguments: args
      ),
    );
  }

}