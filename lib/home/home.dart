import 'package:flutter/material.dart';

import 'widgets/mood_jar.dart';
import 'widgets/action_card.dart';
import '../data/data.dart';
import '../data/entry.dart';
import '../services/mood_service_instance.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  String _dayAbbr(DateTime date) {
    final weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return weekdays[date.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final score = _calculateScore();
    final weekMoods = _thisWeekMoods();
    final streak = _journalStreak();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text(
              "${_greeting()}, ${_userName()}",
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "How are you feeling today?",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: Column(
                children: [
                  MoodJar(
                    fillPercentage: score / 100,
                    moodScore: score,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "You are doing well today",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Keep protecting your peace",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
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
                    color: const Color(0xFFC8DE80),
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
            Container(
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
                    "This Week",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: weekMoods.asMap().entries.map((e) {
                      final entry = e.value;
                      final date = DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day - (6 - e.key),
                      );
                      return Column(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: entry != null
                                  ? _moodColor(entry.mood)
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _dayAbbr(date),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
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
                    "Journal Streak",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        "\u{1F525}",
                        style: TextStyle(fontSize: 28),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "$streak",
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Keep it going",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
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