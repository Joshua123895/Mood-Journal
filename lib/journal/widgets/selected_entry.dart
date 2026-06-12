import 'package:flutter/material.dart';
import '../../data/entry.dart';
import '../../theme/app_constants.dart';
import '../../widgets/shared_widgets.dart';

class SelectedEntry extends StatelessWidget {
  final MoodEntry? selectedEntry;
  final String? selectedMoodLabel;
  final DateTime selectedDate;
  final String Function(DateTime) relativeDate;

  const SelectedEntry({
    super.key,
    this.selectedEntry,
    this.selectedMoodLabel,
    required this.selectedDate,
    required this.relativeDate,
  });

  String _monthName(DateTime date) {
    const months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return months[date.month - 1];
  }

  @override
  Widget build(BuildContext context) {
    if (selectedEntry != null) {
      return JournalCard(
        title: selectedEntry!.note?.isNotEmpty == true
            ? selectedEntry!.note!
            : "How I felt: $selectedMoodLabel",
        subtitle: relativeDate(selectedEntry!.date),
        moodIndex: selectedEntry!.mood,
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Insets.cardPaddingLarge),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(Radii.card),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${_monthName(selectedDate)} ${selectedDate.day}, ${selectedDate.year}",
            style: TextStyle(
              fontSize: FontSizes.md,
              fontWeight: FontWeights.semibold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: Insets.base),
          Text(
            "No entry for this day",
            style: TextStyle(
              fontSize: FontSizes.md,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}
