import 'package:flutter/material.dart';
import '../data/data.dart';
import '../data/entry.dart';
import '../mood/face.dart';
import '../services/mood_service_instance.dart';
import '../theme/app_constants.dart';

class JournalPage extends StatefulWidget {
  final ValueNotifier<DateTime?>? journalTargetDate;
  const JournalPage({super.key, this.journalTargetDate});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  List<MoodEntry> _entries = [];

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    setState(() => _entries = moodService.getAllMoods());
  }

  List<MapEntry<String, List<MoodEntry>>> _grouped() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final order = <String>[];
    final map = <String, List<MoodEntry>>{};

    for (final e in _entries) {
      final diff =
          today.difference(DateTime(e.date.year, e.date.month, e.date.day)).inDays;
      final label = diff == 0
          ? 'Today'
          : diff == 1
              ? 'Yesterday'
              : diff < 7
                  ? '$diff days ago'
                  : 'This Week';
      if (!map.containsKey(label)) {
        order.add(label);
        map[label] = [];
      }
      map[label]!.add(e);
    }
    return order.map((k) => MapEntry(k, map[k]!)).toList();
  }

  int _streak() {
    if (_entries.isEmpty) return 0;
    final sorted = List<MoodEntry>.from(_entries)
      ..sort((a, b) => b.date.compareTo(a.date));
    final today = DateTime.now();
    final hasToday = sorted[0].date.year == today.year &&
        sorted[0].date.month == today.month &&
        sorted[0].date.day == today.day;
    if (!hasToday) {
      final yd = DateTime(today.year, today.month, today.day - 1);
      if (!sorted.any((e) =>
          e.date.year == yd.year &&
          e.date.month == yd.month &&
          e.date.day == yd.day)) return 0;
    }
    int start = hasToday ? 0 : 1, s = 0;
    for (final e in sorted) {
      final exp =
          DateTime(today.year, today.month, today.day - (start + s));
      if (e.date.year == exp.year &&
          e.date.month == exp.month &&
          e.date.day == exp.day) {
        s++;
      } else {
        break;
      }
    }
    return s;
  }

  String _time(DateTime d) {
    final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final m = d.minute.toString().padLeft(2, '0');
    return '$h:$m ${d.hour < 12 ? 'AM' : 'PM'}';
  }

  String _entryTime(DateTime d, String group) {
    if (group == 'This Week') {
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return '${days[d.weekday - 1]}, ${_time(d)}';
    }
    return _time(d);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    final monthStart = DateTime(now.year, now.month, 1);
    final thisWeek = _entries.where((e) => !e.date.isBefore(weekStart)).length;
    final thisMonth = _entries.where((e) => !e.date.isBefore(monthStart)).length;
    final grouped = _grouped();

    final moodCounts = List.filled(moodLibrary.length, 0);
    for (final e in _entries) {
      if (e.mood >= 0 && e.mood < moodLibrary.length) moodCounts[e.mood]++;
    }
    // Sad=0, Calm=1, Anxious=2, Stressed=3, Happy=4, Loved=5
    final catCounts = [
      _entries.length,
      moodCounts[1],
      moodCounts[4] + moodCounts[5],
      moodCounts[2] + moodCounts[3],
      moodCounts[0],
    ];

    return SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: Insets.pageHorizontal),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: Insets.xl),
                _header(),
                const SizedBox(height: Insets.xxl),
                if (grouped.isEmpty)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: Insets.xxl),
                    child: Center(
                      child: Text('No entries yet',
                          style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: FontSizes.md)),
                    ),
                  ),
                ...grouped.map((g) => _group(g.key, g.value)),
                const SizedBox(height: Insets.base),
                _stats(_entries.length, _streak(), thisWeek, thisMonth),
                const SizedBox(height: Insets.xxl),
                _prompts(),
                const SizedBox(height: Insets.xxl),
                _categories(catCounts),
                SizedBox(
                    height: MediaQuery.of(context).padding.bottom +
                        Sizes.bottomPadding),
              ],
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom +
                Sizes.bottomPadding -
                24,
            right: 0,
            child: FloatingActionButton(
              onPressed: _loadEntries,
              backgroundColor: const Color(0xFF6C9E6E),
              elevation: 4,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('My Journal',
            style: TextStyle(
                fontSize: FontSizes.title, fontWeight: FontWeights.bold)),
        const SizedBox(height: Insets.sm),
        Text('A safe space for your thoughts',
            style: TextStyle(
                fontSize: FontSizes.md, color: Colors.grey.shade500)),
        const SizedBox(height: Insets.lg),
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: Insets.lg, vertical: Insets.md),
            decoration: BoxDecoration(
              color: AppColors.actionRant,
              borderRadius: BorderRadius.circular(Radii.pill),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, color: Colors.white, size: 18),
                SizedBox(width: 4),
                Text('New Entry',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeights.semibold,
                        fontSize: FontSizes.md)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _group(String label, List<MoodEntry> entries) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: FontSizes.lg, fontWeight: FontWeights.semibold)),
        const SizedBox(height: Insets.base),
        ...entries.map((e) => _entryCard(e, label)),
        const SizedBox(height: Insets.lg),
      ],
    );
  }

  Widget _entryCard(MoodEntry entry, String group) {
    final mood = entry.mood >= 0 && entry.mood < moodLibrary.length
        ? moodLibrary[entry.mood]
        : null;
    final note = entry.note ?? '';
    final lines = note.split('\n');
    final title = lines.isNotEmpty && lines.first.trim().isNotEmpty
        ? lines.first.trim()
        : 'Journal Entry';
    final body = note.length > title.length
        ? note.substring(title.length).trim()
        : '';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: Insets.base),
      padding: const EdgeInsets.all(Insets.cardPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Radii.card),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: FontSizes.md,
                        fontWeight: FontWeights.semibold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(_entryTime(entry.date, group),
                    style: TextStyle(
                        fontSize: FontSizes.sm, color: Colors.grey.shade500)),
                if (body.isNotEmpty) ...[
                  const SizedBox(height: Insets.sm),
                  Text(body,
                      style: TextStyle(
                          fontSize: FontSizes.sm,
                          color: Colors.grey.shade500,
                          height: 1.4),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis),
                ],
              ],
            ),
          ),
          if (mood != null) ...[
            const SizedBox(width: Insets.base),
            Container(
              width: 40,
              height: 40,
              decoration:
                  BoxDecoration(color: mood.bgColor, shape: BoxShape.circle),
              child: ClipOval(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Padding(
                    padding: const EdgeInsets.all(Insets.lg),
                    child: MoodFace(data: mood),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _stats(int total, int streak, int thisWeek, int thisMonth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Journal Stats',
            style: TextStyle(
                fontSize: FontSizes.lg, fontWeight: FontWeights.semibold)),
        const SizedBox(height: Insets.xs),
        Text('Your journaling journey',
            style:
                TextStyle(fontSize: FontSizes.sm, color: Colors.grey.shade500)),
        const SizedBox(height: Insets.base),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(Radii.card),
          ),
          child: Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  children: [
                    _statCell(total.toString(), 'Total Entries'),
                    VerticalDivider(width: 1, color: Colors.grey.shade200),
                    _statCell(streak.toString(), 'Day Streak'),
                  ],
                ),
              ),
              Divider(height: 1, color: Colors.grey.shade200),
              IntrinsicHeight(
                child: Row(
                  children: [
                    _statCell(thisWeek.toString(), 'This Week'),
                    VerticalDivider(width: 1, color: Colors.grey.shade200),
                    _statCell(thisMonth.toString(), 'This Month'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statCell(String value, String label) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(Insets.cardPaddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value,
                style: const TextStyle(
                    fontSize: FontSizes.xxl, fontWeight: FontWeights.bold)),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(
                    fontSize: FontSizes.sm, color: Colors.grey.shade500)),
          ],
        ),
      ),
    );
  }

  static const _promptTexts = [
    'What made you smile today?',
    'What are you grateful for?',
    'What challenged you today?',
    'What do you want to achieve?',
  ];
  static const _promptColors = [
    Color(0xFFE8F5E9),
    Color(0xFFFCE4EC),
    Color(0xFFFFF9C4),
    Color(0xFFEDE7F6),
  ];

  Widget _prompts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Writing Prompts',
            style: TextStyle(
                fontSize: FontSizes.lg, fontWeight: FontWeights.semibold)),
        const SizedBox(height: Insets.xs),
        Text('Need inspiration?',
            style:
                TextStyle(fontSize: FontSizes.sm, color: Colors.grey.shade500)),
        const SizedBox(height: Insets.base),
        Row(children: [
          _promptCard(0),
          const SizedBox(width: Insets.base),
          _promptCard(1),
        ]),
        const SizedBox(height: Insets.base),
        Row(children: [
          _promptCard(2),
          const SizedBox(width: Insets.base),
          _promptCard(3),
        ]),
      ],
    );
  }

  Widget _promptCard(int i) {
    return Expanded(
      child: Container(
        height: 80,
        padding: const EdgeInsets.all(Insets.base),
        decoration: BoxDecoration(
          color: _promptColors[i],
          borderRadius: BorderRadius.circular(Radii.md),
        ),
        child: Stack(
          children: [
            Text(_promptTexts[i],
                style: const TextStyle(
                    fontSize: FontSizes.sm,
                    fontWeight: FontWeights.medium,
                    color: Colors.black87)),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                    color: Colors.white38, shape: BoxShape.circle),
                child: const Icon(Icons.arrow_forward,
                    size: 14, color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const _catNames = [
    'Daily Thoughts',
    'Goals & Dreams',
    'Gratitude',
    'Challenges',
    'Random Thoughts',
  ];
  static const _catColors = [
    Color(0xFF90CAF9),
    Color(0xFFA5D6A7),
    Color(0xFFFFCC80),
    Color(0xFFF48FB1),
    Color(0xFFB0BEC5),
  ];

  Widget _categories(List<int> counts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Categories',
            style: TextStyle(
                fontSize: FontSizes.lg, fontWeight: FontWeights.semibold)),
        const SizedBox(height: Insets.xs),
        Text('Organize your thoughts',
            style:
                TextStyle(fontSize: FontSizes.sm, color: Colors.grey.shade500)),
        const SizedBox(height: Insets.base),
        ...List.generate(
          _catNames.length,
          (i) => Padding(
            padding: const EdgeInsets.only(bottom: Insets.base),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                      color: _catColors[i], shape: BoxShape.circle),
                ),
                const SizedBox(width: Insets.base),
                Expanded(
                    child: Text(_catNames[i],
                        style: const TextStyle(fontSize: FontSizes.md))),
                Text(counts[i].toString(),
                    style: TextStyle(
                        fontSize: FontSizes.md,
                        color: Colors.grey.shade500)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
