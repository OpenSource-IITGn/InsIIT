import 'package:flutter/material.dart';
import 'package:instiapp/utilities/measureSize.dart';
import 'package:instiapp/utilities/constants.dart';

class LabelBorder extends ShapeBorder {
  final double arrowWidth;
  final double arrowHeight;
  final double arrowArc;
  final double radius;

  LabelBorder({
    this.radius = 8.0,
    this.arrowWidth = 15.0,
    this.arrowHeight = 5.0,
    this.arrowArc = 0.0,
  }) : assert(arrowArc <= 1.0 && arrowArc >= 0.0);

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.only(bottom: arrowHeight);

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) => null;

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    rect = Rect.fromPoints(
        rect.topLeft, rect.bottomRight - Offset(0, arrowHeight));
    double x = arrowWidth, y = arrowHeight, r = 1 - arrowArc;
    return Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)))
      ..moveTo(rect.bottomCenter.dx + x / 2, rect.bottomCenter.dy)
      ..relativeLineTo(-x / 2 * r, y * r)
      ..relativeQuadraticBezierTo(
          -x / 2 * (1 - r), y * (1 - r), -x * (1 - r), 0)
      ..relativeLineTo(-x / 2 * r, -y * r);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}

Widget label(String text, sizeCallback) {
  return MeasureSize(
    onChange: (Size size) {
      sizeCallback(size);
    },
    child: Center(
      child: Container(
        decoration: ShapeDecoration(
          color: (darkMode) ? Colors.white : Colors.black.withAlpha(200),
          shape: LabelBorder(arrowArc: 0.1),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Text(text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: (darkMode) ? Colors.black : Colors.white,
                fontSize: 10,
              )),
        ),
      ),
    ),
  );
}
