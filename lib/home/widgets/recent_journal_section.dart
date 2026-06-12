import 'package:flutter/material.dart';
import '../../data/entry.dart';
import '../../theme/app_constants.dart';
import '../../widgets/shared_widgets.dart';
import 'section_header.dart';

class RecentJournalSection extends StatelessWidget {
  final List<MoodEntry> moods;
  final List<String> journalTitles;
  final void Function(DateTime)? onSeeAll;
  final String Function(DateTime) relativeDate;

  const RecentJournalSection({
    super.key,
    required this.moods,
    required this.journalTitles,
    this.onSeeAll,
    required this.relativeDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: "Recent Journal",
          actionLabel: "See all",
          onAction: () => onSeeAll?.call(DateTime.now()),
        ),
        const SizedBox(height: Insets.base),
        if (moods.isNotEmpty)
          ...List.generate(moods.length.clamp(0, 3), (i) {
            final entry = moods[i];
            return JournalCard(
              title: journalTitles.length > i ? journalTitles[i] : "No note",
              subtitle: relativeDate(entry.date),
              moodIndex: entry.mood,
            );
          }),
        if (moods.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: Insets.xl),
            child: Center(
              child: Text(
                "No journal entries yet",
                style: TextStyle(
                  fontSize: FontSizes.md,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
