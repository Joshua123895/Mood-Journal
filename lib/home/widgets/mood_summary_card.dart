import 'package:flutter/material.dart';

import '../../../data/data.dart';

class MoodSummaryCard extends StatelessWidget {
  final MoodFaceData mood;

  const MoodSummaryCard({
    super.key,
    required this.mood,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: mood.bgColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Today's Mood",
            style: Theme.of(context).textTheme.labelLarge,
          ),

          const SizedBox(height: 8),

          Text(
            mood.label,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}