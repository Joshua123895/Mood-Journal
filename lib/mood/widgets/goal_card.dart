import 'package:flutter/material.dart';
import '../../data/goal_entry.dart';
import '../../widgets/shared_widgets.dart';
import '../../theme/app_constants.dart';

class GoalCard extends StatelessWidget {
  final GoalEntry goal;

  const GoalCard({super.key, required this.goal});

  int get _current {
    final now = DateTime.now();
    final startOfWeek = DateTime(now.year, now.month, now.day - now.weekday + 1);
    return goal.completedDates
        .where((d) => d.isAfter(startOfWeek.subtract(const Duration(days: 1))))
        .length;
  }

  bool get _isDone => _current >= goal.targetPerWeek;

  @override
  Widget build(BuildContext context) {
    final total = goal.targetPerWeek;

    return TransparentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  goal.name,
                  style: const TextStyle(
                    fontSize: FontSizes.md,
                    fontWeight: FontWeights.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              if (_isDone)
                const Icon(Icons.check_circle, color: Colors.green, size: 20),
            ],
          ),
          const SizedBox(height: Insets.xs),
          Text(
            "$_current/$total times a week",
            style: TextStyle(
              fontSize: FontSizes.sm,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: Insets.base),
          ClipRRect(
            borderRadius: BorderRadius.circular(Radii.xs),
            child: LinearProgressIndicator(
              value: total > 0 ? _current / total : 0,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation(
                  _isDone ? Colors.green : Colors.blue),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
