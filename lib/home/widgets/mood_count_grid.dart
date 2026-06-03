import 'package:flutter/material.dart';
import '../../data/data.dart';

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
          padding: const EdgeInsets.only(bottom: 12),
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
                    left: col == 0 ? 0 : 6,
                    right: col == 2 ? 0 : 6,
                  ),
                  padding: const EdgeInsets.all(12),
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
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "$count times",
                        style: TextStyle(
                          fontSize: 12,
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
