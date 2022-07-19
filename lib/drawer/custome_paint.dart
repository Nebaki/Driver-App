import 'package:flutter/material.dart';

class DrawerBackGround extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();

    Path mainbackround = Path();
    mainbackround.addRect(Rect.fromLTRB(0, 0, width, height));
    paint.color = const Color.fromRGBO(230, 230, 234, 1);
    canvas.drawPath(mainbackround, paint);

    Path bottomPath = Path();

    bottomPath.moveTo(width * 0.0, height * 0.4);
    bottomPath.quadraticBezierTo(
        width * 0.05, height * 0.33, width * 0.2, height * 0.3);

    bottomPath.quadraticBezierTo(
        width * 0.3, height * 0.28, width * 0.7, height * 0.22);

    bottomPath.quadraticBezierTo(width, height * 0.18, width, height * 0.28);

    bottomPath.quadraticBezierTo(width, height * 0.4, width, height);

    bottomPath.lineTo(0, height);

    paint.color = Colors.red.shade900;

    canvas.drawPath(bottomPath, paint);

    //ovalPath.quadraticBezierTo(, y1, x2, y2)
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
