import 'package:flutter/material.dart';
import '../../data/data.dart';
import '../../theme/app_constants.dart';

class MoodCountGrid extends StatelessWidget {
  final Map<String, int> counts;
  final List<Color> gridColors;

  const MoodCountGrid({
    super.key,
    required this.counts,
    required this.gridColors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(2, (row) {
        return Padding(
          padding: const EdgeInsets.only(bottom: Insets.base),
          child: Row(
            children: List.generate(3, (col) {
              final index = row * 3 + col;
              if (index >= moodLibrary.length) {
                return const SizedBox.shrink();
              }
              final mood = moodLibrary[index];
              final count = counts[mood.label] ?? 0;
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    left: col == 0 ? 0 : Insets.sm,
                    right: col == 2 ? 0 : Insets.sm,
                  ),
                  padding: const EdgeInsets.all(Insets.base),
                  decoration: BoxDecoration(
                    color: gridColors[index],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mood.label,
                        style: const TextStyle(
                          fontSize: FontSizes.md,
                          fontWeight: FontWeights.semibold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: Insets.xs),
                      Text(
                        "$count times",
                        style: TextStyle(
                          fontSize: FontSizes.sm,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }
}
