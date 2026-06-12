import 'package:flutter/material.dart';
import '../../data/data.dart';
import '../../data/entry.dart';
import '../../theme/app_constants.dart';
import '../../widgets/shared_widgets.dart';

class HistoryList extends StatelessWidget {
  final List<MoodEntry> entries;
  final DateTime selectedDate;
  final String Function(DateTime) relativeDate;

  const HistoryList({
    super.key,
    required this.entries,
    required this.selectedDate,
    required this.relativeDate,
  });

  @override
  Widget build(BuildContext context) {
    final filtered = entries.where((e) =>
        e.date.year != selectedDate.year ||
        e.date.month != selectedDate.month ||
        e.date.day != selectedDate.day).toList();

    if (filtered.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "History",
          style: TextStyle(
            fontSize: FontSizes.lg,
            fontWeight: FontWeights.semibold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: Insets.base),
        ...filtered.map((entry) {
          final label = entry.mood >= 0 && entry.mood < moodLibrary.length
              ? moodLibrary[entry.mood].label
              : "Unknown";
          return Padding(
            padding: const EdgeInsets.only(bottom: Insets.cardMarginBottom),
            child: JournalCard(
              title: entry.note?.isNotEmpty == true
                  ? entry.note!
                  : "How I felt: $label",
              subtitle: relativeDate(entry.date),
              moodIndex: entry.mood,
            ),
          );
        }),
      ],
    );
  }
}
