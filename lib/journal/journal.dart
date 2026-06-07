import 'package:flutter/material.dart';
import '../data/data.dart';
import '../data/entry.dart';
import '../services/mood_service_instance.dart';
import '../widgets/shared_widgets.dart';
import '../theme/app_constants.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  List<MoodEntry> _entries = [];
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _seedMockData();
    _loadEntries();
  }

  void _seedMockData() {
    if (moodService.getAllMoods().isNotEmpty) return;
    final now = DateTime.now();
    final samples = [
      (daysAgo: 0, mood: 4, note: "Had a great day! Finished the project ahead of schedule."),
      (daysAgo: 1, mood: 2, note: "Feeling a bit anxious about tomorrow's presentation."),
      (daysAgo: 2, mood: 1, note: "Enjoyed a quiet evening reading my favorite book."),
      (daysAgo: 3, mood: 3, note: "Too much work today, need a break."),
      (daysAgo: 4, mood: 5, note: "Spent time with family, feeling so loved."),
      (daysAgo: 5, mood: 0, note: "Missed my old friends today."),
    ];
    for (final s in samples) {
      final date = DateTime(now.year, now.month, now.day - s.daysAgo);
      moodService.saveMood(MoodEntry(date: date, mood: s.mood, note: s.note));
    }
  }

  Future<void> _loadEntries() async {
    final entries = moodService.getAllMoods();
    setState(() {
      _entries = entries;
    });
  }

  String _relativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final entryDate = DateTime(date.year, date.month, date.day);
    final diff = today.difference(entryDate).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return '$diff days ago';
  }

  MoodEntry? _entryForDate(DateTime date) {
    try {
      return _entries.firstWhere((e) =>
          e.date.year == date.year &&
          e.date.month == date.month &&
          e.date.day == date.day);
    } catch (_) {
      return null;
    }
  }

  String _dayAbbr(DateTime date) {
    const weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return weekdays[date.weekday - 1];
  }

  String _monthName(DateTime date) {
    const months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return months[date.month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final selectedEntry = _entryForDate(_selectedDate);
    final selectedMoodLabel = selectedEntry != null &&
            selectedEntry.mood >= 0 &&
            selectedEntry.mood < moodLibrary.length
        ? moodLibrary[selectedEntry.mood].label
        : null;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: Insets.pageHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Insets.xl),
            _buildHeader(),
            const SizedBox(height: Insets.xl),
            _buildDateStrip(),
            const SizedBox(height: Insets.xl),
            if (selectedEntry != null)
              JournalCard(
                title: selectedEntry.note?.isNotEmpty == true
                    ? selectedEntry.note!
                    : "How I felt: $selectedMoodLabel",
                subtitle: _relativeDate(selectedEntry.date),
                moodIndex: selectedEntry.mood,
              )
            else
              _buildNoEntryCard(),
            const SizedBox(height: Insets.xxl),
            if (_entries.length > 1) ...[
              _buildHistoryHeader(),
              const SizedBox(height: Insets.base),
              ..._entries.where((e) =>
                  e.date.year != _selectedDate.year ||
                  e.date.month != _selectedDate.month ||
                  e.date.day != _selectedDate.day).map((entry) {
                final label = entry.mood >= 0 &&
                        entry.mood < moodLibrary.length
                    ? moodLibrary[entry.mood].label
                    : "Unknown";
                return Padding(
                  padding: const EdgeInsets.only(bottom: Insets.cardMarginBottom),
                  child: JournalCard(
                    title: entry.note?.isNotEmpty == true
                        ? entry.note!
                        : "How I felt: $label",
                    subtitle: _relativeDate(entry.date),
                    moodIndex: entry.mood,
                  ),
                );
              }),
            ],
            SizedBox(
              height: MediaQuery.of(context).padding.bottom + Sizes.bottomPadding,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Journal",
          style: TextStyle(
            fontSize: FontSizes.title,
            fontWeight: FontWeights.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: Insets.sm),
        Text(
          "Capture your thoughts",
          style: TextStyle(
            fontSize: FontSizes.md,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }

  Widget _buildDateStrip() {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day - 13);

    return SizedBox(
      height: Sizes.dateStripHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 14,
        separatorBuilder: (_, _) => const SizedBox(width: Insets.md),
        itemBuilder: (context, i) {
          final date = DateTime(start.year, start.month, start.day + i);
          final isSelected = date.day == _selectedDate.day &&
              date.month == _selectedDate.month &&
              date.year == _selectedDate.year;

          final entry = _entryForDate(date);
          Color? dotColor;
          if (entry != null && entry.mood >= 0 && entry.mood < moodLibrary.length) {
            dotColor = moodLibrary[entry.mood].bgColor;
          }

          return GestureDetector(
            onTap: () => setState(() => _selectedDate = date),
            child: Container(
              width: Sizes.datePill,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.darkButton : Colors.transparent,
                borderRadius: BorderRadius.circular(Radii.md),
                border: !isSelected
                    ? Border.all(color: Colors.grey.shade300, width: 1)
                    : null,
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _dayAbbr(date),
                          style: TextStyle(
                            fontSize: FontSizes.xs,
                            color: isSelected
                                ? Colors.white70
                                : Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(height: Insets.xs),
                        Text(
                          "${date.day}",
                          style: TextStyle(
                            fontSize: FontSizes.lg,
                            fontWeight: FontWeights.bold,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (dotColor != null)
                    Positioned(
                      top: Insets.xs,
                      right: Insets.xs,
                      child: Container(
                        width: Sizes.dotIndicator,
                        height: Sizes.dotIndicator,
                        decoration: BoxDecoration(
                          color: dotColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNoEntryCard() {
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
            "${_monthName(_selectedDate)} ${_selectedDate.day}, ${_selectedDate.year}",
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

  Widget _buildHistoryHeader() {
    return const Text(
      "History",
      style: TextStyle(
        fontSize: FontSizes.lg,
        fontWeight: FontWeights.semibold,
        color: Colors.black,
      ),
    );
  }
}
