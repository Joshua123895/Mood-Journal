part of 'reminder_entry.dart';

class ReminderEntryAdapter extends TypeAdapter<ReminderEntry> {
  @override
  final int typeId = 1;

  @override
  ReminderEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReminderEntry(
      label: fields[0] as String,
      hour: fields[1] as int,
      minute: fields[2] as int,
      repeat: fields[3] as String,
      active: fields[4] as bool? ?? true,
    );
  }

  @override
  void write(BinaryWriter writer, ReminderEntry obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.label)
      ..writeByte(1)
      ..write(obj.hour)
      ..writeByte(2)
      ..write(obj.minute)
      ..writeByte(3)
      ..write(obj.repeat)
      ..writeByte(4)
      ..write(obj.active);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
