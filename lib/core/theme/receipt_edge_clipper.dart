import 'package:flutter/rendering.dart';

/// Sawtooth paper edges for [ReceiptPreview] (8 px teeth per the .pen frame).
class ReceiptEdgeClipper extends CustomClipper<Path> {
  const ReceiptEdgeClipper({this.toothWidth = 8, this.toothHeight = 8});

  final double toothWidth, toothHeight;

  @override
  Path getClip(Size size) {
    final path = Path()..moveTo(0, toothHeight);
    for (var x = 0.0; x < size.width; x += toothWidth) {
      path.lineTo(x + toothWidth / 2, 0);
      path.lineTo(x + toothWidth, toothHeight);
    }
    path.lineTo(size.width, size.height - toothHeight);
    for (var x = size.width; x > 0; x -= toothWidth) {
      path.lineTo(x - toothWidth / 2, size.height);
      path.lineTo(x - toothWidth, size.height - toothHeight);
    }
    return path..close();
  }

  @override
  bool shouldReclip(covariant ReceiptEdgeClipper oldClipper) =>
      oldClipper.toothWidth != toothWidth || oldClipper.toothHeight != toothHeight;
}
