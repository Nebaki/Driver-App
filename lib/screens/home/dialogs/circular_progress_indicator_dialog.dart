import 'package:flutter/material.dart';

class CircularProggressIndicatorDialog extends StatelessWidget {
  const CircularProggressIndicatorDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Dialog(
        elevation: 0,
        insetPadding: EdgeInsets.all(0),
        backgroundColor: Colors.transparent,
        child: Center(
          child: SizedBox(
              height: 60,
              width: 60,
              child: CircularProgressIndicator(strokeWidth: 1)),
        ));
  }
}
