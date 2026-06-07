import 'package:flutter/material.dart';
import '../data/data.dart';
import '../data/entry.dart';
import '../services/mood_service_instance.dart';
import '../widgets/shared_widgets.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            _buildHeader(),
            const SizedBox(height: 24),
            _buildDateStrip(),
            const SizedBox(height: 24),
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
            const SizedBox(height: 32),
            if (_entries.length > 1) ...[
              _buildHistoryHeader(),
              const SizedBox(height: 12),
              ..._entries.where((e) =>
                  e.date.year != _selectedDate.year ||
                  e.date.month != _selectedDate.month ||
                  e.date.day != _selectedDate.day).map((entry) {
                final label = entry.mood >= 0 &&
                        entry.mood < moodLibrary.length
                    ? moodLibrary[entry.mood].label
                    : "Unknown";
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
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
              height: MediaQuery.of(context).padding.bottom + 100,
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
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Capture your thoughts",
          style: TextStyle(
            fontSize: 14,
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
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 14,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
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
              width: 48,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF2F343A) : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
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
                            fontSize: 10,
                            color: isSelected
                                ? Colors.white70
                                : Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${date.day}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (dotColor != null)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        width: 8,
                        height: 8,
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${_monthName(_selectedDate)} ${_selectedDate.day}, ${_selectedDate.year}",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "No entry for this day",
            style: TextStyle(
              fontSize: 14,
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
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    );
  }
}
