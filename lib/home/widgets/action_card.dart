import 'package:flutter/material.dart';
import '../../theme/app_constants.dart';

class ActionCard extends StatelessWidget {
  final Color color;
  final String title;
  final String desc;
  final VoidCallback? onTap;

  const ActionCard({
    super.key, 
    required this.color,
    required this.title,
    required this.desc,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Radii.card),
      child: Container(
        padding: const EdgeInsets.all(Insets.cardPaddingLarge),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(Radii.card),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
      ),
    );
  }
}
