import 'package:flutter/material.dart';
import '../../widgets/shared_widgets.dart';
import '../../theme/app_constants.dart';

class GoalCard extends StatelessWidget {
  final String name;
  final int current;
  final int total;

  const GoalCard({
    super.key,
    required this.name,
    required this.current,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return TransparentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: FontSizes.md,
              fontWeight: FontWeights.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: Insets.xs),
          Text(
            "$current/$total times a week",
            style: TextStyle(
              fontSize: FontSizes.sm,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: Insets.base),
          ClipRRect(
            borderRadius: BorderRadius.circular(Radii.xs),
            child: LinearProgressIndicator(
              value: current / total,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation(Colors.blue),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
