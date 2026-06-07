import 'package:flutter/material.dart';
import '../../theme/app_constants.dart';
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
        const SizedBox(height: Insets.md),
        const Text(
          "You are doing well today",
          style: TextStyle(
            fontSize: FontSizes.lg,
            fontWeight: FontWeights.semibold,
          ),
        ),
        const SizedBox(height: Insets.xs),
        Text(
          "Keep protecting your peace",
          style: TextStyle(
            fontSize: FontSizes.md,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }
}
