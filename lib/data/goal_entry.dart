import 'package:hive/hive.dart';

part 'goal_entry.g.dart';

@HiveType(typeId: 2)
class GoalEntry extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final int targetPerWeek;

  @HiveField(2)
  final DateTime createdAt;

  @HiveField(3)
  final List<DateTime> completedDates;

  @HiveField(4)
  final int moodTarget;

  GoalEntry({
    required this.name,
    required this.targetPerWeek,
    required this.createdAt,
    required this.moodTarget,
    this.completedDates = const [],
  });
}
