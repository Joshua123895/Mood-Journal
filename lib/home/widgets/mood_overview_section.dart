import 'package:flutter/material.dart';
import '../../data/entry.dart';
import '../../theme/app_constants.dart';
import '../../widgets/shared_widgets.dart';
import 'streak_card.dart';

class MoodOverviewSection extends StatelessWidget {
  final List<MoodEntry?> weekMoods;
  final Color Function(int) moodColor;
  final int streak;

  const MoodOverviewSection({
    super.key,
    required this.weekMoods,
    required this.moodColor,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Mood Overview",
          style: TextStyle(
            fontSize: FontSizes.lg,
            fontWeight: FontWeights.semibold,
          ),
        ),
        const SizedBox(height: Insets.base),
        TransparentCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "This Week",
                style: TextStyle(
                  fontSize: FontSizes.md,
                  fontWeight: FontWeights.semibold,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: Insets.lg),
              WeekMoodRow(
                weekMoods: weekMoods,
                moodColor: moodColor,
              ),
            ],
          ),
        ),
        const SizedBox(height: Insets.base),
        StreakCard(streak: streak),
      ],
    );
  }
}
