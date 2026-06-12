import 'package:flutter/material.dart';
import '../../data/data.dart';
import '../../data/entry.dart';
import '../../services/mood_service_instance.dart';
import '../../theme/app_constants.dart';
import '../face.dart';

class MoodPicker extends StatefulWidget {
  final ValueChanged<int>? onMoodSaved;

  const MoodPicker({super.key, this.onMoodSaved});

  @override
  State<MoodPicker> createState() => _MoodPickerState();
}

class _MoodPickerState extends State<MoodPicker>
    with SingleTickerProviderStateMixin {
  double _moodIndex = 4;
  final TextEditingController _noteController = TextEditingController();

  late AnimationController _motionController;
  Animation<double>? _motionAnimation;

  static const double _step = 10;
  int get divisions => moodLibrary.length - 1;
  double get min => 0;
  double get max => divisions * _step;

  @override
  void initState() {
    super.initState();
    _motionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _motionController.addListener(() {
      if (_motionAnimation != null) {
        setState(() {
          _moodIndex = _motionAnimation!.value;
        });
      }
    });
  }

  @override
  void dispose() {
    _motionController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  MoodFaceData _currentMood(double index) {
    final i0 = index.floor().clamp(0, moodLibrary.length - 1);
    final i1 = (i0 + 1).clamp(0, moodLibrary.length - 1);
    final t = index - i0;
    return MoodFaceData.lerp(moodLibrary[i0], moodLibrary[i1], t);
  }

  Color _adjustColor(Color color) {
    final hsl = HSLColor.fromColor(color);
    final adjusted = hsl.withSaturation(
      (hsl.saturation - 0.25).clamp(0.0, 1.0),
    ).withLightness(
      (hsl.lightness - 0.10).clamp(0.0, 1.0),
    );
    return adjusted.toColor();
  }

  Future<void> _saveMood() async {
    final roundedIndex = _moodIndex.round();
    final text = _noteController.text;
    final entry = MoodEntry(
      date: DateTime.now(),
      mood: roundedIndex,
      note: text.isNotEmpty ? text : null,
    );
    await moodService.saveMood(entry);
    if (!mounted) return;
    widget.onMoodSaved?.call(roundedIndex);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mood saved!'),
        duration: Duration(seconds: 2),
      ),
    );
    setState(() {
      _moodIndex = (moodLibrary.length / 2).floorToDouble();
      _noteController.clear();
    });
  }

  void _animateTo(double newTarget) {
    _motionAnimation = Tween<double>(
      begin: _moodIndex,
      end: newTarget,
    ).animate(CurvedAnimation(
      parent: _motionController,
      curve: Curves.easeOutCubic,
    ));
    _motionController
      ..stop()
      ..reset()
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    final mood = _currentMood(_moodIndex);
    final darkerColor = _adjustColor(mood.bgColor);

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 300),
      decoration: BoxDecoration(
        color: mood.bgColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(Radii.card),
        border: Border.all(color: mood.bgColor, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: Insets.lg),
          Transform.scale(
            scale: 0.8,
            child: MoodFace(data: mood),
          ),
          const SizedBox(height: Insets.base),
          Text(
            mood.label,
            style: const TextStyle(
              fontSize: FontSizes.xxl,
              fontWeight: FontWeights.semibold,
            ),
          ),
          const SizedBox(height: Insets.base),
          _buildSlider(darkerColor),
          const SizedBox(height: Insets.base),
          _buildNoteInput(),
          const SizedBox(height: Insets.lg),
        ],
      ),
    );
  }

  Widget _buildSlider(Color trackColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.pageHorizontal),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _TickPainter(
                  tickCount: moodLibrary.length,
                  color: trackColor,
                ),
              ),
            ),
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackShape: _TrackShape(color: trackColor),
              activeTrackColor: Colors.transparent,
              inactiveTrackColor: Colors.transparent,
              overlayColor: Colors.transparent,
              thumbShape: const _ThumbShape(radius: 12),
              showValueIndicator: ShowValueIndicator.never,
            ),
            child: Slider(
              value: _moodIndex * _step,
              min: min,
              max: max,
              onChanged: (value) {
                setState(() {
                  _moodIndex = value / _step;
                });
              },
              onChangeEnd: (value) {
                _animateTo((value / _step).roundToDouble());
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.pageHorizontal),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _noteController,
              decoration: InputDecoration(
                hintText: "Add a note...",
                hintStyle: TextStyle(color: Colors.grey.shade400),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Radii.pill),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.5),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: Insets.lg,
                  vertical: Insets.base,
                ),
              ),
            ),
          ),
          const SizedBox(width: Insets.md),
          Container(
            width: Sizes.moodFaceMedium,
            height: Sizes.moodFaceMedium,
            decoration: const BoxDecoration(
              color: AppColors.darkButton,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
              onPressed: _saveMood,
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
      canvas.drawCircle(center, 7, paint);
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
    final double trackHeight = 0;
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
      ..color = AppColors.darkButton
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, paint);
  }
}
