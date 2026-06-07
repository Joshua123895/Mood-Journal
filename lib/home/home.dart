import 'dart:math';

import 'package:flutter/material.dart';

import 'widgets/mood_jar_section.dart';
import 'widgets/action_card.dart';
import 'widgets/stats_card.dart';
import 'widgets/greeting_header.dart';
import 'widgets/section_header.dart';
import 'widgets/streak_card.dart';
import 'widgets/mood_count_grid.dart';
import '../data/data.dart';
import '../data/entry.dart';
import '../services/mood_service_instance.dart';
import '../widgets/shared_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<MoodEntry> _moods = [];
  final Random _random = Random();
  late final List<String> _journalTitles;
  final List<Color> _gridColors = const [
    Color(0xFFB8DE70),
    Color(0xFF71A4FF),
    Color(0xFFFFB347),
    Color(0xFFFF6B6B),
    Color(0xFFA78BFA),
    Color(0xFFF472B6),
  ];

  @override
  void initState() {
    super.initState();
    _loadMoods();
    _initRandomData();
  }

  void _initRandomData() {
    _journalTitles = List.generate(3, (_) => _randomWords().join(' '));
  }

  Future<void> _loadMoods() async {
    final moods = moodService.getAllMoods();
    setState(() {
      _moods = moods;
    });
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  String _userName() {
    return "There";
  }

  int _calculateScore() {
    if (_moods.isEmpty) return 0;
    const scores = [20, 35, 25, 70, 85, 100];
    int total = 0;
    final recent = _moods.take(30).toList();
    for (final m in recent) {
      if (m.mood >= 0 && m.mood < scores.length) {
        total += scores[m.mood];
      }
    }
    return (total / recent.length).round();
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

  int _journalStreak() {
    if (_moods.isEmpty) return 0;
    final sorted = List<MoodEntry>.from(_moods)
      ..sort((a, b) => b.date.compareTo(a.date));
    int streak = 0;
    final today = DateTime.now();
    for (int i = 0; i < sorted.length; i++) {
      final expected = DateTime(today.year, today.month, today.day - streak);
      final entryDate = sorted[i].date;
      if (entryDate.year == expected.year &&
          entryDate.month == expected.month &&
          entryDate.day == expected.day) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  Color _moodColor(int moodIndex) {
    if (moodIndex >= 0 && moodIndex < moodLibrary.length) {
      return moodLibrary[moodIndex].bgColor;
    }
    return Colors.grey.shade200;
  }

  List<String> _randomWords() {
    const words = [
      'Sunny', 'Bright', 'Cloudy', 'Stormy', 'Peaceful', 'Quiet',
      'Gentle', 'Wild', 'Calm', 'Restless', 'Hopeful', 'Joyful',
      'Warm', 'Sweet', 'Fresh', 'Cozy', 'Breezy', 'Dreamy',
      'Vibrant', 'Serene', 'Bold', 'Mellow', 'Lively', 'Tranquil',
    ];
    final shuffled = List<String>.from(words)..shuffle(_random);
    return shuffled.take(3).toList();
  }

  String _relativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final entryDate = DateTime(date.year, date.month, date.day);
    final diff = today.difference(entryDate).inDays;
    if (diff == 0) return 'the day like today';
    if (diff == 1) return 'yesterday';
    return '$diff days ago';
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

  @override
  Widget build(BuildContext context) {
    final score = _calculateScore();
    final weekMoods = _thisWeekMoods();
    final streak = _journalStreak();
    final counts = _moodCounts();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GreetingHeader(
              greeting: "${_greeting()}, ${_userName()}",
              subtitle: "How are you feeling today?",
            ),
            const SizedBox(height: 32),
            Center(
              child: MoodJarSection(
                score: score,
                fillPercentage: score / 100,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              "Quick Actions",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ActionCard(
                    color: const Color(0xFFB8DE70),
                    title: "Rant",
                    desc: "Get something at\nyour chest",
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ActionCard(
                    color: const Color(0xFF71A4FF),
                    title: "Reflect",
                    desc: "Pause and think\nabout your day",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              "Mood Overview",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
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
            StreakCard(streak: streak),
            const SizedBox(height: 32),
            SectionHeader(title: "Recent Journal"),
            const SizedBox(height: 12),
            ...List.generate(3, (i) {
              final entry = i < _moods.length ? _moods[i] : null;
              return JournalCard(
                title: _journalTitles[i],
                subtitle: entry != null
                    ? _relativeDate(entry.date)
                    : "No entry yet",
                moodIndex: entry?.mood ?? 4,
              );
            }),
            const SizedBox(height: 32),
            const Text(
              "Tips for you",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Daily inspiration for a better you",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 16),
            const StatsCard(),
            const SizedBox(height: 32),
            SectionHeader(title: "Your Moods"),
            const SizedBox(height: 12),
            MoodCountGrid(
              counts: counts,
              gridColors: _gridColors,
            ),
            const SizedBox(height: 32),
            SectionHeader(title: "Reminders"),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
            ),
            const SizedBox(height: 12),
            const DashedBorderBox(
              child: Center(
                child: Text(
                  "+ Add reminder",
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
