import 'package:flutter/material.dart';
import 'dart:ui';
// import 'package:flutter_svg/flutter_svg.dart';

class MoodFacePage extends StatefulWidget {
  const MoodFacePage({super.key});

  @override
  State<MoodFacePage> createState() => _MoodFacePageState();
}

class MoodFaceData {
  final String label;

  // Geometry
  final double eyeYOffset;
  final double eyeScale;
  final double eyeSpacing;
  final double mouthCurve;
  final double mouthWidth;
  final double mouthY;

  // Theme
  final Color background;
  final Color foreground;

  // Decorations
  final bool heartEyes;
  final bool stressMark;
  final bool tear;

  const MoodFaceData({
    required this.label,
    required this.background,
    this.foreground = Colors.black,
    this.eyeYOffset = 0,
    this.eyeScale = 1,
    this.eyeSpacing = 35,
    this.mouthCurve = 0,
    this.mouthWidth = 50,
    this.mouthY = 32,
    this.heartEyes = false,
    this.stressMark = false,
    this.tear = false,
  });

  /// 🔥 Morph between two moods
  static MoodFaceData lerp(MoodFaceData a, MoodFaceData b, double t) {
    return MoodFaceData(
      label: t < 0.5 ? a.label : b.label,
      background: Color.lerp(a.background, b.background, t)!,
      foreground: Color.lerp(a.foreground, b.foreground, t)!,

      eyeYOffset: lerpDouble(a.eyeYOffset, b.eyeYOffset, t)!,
      eyeScale: lerpDouble(a.eyeScale, b.eyeScale, t)!,
      eyeSpacing: lerpDouble(a.eyeSpacing, b.eyeSpacing, t)!,

      mouthCurve: lerpDouble(a.mouthCurve, b.mouthCurve, t)!,
      mouthWidth: lerpDouble(a.mouthWidth, b.mouthWidth, t)!,
      mouthY: lerpDouble(a.mouthY, b.mouthY, t)!,

      // Decorations fade logically instead of blending
      heartEyes: t > 0.7 ? b.heartEyes : a.heartEyes,
      stressMark: t > 0.7 ? b.stressMark : a.stressMark,
      tear: t > 0.7 ? b.tear : a.tear,
    );
  }
}

const moods = [

  MoodFaceData(
    label: "Happy",
    background: Color(0xFF7FBF9F),
    mouthCurve: 0.9,
  ),

  MoodFaceData(
    label: "Calm",
    background: Color(0xFF9EC3D6),
    mouthCurve: 0.3,
    eyeScale: 0.9,
  ),

  MoodFaceData(
    label: "Neutral",
    background: Color(0xFFE0E0E0),
    mouthCurve: 0,
  ),

  MoodFaceData(
    label: "Sad",
    background: Color(0xFF6C83D6),
    mouthCurve: -0.8,
  ),

  MoodFaceData(
    label: "Stressed",
    background: Color(0xFFD87575),
    mouthCurve: -0.4,
    stressMark: true,
  ),

  MoodFaceData(
    label: "Fear",
    background: Color(0xFF9B8FD1),
    mouthCurve: -0.2,
    eyeScale: 1.1,
    tear: true,
  ),

  MoodFaceData(
    label: "Love",
    background: Color(0xFFE6A0A0),
    mouthCurve: 0.7,
    heartEyes: true,
  ),
];


class _MoodFacePageState extends State<MoodFacePage> {
  int selectedMood = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // FACE
          TweenAnimationBuilder<double>(
            tween: Tween(begin: selectedMood.toDouble(), end: selectedMood.toDouble()),
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            builder: (context, value, _) {
              return MoodFace(data: moodLibrary[selectedMood]);
            },
          ),

          const SizedBox(height: 40),

          // SLIDER
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackShape: _TrackShape(),
                tickMarkShape: const _TickMarkShape(),

                activeTrackColor: Colors.transparent,
                inactiveTrackColor: Colors.transparent,

                overlayColor: Colors.transparent,
                thumbColor: Colors.black,

                showValueIndicator: ShowValueIndicator.never,
              ),
              child: Slider(
                min: 0,
                max: (moodLibrary.length - 1).toDouble(),
                divisions: moodLibrary.length - 1,
                value: selectedMood.toDouble(),
                onChanged: (v) {
                  setState(() => selectedMood = v.round());
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrackShape extends SliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = 0; // we control height manually
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height / 2) - trackHeight / 2;
    final double trackWidth = parentBox.size.width;

    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isEnabled = false,
    bool isDiscrete = false,
    required TextDirection textDirection,
    double additionalActiveTrackHeight = 0,
  }) {
    final Canvas canvas = context.canvas;

    final rect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final y = rect.center.dy;

    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(rect.left, y),
      Offset(rect.right, y),
      paint,
    );
  }
}

class _TickMarkShape extends SliderTickMarkShape {
  const _TickMarkShape();

  @override
  Size getPreferredSize({
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
  }) {
    return const Size(10, 10);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset thumbCenter,
    bool isEnabled = false,
    required TextDirection textDirection,
  }) {
    final Canvas canvas = context.canvas;

    final paint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 8, paint);
  }
}

class MoodFace extends StatelessWidget {
  final MoodFaceData data;

  const MoodFace({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 140,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _eye(left: true),
          _eye(left: false),

          Positioned(
            bottom: data.mouthY,
            child: CustomPaint(
              size: Size(data.mouthWidth, 25),
              painter: MouthPainter(data.mouthCurve),
            ),
          ),

          if (data.tear) _tear(),
          if (data.stressMark) _stress(),
        ],
      ),
    );
  }

  Widget _eye({required bool left}) {
    return Positioned(
      left: left ? data.eyeSpacing : null,
      right: left ? null : data.eyeSpacing,
      top: 40 + data.eyeYOffset,
      child: Transform.scale(
        scale: data.eyeScale,
        child: Container(
          width: 12,
          height: 12,
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _tear() {
    return Positioned(
      top: 40 + data.eyeYOffset,
      child: Transform.scale(
        scale: data.eyeScale,
        child: Container(
          width: 12,
          height: 12,
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _stress() {
    return Positioned(
      top: 40 + data.eyeYOffset,
      child: Transform.scale(
        scale: data.eyeScale,
        child: Container(
          width: 12,
          height: 12,
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class MouthPainter extends CustomPainter {
  final double curve;

  MouthPainter(this.curve);

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();

    path.moveTo(0, size.height / 2);
    path.quadraticBezierTo(
      size.width / 2,
      size.height / 2 + curve * 14,
      size.width,
      size.height / 2,
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(covariant MouthPainter oldDelegate)
    => oldDelegate.curve != curve;
}
