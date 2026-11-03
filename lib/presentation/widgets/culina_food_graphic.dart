import 'package:flutter/material.dart';

class CulinaFoodGraphic extends StatelessWidget {
  final String icon;
  final String colorTheme;
  final double size;
  final bool showBackground;

  const CulinaFoodGraphic({
    super.key,
    required this.icon,
    this.colorTheme = 'Trigo',
    this.size = 120,
    this.showBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    // If it's the featured rustic toast, or lettuce, let's draw the stylish artisan vector!
    final bool isToast = icon == '🥖' || icon == '🍞' || icon == '🥪';
    final bool isSalad = icon == '🥗' || icon == '🥬';

    Widget graphic;
    if (isToast) {
      graphic = CustomPaint(
        size: Size(size * 0.7, size * 0.7),
        painter: _RusticToastPainter(),
      );
    } else if (isSalad) {
      graphic = CustomPaint(
        size: Size(size * 0.7, size * 0.7),
        painter: _FreshSaladPainter(),
      );
    } else {
      graphic = Text(
        icon,
        style: TextStyle(fontSize: size * 0.5),
      );
    }

    if (!showBackground) {
      return Center(child: graphic);
    }

    return Container(
      width: double.infinity,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F5EE),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: graphic,
      ),
    );
  }
}

/// Custom painter that draws the stylized yellow/amber toast with bold outline as seen in Figma!
class _RusticToastPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 100.0;

    canvas.save();
    canvas.scale(scale);

    // Rotate slightly like in Figma screenshot (-35 degrees)
    canvas.translate(50, 50);
    canvas.rotate(-0.55);
    canvas.translate(-50, -50);

    final fillPaint = Paint()
      ..color = const Color(0xFFFFD43F) // Bright golden yellow from mockup
      ..style = PaintingStyle.fill;

    final crustPaint = Paint()
      ..color = const Color(0xFFE89814) // Deep crust amber
      ..style = PaintingStyle.fill;

    final outlinePaint = Paint()
      ..color = const Color(0xFF1E1E1E) // Bold dark outline
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final rrect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(18, 30, 64, 26),
      const Radius.circular(13),
    );

    // Bread background
    canvas.drawRRect(rrect, crustPaint);
    canvas.drawRRect(rrect, outlinePaint);

    // Inside butter/melt layer
    final innerRRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(24, 34, 52, 18),
      const Radius.circular(9),
    );
    canvas.drawRRect(innerRRect, fillPaint);

    // Crust accent notch
    final notchPaint = Paint()
      ..color = const Color(0xFF1E1E1E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(const Offset(30, 26), const Offset(36, 30), notchPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom painter for the fresh greens / lettuce leaf graphic as seen on Screen 6!
class _FreshSaladPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 100.0;

    canvas.save();
    canvas.scale(scale);

    // Rotate slightly like in screenshot
    canvas.translate(50, 50);
    canvas.rotate(-0.6);
    canvas.translate(-50, -50);

    final stemPaint = Paint()
      ..color = const Color(0xFFE2F0D9)
      ..style = PaintingStyle.fill;

    final leafPaint = Paint()
      ..color = const Color(0xFF48BB78) // Fresh green
      ..style = PaintingStyle.fill;

    final outlinePaint = Paint()
      ..color = const Color(0xFF1E1E1E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Draw leafy top
    final path = Path();
    path.moveTo(40, 20);
    path.cubicTo(25, 20, 20, 35, 30, 48);
    path.cubicTo(20, 55, 30, 70, 45, 68);
    path.cubicTo(55, 75, 75, 70, 75, 55);
    path.cubicTo(85, 45, 80, 28, 65, 22);
    path.cubicTo(55, 16, 48, 18, 40, 20);
    path.close();

    canvas.drawPath(path, leafPaint);
    canvas.drawPath(path, outlinePaint);

    // Stem
    final stemRRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(42, 60, 16, 26),
      const Radius.circular(8),
    );
    canvas.drawRRect(stemRRect, stemPaint);
    canvas.drawRRect(stemRRect, outlinePaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

