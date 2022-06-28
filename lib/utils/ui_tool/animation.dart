import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

import 'animprops.dart';

class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  FadeAnimation(this.delay, this.child);

  @override
  Widget build(BuildContext context) {
    /*final tween = MultiTween([
      MultiTweenValues(Duration(milliseconds: 500), Tween(begin: 0.0, end: 1.0)),

      Track("translateY").add(
          Duration(milliseconds: 500), Tween(begin: -30.0, end: 0.0),
          curve: Curves.easeOut)
    ]);
    */
    final tween = TimelineTween<AniProps>()
      ..addScene(
          begin: const Duration(milliseconds: 0),
          duration: const Duration(milliseconds: 500))
          .animate(AniProps.width, tween: Tween<double>(begin: 0.0, end: 400.0))
          .animate(AniProps.height, tween: Tween<double>(begin: 500.0, end: 200.0))
          .animate(AniProps.color,
          tween: ColorTween(begin: Colors.red, end: Colors.yellow))
      ..addScene(
          begin: const Duration(milliseconds: 700),
          end: const Duration(milliseconds: 1200))
          .animate(AniProps.width, tween: Tween<double>(begin: 400.0, end: 500.0));

    return widget;


  }

  var widget = LoopAnimation<Color?>(
    // mandatory parameters
    tween: ColorTween(begin: Colors.red, end: Colors.blue),
    builder: (context, child, value) {
      return Container(color: value, width: 100, height: 100, child: child);
    },
    // optional parameters
    duration: const Duration(seconds: 5),
    curve: Curves.easeInOut,
    child: const Text('Hello World'),
  );
}
