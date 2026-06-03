import 'package:flutter/material.dart';
import 'mood_jar.dart';

class MoodJarSection extends StatelessWidget {
  final int score;
  final double fillPercentage;

  const MoodJarSection({
    super.key,
    required this.score,
    required this.fillPercentage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MoodJar(
          fillPercentage: fillPercentage,
          moodScore: score,
        ),
        const SizedBox(height: 8),
        const Text(
          "You are doing well today",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Keep protecting your peace",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }
}
