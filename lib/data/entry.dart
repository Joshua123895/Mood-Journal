// mood_entry.dart
import 'package:hive/hive.dart';

part 'entry.g.dart';  // This tells the generator where to write

@HiveType(typeId: 0)
class MoodEntry extends HiveObject {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final int mood;

  @HiveField(2)
  final String? note;

  @HiveField(3)
  final String? tag;

  MoodEntry({
    required this.date,
    required this.mood,
    this.note,
    this.tag,
  });
}