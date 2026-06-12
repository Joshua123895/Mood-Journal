import 'package:flutter/material.dart';

import 'widgets/mood_jar_section.dart';
import 'widgets/greeting_header.dart';
import 'widgets/tips_section.dart';
import 'widgets/mood_overview_section.dart';
import 'widgets/recent_journal_section.dart';
import 'widgets/moods_section.dart';
import 'widgets/reminders_section.dart';
import 'widgets/action_card.dart';
import 'widgets/rant_page.dart';
import 'widgets/reflect_page.dart';
import '../data/data.dart';
import '../data/entry.dart';
import '../services/mood_service_instance.dart';
import '../theme/app_constants.dart';

class HomePage extends StatefulWidget {
	final void Function(DateTime date)? onNavigateToJournal;

	const HomePage({super.key, this.onNavigateToJournal});

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

	@override
	Widget build(BuildContext context) {
		final score = _moods.isEmpty
				? 0
				: (() {
						const scores = [20, 35, 25, 70, 85, 100];
						int total = 0;
						final recent = _moods.take(30).toList();
						for (final m in recent) {
							if (m.mood >= 0 && m.mood < scores.length) {
								total += scores[m.mood];
							}
						}
						return (total / recent.length).round();
					})();

		final weekMoods = () {
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
		}();

		final streak = _moods.isEmpty
				? 0
				: (() {
						final sorted = List<MoodEntry>.from(_moods)
							..sort((a, b) => b.date.compareTo(a.date));
						final today = DateTime.now();

						bool hasToday = sorted.isNotEmpty &&
								sorted[0].date.year == today.year &&
								sorted[0].date.month == today.month &&
								sorted[0].date.day == today.day;

						if (!hasToday) {
							final yesterday =
									DateTime(today.year, today.month, today.day - 1);
							bool hasYesterday = sorted.any((e) =>
									e.date.year == yesterday.year &&
									e.date.month == yesterday.month &&
									e.date.day == yesterday.day);
							if (!hasYesterday) return 0;
						}

						int startDay = hasToday ? 0 : 1;
						int s = 0;
						for (final entry in sorted) {
							final expected = DateTime(
									today.year, today.month, today.day - (startDay + s));
							if (entry.date.year == expected.year &&
									entry.date.month == expected.month &&
									entry.date.day == expected.day) {
								s++;
							} else {
								break;
							}
						}
						return s;
					})();

		Color moodColor(int moodIndex) {
			if (moodIndex >= 0 && moodIndex < moodLibrary.length) {
				return moodLibrary[moodIndex].bgColor;
			}
			return Colors.grey.shade200;
		}

		final counts = () {
			final c = <String, int>{};
			for (final mood in moodLibrary) {
				c[mood.label] = 0;
			}
			for (final entry in _moods) {
				if (entry.mood >= 0 && entry.mood < moodLibrary.length) {
					c[moodLibrary[entry.mood].label] =
							(c[moodLibrary[entry.mood].label] ?? 0) + 1;
				}
			}
			return c;
		}();

		final journalTitles = _moods
				.take(3)
				.map((entry) => entry.note ?? "No note")
				.toList();

		String relativeDate(DateTime date) {
			final now = DateTime.now();
			final today = DateTime(now.year, now.month, now.day);
			final entryDate = DateTime(date.year, date.month, date.day);
			final diff = today.difference(entryDate).inDays;
			if (diff == 0) return 'the day like today';
			if (diff == 1) return 'yesterday';
			return '$diff days ago';
		}

		const gridColors = [
			AppColors.moodGrid1,
			AppColors.moodGrid2,
			AppColors.moodGrid3,
			AppColors.moodGrid4,
			AppColors.moodGrid5,
			AppColors.moodGrid6,
		];

		return SafeArea(
			child: SingleChildScrollView(
				padding: const EdgeInsets.symmetric(horizontal: Insets.pageHorizontal),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						GreetingHeader(
							greeting: "${_greeting()}, ${_userName()} 👋",
							subtitle: "How are you feeling today?",
						),
						const SizedBox(height: Insets.xxl),
						Center(
							child: MoodJarSection(
								score: score,
								fillPercentage: score / 100,
							),
						),
						const SizedBox(height: Insets.xxl),
						// Quick Actions
						const Text(
							"Quick Actions",
							style: TextStyle(
								fontSize: FontSizes.lg,
								fontWeight: FontWeights.semibold,
							),
						),
						const SizedBox(height: Insets.base),
						Row(
							children: [
								Expanded(
									child: ActionCard(
										color: AppColors.actionRant,
										title: "Rant",
										desc: "Get something off your chest",
										onTap: () => Navigator.of(context).push(
											MaterialPageRoute(builder: (_) => const RantPage()),
										),
									),
								),
								const SizedBox(width: Insets.base),
								Expanded(
									child: ActionCard(
										color: AppColors.actionReflect,
										title: "Reflect",
										desc: "Pause and think about your day",
										onTap: () => Navigator.of(context).push(
											MaterialPageRoute(builder: (_) => const ReflectPage()),
										),
									),
								),
							],
						),
						const SizedBox(height: Insets.xxl),
						MoodOverviewSection(
							weekMoods: weekMoods,
							moodColor: moodColor,
							streak: streak,
						),
						const SizedBox(height: Insets.xxl),
						RecentJournalSection(
							moods: _moods,
							journalTitles: journalTitles,
							onSeeAll: (dt) => widget.onNavigateToJournal?.call(dt),
							relativeDate: relativeDate,
						),
						const SizedBox(height: Insets.xxl),
						const TipsSection(),
						const SizedBox(height: Insets.xxl),
						MoodsSection(
							counts: counts,
							gridColors: gridColors,
						),
						const SizedBox(height: Insets.xxl),
						const RemindersSection(),
						SizedBox(
							height:
									MediaQuery.of(context).padding.bottom + Sizes.bottomPadding,
						),
					],
				),
			),
		);
	}
}
