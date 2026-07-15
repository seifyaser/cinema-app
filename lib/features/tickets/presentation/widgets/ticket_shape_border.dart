import 'package:flutter/material.dart';

class TicketShapeBorder extends ShapeBorder {
  final double cornerRadius;
  final double cutoutRadius;
  final double cutoutPositionRatio; // 0.0 to 1.0 (relative Y position of the cutouts)

  const TicketShapeBorder({
    this.cornerRadius = 16.0,
    this.cutoutRadius = 16.0,
    this.cutoutPositionRatio = 0.716, // matches SVG (333 / 465)
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final cutoutY = rect.height * cutoutPositionRatio;

    return Path()
      ..moveTo(rect.left + cornerRadius, rect.top)
      ..lineTo(rect.right - cornerRadius, rect.top)
      ..arcToPoint(
        Offset(rect.right, rect.top + cornerRadius),
        radius: Radius.circular(cornerRadius),
      )
      ..lineTo(rect.right, cutoutY - cutoutRadius)
      ..arcToPoint(
        Offset(rect.right, cutoutY + cutoutRadius),
        radius: Radius.circular(cutoutRadius),
        clockwise: false,
      )
      ..lineTo(rect.right, rect.bottom - cornerRadius)
      ..arcToPoint(
        Offset(rect.right - cornerRadius, rect.bottom),
        radius: Radius.circular(cornerRadius),
      )
      ..lineTo(rect.left + cornerRadius, rect.bottom)
      ..arcToPoint(
        Offset(rect.left, rect.bottom - cornerRadius),
        radius: Radius.circular(cornerRadius),
      )
      ..lineTo(rect.left, cutoutY + cutoutRadius)
      ..arcToPoint(
        Offset(rect.left, cutoutY - cutoutRadius),
        radius: Radius.circular(cutoutRadius),
        clockwise: false,
      )
      ..lineTo(rect.left, rect.top + cornerRadius)
      ..arcToPoint(
        Offset(rect.left + cornerRadius, rect.top),
        radius: Radius.circular(cornerRadius),
      )
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) {
    return TicketShapeBorder(
      cornerRadius: cornerRadius * t,
      cutoutRadius: cutoutRadius * t,
      cutoutPositionRatio: cutoutPositionRatio,
    );
  }
}
