import 'package:flutter/material.dart';
import '../../theme/app_constants.dart';

class ActionCard extends StatelessWidget {
  final Color color;
  final String title;
  final String desc;

  const ActionCard({
    super.key, 
    required this.color,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Insets.cardPaddingLarge),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(Radii.card),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: FontSizes.xxl,
              fontWeight: FontWeights.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: Insets.sm),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
