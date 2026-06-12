import 'package:hive/hive.dart';

part 'reminder_entry.g.dart';

@HiveType(typeId: 1)
class ReminderEntry extends HiveObject {
  @HiveField(0)
  final String label;

  @HiveField(1)
  final int hour;

  @HiveField(2)
  final int minute;

  @HiveField(3)
  final String repeat; // "daily", "weekly", "custom"

  @HiveField(4)
  bool active;

  ReminderEntry({
    required this.label,
    required this.hour,
    required this.minute,
    required this.repeat,
    this.active = true,
  });
}
