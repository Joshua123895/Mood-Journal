import 'package:flutter/material.dart';
import '../../widgets/shared_widgets.dart';

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
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "$current/$total times a week",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
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
