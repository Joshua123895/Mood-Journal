part of 'goal_entry.dart';

class GoalEntryAdapter extends TypeAdapter<GoalEntry> {
  @override
  final int typeId = 2;

  @override
  GoalEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GoalEntry(
      name: fields[0] as String,
      targetPerWeek: fields[1] as int,
      createdAt: fields[2] as DateTime,
      completedDates: (fields[3] as List?)?.cast<DateTime>() ?? [],
      moodTarget: (fields[4] as int?) ?? 4,
    );
  }

  @override
  void write(BinaryWriter writer, GoalEntry obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.targetPerWeek)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.completedDates)
      ..writeByte(4)
      ..write(obj.moodTarget);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoalEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
