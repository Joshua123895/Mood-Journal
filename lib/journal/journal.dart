import 'package:flutter/material.dart';
import '../data/data.dart';
import '../data/entry.dart';
import '../services/mood_service_instance.dart';
import '../theme/app_constants.dart';
import 'widgets/journal_header.dart';
import 'widgets/date_strip.dart';
import 'widgets/selected_entry.dart';
import 'widgets/history_list.dart';

class JournalPage extends StatefulWidget {
  final ValueNotifier<DateTime?>? journalTargetDate;

  const JournalPage({super.key, this.journalTargetDate});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  List<MoodEntry> _entries = [];
  DateTime _selectedDate = DateTime.now();
  final ScrollController _dateStripController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadEntries();
    widget.journalTargetDate?.addListener(_onTargetDateChanged);
  }

  @override
  void dispose() {
    widget.journalTargetDate?.removeListener(_onTargetDateChanged);
    _dateStripController.dispose();
    super.dispose();
  }

  void _onTargetDateChanged() {
    final date = widget.journalTargetDate?.value;
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToDate(date);
      });
    }
  }

  void _scrollToDate(DateTime date) {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day - 13);
    final diff = DateTime(date.year, date.month, date.day)
        .difference(DateTime(start.year, start.month, start.day))
        .inDays;
    if (diff >= 0 && diff < 14) {
      final offset = diff * (Sizes.datePill + Insets.md);
      _dateStripController.animateTo(
        offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
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
            const JournalHeader(),
            const SizedBox(height: Insets.xl),
            DateStrip(
              selectedDate: _selectedDate,
              onDateSelected: (date) => setState(() => _selectedDate = date),
              entryForDate: _entryForDate,
              scrollController: _dateStripController,
            ),
            const SizedBox(height: Insets.xl),
            SelectedEntry(
              selectedEntry: selectedEntry,
              selectedMoodLabel: selectedMoodLabel,
              selectedDate: _selectedDate,
              relativeDate: _relativeDate,
            ),
            const SizedBox(height: Insets.xxl),
            if (_entries.length > 1)
              HistoryList(
                entries: _entries,
                selectedDate: _selectedDate,
                relativeDate: _relativeDate,
              ),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom + Sizes.bottomPadding,
            ),
          ],
        ),
      ),
    );
  }
}
