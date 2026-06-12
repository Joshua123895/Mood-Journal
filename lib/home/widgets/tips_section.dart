import 'package:flutter/material.dart';
import '../../data/tips.dart';
import '../../theme/app_constants.dart';
import 'stats_card.dart';

class TipsSection extends StatelessWidget {
  const TipsSection({super.key});

  // just a bullshit example
  static final List<StatsCardVariation> _allVariations = [
    StatsCardVariationManager.getVariation('low'),
    StatsCardVariationManager.getVariation('neutral'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Tips for you",
          style: TextStyle(
            fontSize: FontSizes.title,
            fontWeight: FontWeights.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: Insets.xs),
        Text(
          "Daily inspiration for a better you",
          style: TextStyle(
            fontSize: FontSizes.md,
            color: Colors.grey.shade500,
          ),
        ),
        const SizedBox(height: Insets.lg),
        StatsCard(variations: _allVariations),
      ],
    );
  }
}
