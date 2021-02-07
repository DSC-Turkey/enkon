import 'package:flutter/material.dart';
pageRoute(Widget page,BuildContext context,double slideIndex) {
  Navigator.of(context).pushReplacement(
    PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) => page,
      transitionDuration: Duration(milliseconds: 180),
      transitionsBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: Offset(slideIndex, 0.0), end: Offset(0.0, 0.0))
              .animate(anim1),
          child: child,
        );
      },
    ),
  );
}