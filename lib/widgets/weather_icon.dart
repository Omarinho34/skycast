import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/weather_visuals.dart';

/// Petites icônes météo dessinées à la main (soleil, lune, nuage, pluie…),
/// dans l'esprit « outline rond » du design. Tracées sur un repère logique
/// 48×48 puis mises à l'échelle.
class WeatherIcon extends StatelessWidget {
  const WeatherIcon({
    super.key,
    required this.glyph,
    this.size = 44,
    this.onDark = false,
  });

  final WeatherGlyph glyph;
  final double size;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _WeatherIconPainter(glyph, onDark)),
    );
  }
}

class _WeatherIconPainter extends CustomPainter {
  _WeatherIconPainter(this.glyph, this.onDark);

  final WeatherGlyph glyph;
  final bool onDark;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 48.0);
    switch (glyph) {
      case WeatherGlyph.sun:
        _sun(canvas);
      case WeatherGlyph.moon:
        _moon(canvas);
      case WeatherGlyph.cloud:
        _cloud(canvas, _cloudColor);
      case WeatherGlyph.rain:
        _cloud(canvas, _cloudColor, dy: -3);
        _streaks(canvas, _accentColor);
      case WeatherGlyph.snow:
        _cloud(canvas, _cloudColor, dy: -3);
        _dots(canvas, _accentColor);
      case WeatherGlyph.thunder:
        _cloud(canvas, _cloudColor, dy: -3);
        _bolt(canvas);
      case WeatherGlyph.mist:
        _mist(canvas, _cloudColor);
    }
    canvas.restore();
  }

  Color get _cloudColor =>
      onDark ? const Color(0xFFCFCBEF) : const Color(0xFFA9B4BD);
  Color get _accentColor =>
      onDark ? const Color(0xFFB9C4E8) : const Color(0xFF4F86A8);

  void _sun(Canvas canvas) {
    const center = Offset(24, 24);
    final rays = Paint()
      ..color = const Color(0xFFFF9F2E)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 8; i++) {
      final a = i * math.pi / 4;
      final d = Offset(math.cos(a), math.sin(a));
      canvas.drawLine(center + d * 12.5, center + d * 16.5, rays);
    }
    canvas.drawCircle(center, 9, Paint()..color = const Color(0xFFFFB23E));
  }

  void _moon(Canvas canvas) {
    final full = Path()
      ..addOval(Rect.fromCircle(center: const Offset(23, 24), radius: 12));
    final cut = Path()
      ..addOval(Rect.fromCircle(center: const Offset(29, 19), radius: 11));
    canvas.drawPath(
      Path.combine(PathOperation.difference, full, cut),
      Paint()..color = const Color(0xFFCFCBEF),
    );
  }

  void _cloud(Canvas canvas, Color color, {double dy = 0}) {
    final p = Paint()..color = color;
    canvas.save();
    canvas.translate(0, dy);
    canvas.drawRRect(
      RRect.fromLTRBR(11, 24, 39, 34, const Radius.circular(7)),
      p,
    );
    canvas.drawCircle(const Offset(20, 23), 9, p);
    canvas.drawCircle(const Offset(30, 21), 11, p);
    canvas.drawCircle(const Offset(35, 27), 6.5, p);
    canvas.restore();
  }

  void _streaks(Canvas canvas, Color color) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(18, 34), const Offset(16, 41), p);
    canvas.drawLine(const Offset(26, 34), const Offset(24, 41), p);
    canvas.drawLine(const Offset(34, 34), const Offset(32, 41), p);
  }

  void _dots(Canvas canvas, Color color) {
    final p = Paint()..color = color;
    canvas.drawCircle(const Offset(18, 38), 2, p);
    canvas.drawCircle(const Offset(25, 40), 2, p);
    canvas.drawCircle(const Offset(32, 38), 2, p);
  }

  void _bolt(Canvas canvas) {
    final path = Path()
      ..moveTo(25, 33)
      ..lineTo(20, 42)
      ..lineTo(24, 42)
      ..lineTo(22, 48)
      ..lineTo(30, 39)
      ..lineTo(25, 39)
      ..close();
    canvas.drawPath(path, Paint()..color = const Color(0xFFFFC24E));
  }

  void _mist(Canvas canvas, Color color) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(12, 20), const Offset(34, 20), p);
    canvas.drawLine(const Offset(14, 27), const Offset(36, 27), p);
    canvas.drawLine(const Offset(12, 34), const Offset(30, 34), p);
  }

  @override
  bool shouldRepaint(covariant _WeatherIconPainter old) =>
      old.glyph != glyph || old.onDark != onDark;
}
