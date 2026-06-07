import 'package:flutter/material.dart';
import '../../theme/app_constants.dart';

class StreakCard extends StatelessWidget {
  final int streak;

  const StreakCard({super.key, required this.streak});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Insets.cardPaddingLarge),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(Radii.card),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Journal Streak",
            style: TextStyle(
              fontSize: FontSizes.md,
              fontWeight: FontWeights.semibold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: Insets.base),
          Row(
            children: [
              const Text(
                "\u{1F525}",
                style: TextStyle(fontSize: FontSizes.streakEmoji),
              ),
              const SizedBox(width: Insets.md),
              Text(
                "$streak",
                style: const TextStyle(
                  fontSize: FontSizes.streakNumber,
                  fontWeight: FontWeights.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: Insets.xs),
          Text(
            "Keep it going",
            style: TextStyle(
              fontSize: FontSizes.md,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
