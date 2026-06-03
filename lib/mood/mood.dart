import 'package:flutter/material.dart';
import '../data/data.dart';
import '../data/entry.dart';
import '../services/mood_service_instance.dart';
import '../widgets/shared_widgets.dart';
import 'widgets/mood_row.dart';
import 'widgets/mood_picker.dart';
import 'widgets/this_month_chart.dart';
import 'widgets/mood_insights_grid.dart';
import 'widgets/goal_card.dart';

class MoodPage extends StatefulWidget {
  const MoodPage({super.key});

  @override
  State<MoodPage> createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage> {
  List<MoodEntry> _moods = [];

  @override
  void initState() {
    super.initState();
    _loadMoods();
  }

  Future<void> _loadMoods() async {
    final moods = moodService.getAllMoods();
    setState(() {
      _moods = moods;
    });
  }

  Color _moodColor(int moodIndex) {
    if (moodIndex >= 0 && moodIndex < moodLibrary.length) {
      return moodLibrary[moodIndex].bgColor;
    }
    return Colors.grey.shade200;
  }

  List<MoodEntry?> _thisWeekMoods() {
    final today = DateTime.now();
    final List<MoodEntry?> week = [];
    for (int i = 6; i >= 0; i--) {
      final date = DateTime(today.year, today.month, today.day - i);
      final entry = _moods.cast<MoodEntry?>().firstWhere(
        (m) =>
            m!.date.year == date.year &&
            m.date.month == date.month &&
            m.date.day == date.day,
        orElse: () => null,
      );
      week.add(entry);
    }
    return week;
  }

  Map<String, int> _moodCounts() {
    final counts = <String, int>{};
    for (final mood in moodLibrary) {
      counts[mood.label] = 0;
    }
    for (final entry in _moods) {
      if (entry.mood >= 0 && entry.mood < moodLibrary.length) {
        counts[moodLibrary[entry.mood].label] =
            (counts[moodLibrary[entry.mood].label] ?? 0) + 1;
      }
    }
    return counts;
  }

  Map<String, int> _thisMonthMoodCounts() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final counts = <String, int>{};
    for (final mood in moodLibrary) {
      counts[mood.label] = 0;
    }
    for (final entry in _moods) {
      if (entry.date.isBefore(startOfMonth)) continue;
      if (entry.mood >= 0 && entry.mood < moodLibrary.length) {
        counts[moodLibrary[entry.mood].label] =
            (counts[moodLibrary[entry.mood].label] ?? 0) + 1;
      }
    }
    return counts;
  }

  String _mostCommonMood() {
    final counts = _moodCounts();
    if (counts.values.every((c) => c == 0)) return "None";
    return counts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  String _leastCommonMood() {
    final counts = _moodCounts();
    if (counts.values.every((c) => c == 0)) return "None";
    return counts.entries.reduce((a, b) => a.value < b.value ? a : b).key;
  }

  String _bestDay() {
    if (_moods.isEmpty) return "None";
    MoodEntry best = _moods.first;
    for (final entry in _moods) {
      if (entry.mood > best.mood) best = entry;
    }
    return moodLibrary[best.mood].label;
  }

  String _averageMoodLast7Days() {
    final week = _thisWeekMoods().whereType<MoodEntry>().toList();
    if (week.isEmpty) return "None";
    final avg = week.fold(0.0, (sum, e) => sum + e.mood) / week.length;
    final idx = avg.round().clamp(0, moodLibrary.length - 1);
    return moodLibrary[idx].label;
  }

  @override
  Widget build(BuildContext context) {
    final weekMoods = _thisWeekMoods();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            const Text(
              "How are you feeling?",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Track your emotions",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 24),
            const MoodRow(),
            const SizedBox(height: 24),
            const MoodPicker(),
            const SizedBox(height: 32),
            const Text(
              "Mood Overview",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            TransparentCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "This Week",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  WeekMoodRow(
                    weekMoods: weekMoods,
                    moodColor: _moodColor,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            TransparentCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "This Month",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ThisMonthChart(counts: _thisMonthMoodCounts()),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              "Mood Insights",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            MoodInsightsGrid(
              mostCommon: _mostCommonMood(),
              leastCommon: _leastCommonMood(),
              bestDay: _bestDay(),
              averageMood: _averageMoodLast7Days(),
            ),
            const SizedBox(height: 32),
            const Text(
              "Mood Goals",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Set your goal intentions",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 12),
            const GoalCard(
              name: "Stay Positive",
              current: 3,
              total: 7,
            ),
            const SizedBox(height: 12),
            const DashedBorderBox(
              child: Center(
                child: Text(
                  "+ Add New Goal",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.purple,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom + 100,
            ),
          ],
        ),
      ),
    );
  }
}
