import 'package:flutter/material.dart';

class PlatePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    Path path = Path();

    // Path number 1

    paint.color = Color(0xfffcfafa);
    path = Path();
    path.lineTo(0, 0);
    path.cubicTo(0, 0, size.width, 0, size.width, 0);
    path.cubicTo(
        size.width, 0, size.width, size.height, size.width, size.height);
    path.cubicTo(size.width, size.height, 0, size.height, 0, size.height);
    path.cubicTo(0, size.height, 0, 0, 0, 0);
    canvas.drawPath(path, paint);

    // Path number 2

    paint.color = Color(0xfffcfafa);
    path = Path();
    path.lineTo(size.width * 0.05, size.height * 0.06);
    path.cubicTo(size.width * 0.05, size.height * 0.06, size.width * 0.28,
        size.height * 0.06, size.width * 0.28, size.height * 0.06);
    path.cubicTo(size.width * 0.28, size.height * 0.06, size.width * 0.28,
        size.height * 0.36, size.width * 0.28, size.height * 0.36);
    path.cubicTo(size.width * 0.28, size.height * 0.36, size.width * 0.05,
        size.height * 0.36, size.width * 0.05, size.height * 0.36);
    path.cubicTo(size.width * 0.05, size.height * 0.36, size.width * 0.05,
        size.height * 0.06, size.width * 0.05, size.height * 0.06);
    canvas.drawPath(path, paint);

    // Path number 3

    paint.color = Color(0xfffcfafa);
    path = Path();
    path.lineTo(size.width * 0.67, size.height * 0.06);
    path.cubicTo(size.width * 0.67, size.height * 0.06, size.width * 0.28,
        size.height * 0.06, size.width * 0.28, size.height * 0.06);
    path.cubicTo(size.width * 0.28, size.height * 0.06, size.width * 0.28,
        size.height * 0.36, size.width * 0.28, size.height * 0.36);
    path.cubicTo(size.width * 0.28, size.height * 0.36, size.width * 0.67,
        size.height * 0.36, size.width * 0.67, size.height * 0.36);
    path.cubicTo(size.width * 0.67, size.height * 0.36, size.width * 0.67,
        size.height * 0.06, size.width * 0.67, size.height * 0.06);
    canvas.drawPath(path, paint);

    // Path number 4

    paint.color = Color(0xfffcfafa);
    path = Path();
    path.lineTo(size.width * 0.36, size.height * 0.06);
    path.cubicTo(size.width * 0.36, size.height * 0.06, size.width * 0.28,
        size.height * 0.06, size.width * 0.28, size.height * 0.06);
    path.cubicTo(size.width * 0.28, size.height * 0.06, size.width * 0.28,
        size.height * 0.36, size.width * 0.28, size.height * 0.36);
    path.cubicTo(size.width * 0.28, size.height * 0.36, size.width * 0.36,
        size.height * 0.36, size.width * 0.36, size.height * 0.36);
    path.cubicTo(size.width * 0.36, size.height * 0.36, size.width * 0.36,
        size.height * 0.06, size.width * 0.36, size.height * 0.06);
    canvas.drawPath(path, paint);

    // Path number 5

    paint.color = Color(0xfffcfafa);
    path = Path();
    path.lineTo(size.width * 0.05, size.height * 0.47);
    path.cubicTo(size.width * 0.05, size.height * 0.47, size.width * 0.9,
        size.height * 0.47, size.width * 0.9, size.height * 0.47);
    path.cubicTo(size.width * 0.9, size.height * 0.47, size.width * 0.9,
        size.height * 0.49, size.width * 0.9, size.height * 0.49);
    path.cubicTo(size.width * 0.9, size.height * 0.49, size.width * 0.05,
        size.height * 0.49, size.width * 0.05, size.height * 0.49);
    path.cubicTo(size.width * 0.05, size.height * 0.49, size.width * 0.05,
        size.height * 0.47, size.width * 0.05, size.height * 0.47);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
