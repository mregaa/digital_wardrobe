import 'package:flutter/material.dart';

/// Custom painter for drawing grid background like Marvelous Designer workspace
class GridCanvasPainter extends CustomPainter {
  final Color gridColor;
  final double smallGridSize;
  final double largeGridSize;

  GridCanvasPainter({
    this.gridColor = const Color(0xFFE0E0E0),
    this.smallGridSize = 20.0,
    this.largeGridSize = 100.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final smallGridPaint = Paint()
      ..color = gridColor.withOpacity(0.3)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final largeGridPaint = Paint()
      ..color = gridColor.withOpacity(0.6)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Draw small grid lines (vertical)
    for (double x = 0; x <= size.width; x += smallGridSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        smallGridPaint,
      );
    }

    // Draw small grid lines (horizontal)
    for (double y = 0; y <= size.height; y += smallGridSize) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        smallGridPaint,
      );
    }

    // Draw large grid lines (vertical)
    for (double x = 0; x <= size.width; x += largeGridSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        largeGridPaint,
      );
    }

    // Draw large grid lines (horizontal)
    for (double y = 0; y <= size.height; y += largeGridSize) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        largeGridPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
