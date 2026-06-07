import 'package:flutter/material.dart';
import '../../data/data.dart';
import '../../theme/app_constants.dart';
import '../face.dart';

class MoodInsightsGrid extends StatelessWidget {
  final String mostCommon;
  final String leastCommon;
  final String bestDay;
  final String averageMood;

  const MoodInsightsGrid({
    super.key,
    required this.mostCommon,
    required this.leastCommon,
    required this.bestDay,
    required this.averageMood,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _InsightCard(
                title: "Most Common",
                value: mostCommon,
              ),
            ),
            const SizedBox(width: Insets.base),
            Expanded(
              child: _InsightCard(
                title: "Least Common",
                value: leastCommon,
              ),
            ),
          ],
        ),
        const SizedBox(height: Insets.base),
        Row(
          children: [
            Expanded(
              child: _InsightCard(
                title: "Best Day",
                value: bestDay,
              ),
            ),
            const SizedBox(width: Insets.base),
            Expanded(
              child: _InsightCard(
                title: "Average Mood",
                value: averageMood,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InsightCard extends StatelessWidget {
  final String title;
  final String value;

  const _InsightCard({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final moodIndex = moodLibrary.indexWhere((m) => m.label == value);
    final hasMood = moodIndex >= 0;

    return Container(
      padding: const EdgeInsets.all(Insets.cardPadding),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(Radii.card),
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
                  style: TextStyle(
                    fontSize: FontSizes.sm,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: Insets.xs),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: FontSizes.lg,
                    fontWeight: FontWeights.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          if (hasMood)
            Container(
              width: Sizes.moodFaceSmall,
              height: Sizes.moodFaceSmall,
              decoration: BoxDecoration(
                color: moodLibrary[moodIndex].bgColor,
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Padding(
                    padding: const EdgeInsets.all(Insets.lg),
                    child: MoodFace(data: moodLibrary[moodIndex]),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
