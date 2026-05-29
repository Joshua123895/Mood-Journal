import 'package:flutter/material.dart';

import '../data/data.dart';
import 'face.dart';

class MoodFacePage extends StatefulWidget {
  const MoodFacePage({super.key});

  @override
  State<MoodFacePage> createState() => _MoodFacePageState();
}

class _MoodFacePageState extends State<MoodFacePage> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();

  double _index = (moodLibrary.length / 2).floorToDouble(); // middle of the moodLibrary
  double _targetIndex = 0;

  static const double _step = 10;
  int get divisions => moodLibrary.length - 1;
  double get min => 0;
  double get max => divisions * _step;

  late AnimationController _motionController;
  Animation<double>? _motionAnimation;

  MoodFaceData _currentMood(double index) {
    final int i0 = index.floor().clamp(0, moodLibrary.length - 1);
    final int i1 = (i0 + 1).clamp(0, moodLibrary.length - 1);

    final double t = index - i0;

    return MoodFaceData.lerp(
      moodLibrary[i0],
      moodLibrary[i1],
      t,
    );
  }

  void _animateTo(double newTarget, {Duration? duration, Curve? curve}) {
    _targetIndex = newTarget;

    _motionAnimation = Tween<double>(
      begin: _index,
      end: _targetIndex,
    ).animate(
      CurvedAnimation(
        parent: _motionController,
        curve: curve ?? Curves.easeOut,
      ),
    );

    _motionController.duration = duration ?? const Duration(milliseconds: 140);

    _motionController
      ..stop()
      ..reset()
      ..forward();
  }

  Color adjustColor(Color color) {
    final hsl = HSLColor.fromColor(color);

    final adjusted = hsl.withSaturation(
      (hsl.saturation - 0.25).clamp(0.0, 1.0),
    ).withLightness(
      (hsl.lightness - 0.10).clamp(0.0, 1.0),
    );

    return adjusted.toColor();
  }

  @override
  void initState() {
    super.initState();

     _targetIndex = _index;

    _motionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _motionController.addListener(() {
      setState(() {
        _index = _motionAnimation!.value;
      });
    });
  }

  @override
  void dispose() {
    _motionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mood = _currentMood(_index);
    final darkerColor = adjustColor(mood.bgColor);
    return Scaffold(
      backgroundColor: mood.bgColor,
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: 100,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(100),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          iconSize: 30,
                          icon: const Icon(Icons.arrow_back),
                          color: Colors.black,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      )
                    ),
                  ],
                ),
              ),
            ),
        
            Column(
              children: [
                const SizedBox(height: 100,),

                Text(
                  "What's going on\ninside?",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                    height: 1.2, // helps prevent vertical clipping
                  ),
                ),
                // leaves space for the header (since it's stacked)

                const Spacer(flex: 2),

                MoodFace(data: mood, scalePercentage: 1,),

                const Spacer(flex: 2),

                Text(
                  mood.label,
                  style: const TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),

                const Spacer(flex: 2),

                _buildSlider(context, mood, darkerColor),

                const Spacer(flex: 1),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: Container(
                    height: 64,
                    decoration: BoxDecoration(
                      color: darkerColor,
                      borderRadius: BorderRadius.circular(28), // capsule
                    ),
                    child: Row(
                      children: [
                        /// TEXT AREA
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 28),
                            child: TextField(
                              controller: _controller,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              decoration: const InputDecoration(
                                hintText: "Add note",
                                hintStyle: TextStyle(color: Colors.white70),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                  
                        /// RIGHT BUTTON SEGMENT
                        GestureDetector(
                          onTap: () {
                            print(_controller.text);
                          },
                          child: Container(
                            width: 64,
                            height: double.infinity,
                            decoration: const BoxDecoration(
                              color: Color(0xFF2F343A), // dark segment
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(28),
                                bottomRight: Radius.circular(28),
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white
                              )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(flex: 1),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(BuildContext context, MoodFaceData mood, Color darkerColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _TickPainter(
                  tickCount: moodLibrary.length,
                  color: darkerColor,
                ),
              ),
            ),
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackShape: _TrackShape(color: darkerColor),

              activeTrackColor: Colors.transparent,
              inactiveTrackColor: Colors.transparent,

              overlayColor: Colors.transparent,
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),

              thumbShape: const _ThumbShape(radius: 12),

              showValueIndicator: ShowValueIndicator.never,
            ),
            child: Slider(
              value: _index * _step,
              min: min,
              max: max,
              onChanged: (value) {
                setState(() {
                  _targetIndex = (value / _step);
                  _index = _targetIndex;
                });
              },
              onChangeEnd: (value) {
                final snapped = (value / _step).roundToDouble();

                _animateTo(
                  snapped,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TickPainter extends CustomPainter {
  final int tickCount;
  final Color color;

  _TickPainter({
    required this.tickCount,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final spacing = size.width / (tickCount - 1);

    for (int i = 0; i < tickCount; i++) {
      final dx = spacing * i;
      final center = Offset(dx, size.height / 2);

      canvas.drawCircle(center, 7, paint); // your grey dots
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _TrackShape extends SliderTrackShape {
  final Color color;

  _TrackShape({
    required this.color,
  });

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
      ..color = color
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(rect.left, y),
      Offset(rect.right, y),
      paint,
    );
  }
}

class _ThumbShape extends SliderComponentShape {
  final double radius;

  const _ThumbShape({required this.radius});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    // 👇 THIS controls the touchable area (make it larger than the circle)
    return Size.fromRadius(radius + 10);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;

    final paint = Paint()
      ..color = const Color(0xFF2F343A)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, paint);
  }
}