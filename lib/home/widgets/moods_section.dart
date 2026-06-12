import 'package:flutter/material.dart';
import '../../theme/app_constants.dart';
import 'mood_count_grid.dart';
import 'section_header.dart';

class MoodsSection extends StatelessWidget {
  final Map<String, int> counts;
  final List<Color> gridColors;

  const MoodsSection({
    super.key,
    required this.counts,
    required this.gridColors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: "Your Moods"),
        const SizedBox(height: Insets.base),
        MoodCountGrid(
          counts: counts,
          gridColors: gridColors,
        ),
      ],
    );
  }
}
