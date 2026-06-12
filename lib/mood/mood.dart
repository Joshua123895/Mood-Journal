import 'package:flutter/material.dart';
import '../data/data.dart';
import '../data/entry.dart';
import '../data/goal_entry.dart';
import '../services/mood_service_instance.dart';
import '../widgets/shared_widgets.dart';
import '../theme/app_constants.dart';
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
  List<GoalEntry> _goals = [];

  @override
  void initState() {
    super.initState();
    _loadMoods();
    _loadGoals();
  }

  Future<void> _loadMoods() async {
    final moods = moodService.getAllMoods();
    setState(() {
      _moods = moods;
    });
  }

  Future<void> _loadGoals() async {
    final goals = moodService.getAllGoals();
    setState(() {
      _goals = goals;
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

  Future<void> _onMoodSaved(int moodIndex) async {
    final today = DateTime.now();
    final todayNorm = DateTime(today.year, today.month, today.day);

    for (final goal in _goals) {
      if (goal.moodTarget != moodIndex) continue;
      final alreadyCompleted = goal.completedDates.any(
        (d) =>
            d.year == todayNorm.year &&
            d.month == todayNorm.month &&
            d.day == todayNorm.day,
      );
      if (alreadyCompleted) continue;
      final updated = GoalEntry(
        name: goal.name,
        targetPerWeek: goal.targetPerWeek,
        createdAt: goal.createdAt,
        moodTarget: goal.moodTarget,
        completedDates: [...goal.completedDates, todayNorm],
      );
      await moodService.saveGoal(updated);
    }
    _loadMoods();
    _loadGoals();
  }

  static const List<Map<String, dynamic>> _goalOptions = [
    {'name': 'Be Happy', 'moodTarget': 4, 'icon': Icons.emoji_emotions},
    {'name': 'Feel Loved', 'moodTarget': 5, 'icon': Icons.favorite},
    {'name': 'Stay Calm', 'moodTarget': 1, 'icon': Icons.self_improvement},
    {'name': 'Find Peace', 'moodTarget': 1, 'icon': Icons.spa},
    {'name': 'Spread Joy', 'moodTarget': 4, 'icon': Icons.waving_hand},
    {'name': 'Embrace Love', 'moodTarget': 5, 'icon': Icons.favorite_border},
  ];

  Future<void> _showAddGoalDialog() async {
    int targetCount = 5;

    await showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              title: const Text('New Goal'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ..._goalOptions.map((opt) => ListTile(
                        leading: Icon(opt['icon'] as IconData,
                            color: Colors.purple),
                        title: Text(opt['name'] as String),
                        onTap: () async {
                          final goal = GoalEntry(
                            name: opt['name'] as String,
                            targetPerWeek: targetCount,
                            createdAt: DateTime.now(),
                            moodTarget: opt['moodTarget'] as int,
                          );
                          await moodService.saveGoal(goal);
                          _loadGoals();
                          if (!ctx.mounted) return;
                          Navigator.of(ctx).pop();
                        },
                      )),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Times per week: '),
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: targetCount > 1
                            ? () => setDialogState(() => targetCount--)
                            : null,
                      ),
                      Text(
                        '$targetCount',
                        style: const TextStyle(
                          fontSize: FontSizes.xl,
                          fontWeight: FontWeights.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: targetCount < 14
                            ? () => setDialogState(() => targetCount++)
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final weekMoods = _thisWeekMoods();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: Insets.pageHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Insets.xl),
            const Text(
              "How are you feeling?",
              style: TextStyle(
                fontSize: FontSizes.title,
                fontWeight: FontWeights.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: Insets.sm),
            Text(
              "Track your emotions",
              style: TextStyle(
                fontSize: FontSizes.lg,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: Insets.xl),
            const MoodRow(),
            const SizedBox(height: Insets.xl),
            MoodPicker(onMoodSaved: _onMoodSaved),
            const SizedBox(height: Insets.xxl),
            const Text(
              "Mood Overview",
              style: TextStyle(
                fontSize: FontSizes.lg,
                fontWeight: FontWeights.semibold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: Insets.base),
            TransparentCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "This Week",
                    style: TextStyle(
                      fontSize: FontSizes.md,
                      fontWeight: FontWeights.semibold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: Insets.lg),
                  WeekMoodRow(
                    weekMoods: weekMoods,
                    moodColor: _moodColor,
                  ),
                ],
              ),
            ),
            const SizedBox(height: Insets.base),
            TransparentCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "This Month",
                    style: TextStyle(
                      fontSize: FontSizes.md,
                      fontWeight: FontWeights.semibold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: Insets.lg),
                  ThisMonthChart(counts: _thisMonthMoodCounts()),
                ],
              ),
            ),
            const SizedBox(height: Insets.xxl),
            const Text(
              "Mood Insights",
              style: TextStyle(
                fontSize: FontSizes.lg,
                fontWeight: FontWeights.semibold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: Insets.base),
            MoodInsightsGrid(
              mostCommon: _mostCommonMood(),
              leastCommon: _leastCommonMood(),
              bestDay: _bestDay(),
              averageMood: _averageMoodLast7Days(),
            ),
            const SizedBox(height: Insets.xxl),
            const Text(
              "Mood Goals",
              style: TextStyle(
                fontSize: FontSizes.lg,
                fontWeight: FontWeights.semibold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: Insets.xs),
            Text(
              "Set your goal intentions",
              style: TextStyle(
                fontSize: FontSizes.md,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: Insets.base),
            if (_goals.isNotEmpty)
              ..._goals.map((goal) => Padding(
                    padding: const EdgeInsets.only(bottom: Insets.base),
                    child: GoalCard(goal: goal),
                  )),
            if (_goals.isEmpty)
              const SizedBox.shrink(),
            const SizedBox(height: Insets.base),
            GestureDetector(
              onTap: _showAddGoalDialog,
              child: const DashedBorderBox(
                child: Center(
                  child: Text(
                    "+ Add New Goal",
                    style: TextStyle(
                      fontSize: FontSizes.lg,
                      fontWeight: FontWeights.semibold,
                      color: Colors.purple,
                    ),
                  ),
                ),
              ),
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
