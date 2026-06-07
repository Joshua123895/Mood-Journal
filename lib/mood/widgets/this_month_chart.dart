import 'dart:math';
import 'package:flutter/material.dart';
import '../../data/data.dart';
import '../../theme/app_constants.dart';

class ThisMonthChart extends StatelessWidget {
  final Map<String, int> counts;

  const ThisMonthChart({super.key, required this.counts});

  @override
  Widget build(BuildContext context) {
    final total = counts.values.fold(0, (a, b) => a + b);

    return Row(
      children: [
        SizedBox(
          width: Sizes.donutChartSize,
          height: Sizes.donutChartSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(Sizes.donutChartSize, Sizes.donutChartSize),
                painter: _DonutPainter(
                  counts: counts,
                  colors: moodLibrary.map((m) => m.bgColor).toList(),
                ),
              ),
              Text(
                "$total",
                style: const TextStyle(
                  fontSize: FontSizes.title,
                  fontWeight: FontWeights.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: Insets.xl),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: moodLibrary.map((m) {
              final count = counts[m.label] ?? 0;
              return Padding(
                padding: const EdgeInsets.only(bottom: Insets.xs),
                child: Row(
                  children: [
                    Container(
                      width: Sizes.legendDot,
                      height: Sizes.legendDot,
                      decoration: BoxDecoration(
                        color: m.bgColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: Insets.sm),
                    Expanded(
                      child: Text(
                        "${m.label}: $count",
                        style: TextStyle(
                          fontSize: FontSizes.sm,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _DonutPainter extends CustomPainter {
  final Map<String, int> counts;
  final List<Color> colors;

  _DonutPainter({required this.counts, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final total = counts.values.fold(0.0, (a, b) => a + b);
    if (total == 0) return;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final strokeWidth = 20.0;
    double startAngle = -pi / 2;

    for (int i = 0; i < moodLibrary.length; i++) {
      final label = moodLibrary[i].label;
      final count = (counts[label] ?? 0).toDouble();
      if (count == 0) continue;

      final sweepAngle = (count / total) * 2 * pi;
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) => true;
}
