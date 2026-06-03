import 'dart:math';
import 'package:flutter/material.dart';
import '../../data/data.dart';

class ThisMonthChart extends StatelessWidget {
  final Map<String, int> counts;

  const ThisMonthChart({super.key, required this.counts});

  @override
  Widget build(BuildContext context) {
    final total = counts.values.fold(0, (a, b) => a + b);

    return Row(
      children: [
        SizedBox(
          width: 120,
          height: 120,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(120, 120),
                painter: _DonutPainter(
                  counts: counts,
                  colors: moodLibrary.map((m) => m.bgColor).toList(),
                ),
              ),
              Text(
                "$total",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: moodLibrary.map((m) {
              final count = counts[m.label] ?? 0;
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: m.bgColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "${m.label}: $count",
                        style: TextStyle(
                          fontSize: 12,
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
