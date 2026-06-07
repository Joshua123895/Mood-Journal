import 'dart:math';
import 'package:flutter/material.dart';
import '../data/entry.dart';
import '../data/data.dart';
import '../mood/face.dart';

class TransparentCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const TransparentCard({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: child,
    );
  }
}

class WeekMoodRow extends StatelessWidget {
  final List<MoodEntry?> weekMoods;
  final Color Function(int) moodColor;

  const WeekMoodRow({
    super.key,
    required this.weekMoods,
    required this.moodColor,
  });

  String _dayAbbr(DateTime date) {
    const weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return weekdays[date.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: weekMoods.asMap().entries.map((e) {
        final entry = e.value;
        final date = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day - (6 - e.key),
        );
        return Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: entry != null
                    ? moodColor(entry.mood)
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: entry != null && entry.mood >= 0 && entry.mood < moodLibrary.length
                  ? FittedBox(
                      fit: BoxFit.contain,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: MoodFace(data: moodLibrary[entry.mood]),
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 6),
            Text(
              _dayAbbr(date),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class JournalCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final int moodIndex;

  const JournalCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.moodIndex,
  });

  @override
  Widget build(BuildContext context) {
    final mood = moodIndex >= 0 && moodIndex < moodLibrary.length
        ? moodLibrary[moodIndex]
        : null;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          if (mood != null)
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: mood.bgColor,
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: MoodFace(data: mood),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class DashedBorderBox extends StatelessWidget {
  final Widget child;
  final double height;

  const DashedBorderBox({
    super.key,
    required this.child,
    this.height = 80,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(
        color: Colors.purple.withValues(alpha: 0.5),
        strokeWidth: 1.5,
        dashWidth: 6,
        dashGap: 4,
        radius: 20,
      ),
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: Colors.purple.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: child,
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashGap;
  final double radius;

  _DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashGap,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        strokeWidth / 2,
        strokeWidth / 2,
        size.width - strokeWidth,
        size.height - strokeWidth,
      ),
      Radius.circular(radius),
    );

    final path = Path()..addRRect(rrect);
    final metrics = path.computeMetrics();

    for (final metric in metrics) {
      double distance = 0;
      while (distance < metric.length) {
        final end = min(distance + dashWidth, metric.length);
        final segment = metric.extractPath(distance, end);
        canvas.drawPath(segment, paint);
        distance += dashWidth + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashGap != dashGap ||
        oldDelegate.radius != radius;
  }
}
