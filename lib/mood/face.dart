import 'package:flutter/material.dart';
import 'dart:math';

import '../data/data.dart';


class MoodFace extends StatelessWidget {
  final MoodFaceData data;
  final double scalePercentage;

  const MoodFace({super.key, required this.data, required this.scalePercentage});

  @override
  Widget build(BuildContext context) {
    final faceWidth  =
        data.eyeRadius * 4 + data.eyeSpacing * 2;

    final faceHeight =
        data.eyeRadius * 2 + data.mouthHeight;

    final totalWidth  = faceWidth + data.extraSize * 2;
    final totalHeight = faceHeight + data.extraSize;

    return SizedBox(
      width: totalWidth,
      height: totalHeight,
      child: Stack(
        children: [
          SizedBox(
            width: totalWidth,
            height: totalHeight,
            child: Stack(
              children: [
                Positioned(
                  top: data.extraSize,
                  left: data.extraSize,
                  child: CustomPaint(
                    size: Size(faceWidth, data.eyeRadius * 2),
                    painter: EyesPainter(
                      radius: data.eyeRadius,
                      spacing: data.eyeSpacing,
                      center: Offset(
                        faceWidth / 2,
                        data.eyeRadius,
                      ),
                      heart: data.eyeHeart,
                      open: data.eyeOpen,
                      scalePercentage: scalePercentage,
                    ),
                  ),
                ),
                Positioned(
                  top: data.eyeRadius * 2 + data.extraSize,
                  left: data.extraSize,
                  child: CustomPaint(
                    size: Size(faceWidth, data.mouthHeight),
                    painter: MouthPainter(
                      radius: data.mouthHeight / 2,
                      center: Offset(
                        faceWidth / 2,
                        data.mouthHeight / 2,
                      ),
                      smile: data.mouthSmile,
                      close: data.mouthClose,
                      rotation: data.mouthRotation,
                      scalePercentage: scalePercentage,
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: CustomPaint(
                    size: Size(data.extraSize, data.extraSize * 1.7),
                    painter: TearPainter(
                      center: Offset(
                        data.extraSize / 2,
                        data.extraSize,
                      ),
                      tear: data.tear,
                      size: data.extraSize,
                      scalePercentage: scalePercentage,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: CustomPaint(
                    size: Size(data.extraSize * 1.2, data.extraSize * 1.2),
                    painter: StressPainter(
                      center: Offset(
                        data.extraSize * 0.6,
                        data.extraSize * 0.6,
                      ),
                      stress: data.stress,
                      size: data.extraSize * 1.2,
                      scalePercentage: scalePercentage,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EyesPainter extends CustomPainter {
  final double radius;
  final double spacing;
  final Offset center;
  final double heart;
  final double open;
  final double scalePercentage;

  const EyesPainter({
    required this.radius,
    required this.spacing,
    required this.center,
    required this.heart,
    required this.open,
    required this.scalePercentage,
  });

  Offset L(Offset a, Offset b, double t) => Offset.lerp(a, b, t)!;

  @override
  void paint(Canvas canvas, Size size) {
    final k = 1.313 * radius;

    final fillPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12 * scalePercentage
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // --- Eye positions (WORLD SPACE) ---
    final leftCenter  = Offset(center.dx - radius - spacing, center.dy);
    final rightCenter = Offset(center.dx + radius + spacing, center.dy);

    // --- Draw both eyes ---
    _drawEye(canvas, leftCenter, k, fillPaint, strokePaint);
    _drawEye(canvas, rightCenter, k, fillPaint, strokePaint);
  }

  void _drawEye(
    Canvas canvas,
    Offset eyeCenter,
    double k,
    Paint fillPaint,
    Paint strokePaint,
  ) {
    canvas.save();

    // Move to this eye's pivot
    canvas.translate(eyeCenter.dx, eyeCenter.dy);

    // Rotate ONLY the eye shape (not layout)
    canvas.rotate(heart * pi / 2);

    final path = _buildEyePath(k);

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);

    canvas.restore();
  }

  Path _buildEyePath(double k) {
    // -------------------------------
    // ALL GEOMETRY IS LOCAL (0,0)
    // -------------------------------

    // ---- Circle control points ----
    final circleStart = Offset(-radius, 0);

    final circleC1P1 = Offset(-radius, -k * open);
    final circleC1P2 = Offset( radius, -k * open);
    final circleC1P3 = Offset( radius, 0);

    final circleC2P1 = Offset( radius,  k);
    final circleC2P2 = Offset(-radius,  k);

    // ---- Heart control points ----
    final heartStart = Offset(-radius * 0.25, 0);

    final heartC1P1 = Offset(-radius * 1.3, -radius * 0.6);
    final heartC1P2 = Offset( radius * 0.15, -radius * 1.8);
    final heartC1P3 = Offset( radius, 0);

    final heartC2P1 = Offset( radius * 0.15,  radius * 1.8);
    final heartC2P2 = Offset(-radius * 1.3,  radius * 0.6);

    // ---- Interpolate circle → heart ----
    final start = L(circleStart, heartStart, heart);

    final c1p1 = L(circleC1P1, heartC1P1, heart);
    final c1p2 = L(circleC1P2, heartC1P2, heart);
    final c1p3 = L(circleC1P3, heartC1P3, heart);

    final c2p1 = L(circleC2P1, heartC2P1, heart);
    final c2p2 = L(circleC2P2, heartC2P2, heart);

    return Path()
      ..moveTo(start.dx, start.dy)
      ..cubicTo(c1p1.dx, c1p1.dy, c1p2.dx, c1p2.dy, c1p3.dx, c1p3.dy)
      ..cubicTo(c2p1.dx, c2p1.dy, c2p2.dx, c2p2.dy, start.dx, start.dy)
      ..close();
  }

  @override
  bool shouldRepaint(covariant EyesPainter oldDelegate) =>
      oldDelegate.heart != heart ||
      oldDelegate.open != open ||
      oldDelegate.radius != radius ||
      oldDelegate.spacing != spacing;
}

class MouthPainter extends CustomPainter {
  final double radius;
  final Offset center;
  final double smile;
  final double close;
  final double rotation;
  final double scalePercentage;

  const MouthPainter({
    required this.radius,
    required this.center,
    required this.smile,
    required this.close,
    required this.rotation,
    required this.scalePercentage,
  });
  
  Offset L(Offset a, Offset b, double t) => Offset.lerp(a, b, t)!;
  
  @override
  void paint(Canvas canvas, Size size) {
//     final double k = 1.33100624702 * radius;
      canvas.save();

      // Rotate around the mouth center
      canvas.translate(center.dx, center.dy);
      canvas.rotate(rotation);
      canvas.translate(-center.dx, -center.dy);

    final fillPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    
    final strokePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 12 * scalePercentage;
    
    final start = Offset(center.dx - radius, center.dy - radius * smile * 0.3);
    
    final c1p1 = Offset(center.dx - radius * 0.8, center.dy + radius * close * smile - radius * smile * 0.3);
    final c1p2 = Offset(center.dx + radius * 0.8, center.dy + radius * close * smile - radius * smile * 0.3);
    final c1p3 = Offset(center.dx + radius, center.dy - radius * smile * 0.3);
    
    final c2p1 = Offset(center.dx + radius * 0.8, center.dy + radius * smile - radius * smile * 0.3);
    final c2p2 = Offset(center.dx - radius * 0.8, center.dy + radius * smile - radius * smile * 0.3);
    
    final Path path = Path()
      ..moveTo(start.dx, start.dy)

      ..cubicTo(
        c1p1.dx, c1p1.dy,
        c1p2.dx, c1p2.dy,
        c1p3.dx, c1p3.dy,
      )

      ..cubicTo(
        c2p1.dx, c2p1.dy,
        c2p2.dx, c2p2.dy,
        start.dx,  start.dy,
      )

      ..close();

    canvas.drawPath(path, strokePaint);
    canvas.drawPath(path, fillPaint);

    canvas.restore(); // IMPORTANT
  }

  @override
  bool shouldRepaint(covariant MouthPainter oldDelegate) => true;
}

class TearPainter extends CustomPainter {
  final Offset center;
  final double size;
  final double tear;
  final double scalePercentage;

  const TearPainter({
    required this.center,
    required this.tear,
    required this.size,
    required this.scalePercentage,
  });

  double lerpDouble(double x, double y, double t) => x + (y - x) * t;
  
  @override
  void paint(Canvas canvas, Size canvasSize) {
    if (tear <= 0) return;
    final double scale = lerpDouble(0.2, 1.0, tear) * scalePercentage;
    final double opacity = lerpDouble(0.0, 1, tear);
    final double strokeW = lerpDouble(1.0, 12, tear);

    final fillPaint = Paint()
      ..color = Colors.black.withAlpha((255 * opacity).toInt())
      ..style = PaintingStyle.fill
      ..strokeWidth = strokeW;

    final strokePaint = Paint()
      ..color = Colors.black.withAlpha((255 * opacity).toInt())
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeJoin = StrokeJoin.round;

    canvas.save();

    // Move to tear position
    canvas.translate(center.dx, center.dy);

    // Apply growth animation
    canvas.scale(scale, scale);

    final path = _buildTearPath(size);

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);

    canvas.restore();
  }

  Path _buildTearPath(double s) {
    final h = s * 0.35;
    final w = s * 0.25;

    return Path()
      ..moveTo(0, -h)
      ..cubicTo(
        -w * 0.5, -h * 0.6,
        -w * 1.4,  h,
         0,  h,
      )
      ..cubicTo(
         w * 1.4,  h,
         w * 0.5, -h * 0.6,
         0, -h,
      )
      ..close();
  }

  @override
  bool shouldRepaint(covariant TearPainter oldDelegate) =>
      oldDelegate.tear != tear ||
      oldDelegate.center != center ||
      oldDelegate.size != size;
}

class StressPainter extends CustomPainter {
  final Offset center;
  final double size;
  final double stress;
  final double scalePercentage;

  const StressPainter({
    required this.center,
    required this.stress,
    required this.size,
    required this.scalePercentage,
  });

  double lerpDouble(double x, double y, double t) => x + (y - x) * t;
  
  @override
  void paint(Canvas canvas, Size canvasSize) {
    if (stress <= 0) return;

    // ---- Animate scale ----
    final double scale = lerpDouble(0.2, 1.0, stress) * scalePercentage;

    // ---- Animate opacity ----
    final double opacity = lerpDouble(0.0, 1, stress);

    // ---- Animate stroke thickness ----
    final double strokeW = lerpDouble(1.0, 8, stress) * scalePercentage;

    final strokePaint = Paint()
      ..color = Colors.black.withAlpha((255 * opacity).toInt())
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.round;

    canvas.save();

    // Move to stress position
    canvas.translate(center.dx, center.dy);

    // Apply growth animation
    canvas.scale(scale, scale);

    final paths = _buildStressPath(size);

    for (int i = 0; i < paths.length; i++) {
      canvas.drawPath(paths[i], strokePaint);
    }

    canvas.restore();
  }

  List<Path> _buildStressPath(double s) {
    // SVG original size

    // scale factor so caller controls final size
    final double scale = s / size * scalePercentage;

    Offset map(double x, double y) {
      // center the SVG around (0,0) because canvas is already translated
      final dx = (x - size / 2) * scale;
      final dy = (y - size / 2) * scale;
      return Offset(dx, dy);
    }

    final List<Path> paths = [];

    // ---- Top stroke ----
    Offset point1 = map(8.5, 3.5);
    Offset point2 = map(13.5, 9);
    Offset point3 = map(23.5, 7);
    Offset point4 = map(27.5, 2);
    
    paths.add(
      Path()
        ..moveTo(point1.dx, point1.dy)
        ..cubicTo(
          point2.dx, point2.dy,
          point3.dx, point3.dy,
          point4.dx, point4.dy,
        ),
    );
    
    point1 = map(6, 27);
    point2 = map(12.5, 22.5);
    point3 = map(11, 15);
    point4 = map(3.5, 13.5);

    // ---- Left stroke ----
    paths.add(
      Path()
        ..moveTo(point1.dx, point1.dy)
        ..cubicTo(
          point2.dx, point2.dy,
          point3.dx, point3.dy,
          point4.dx, point4.dy,
        ),
    );
    
    point1 = map(33, 23.5);
    point2 = map(29, 18.5);
    point3 = map(30, 12.5);
    point4 = map(36, 8);

    // ---- Right stroke ----
    paths.add(
      Path()
        ..moveTo(point1.dx, point1.dy)
        ..cubicTo(
          point2.dx, point2.dy,
          point3.dx, point3.dy,
          point4.dx, point4.dy,
        ),
    );
    
    point1 = map(26, 30.5);
    point2 = map(22, 27.5);
    point3 = map(16.5, 29);
    point4 = map(14.5, 34);

    // ---- Bottom stroke ----
    paths.add(
      Path()
        ..moveTo(point1.dx, point1.dy)
        ..cubicTo(
          point2.dx, point2.dy,
          point3.dx, point3.dy,
          point4.dx, point4.dy,
        ),
    );
    
    return paths;
  }


  @override
  bool shouldRepaint(covariant StressPainter oldDelegate) =>
      oldDelegate.stress != stress ||
      oldDelegate.center != center ||
      oldDelegate.size != size;
}