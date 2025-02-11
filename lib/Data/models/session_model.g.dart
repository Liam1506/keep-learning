// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SessionAdapter extends TypeAdapter<Session> {
  @override
  final int typeId = 0;

  @override
  Session read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Session(
      sessionKey: fields[0] as String?,
      habitName: fields[1] as String,
      durationInSeconds: fields[2] as int,
      selectedDays: (fields[3] as List).cast<int>(),
      strictMode: fields[4] as bool,
      joker: fields[5] as int,
      totalSecondsLearned: fields[6] as int,
      streak: fields[7] as int,
      timeLeftToday: fields[8] as int,
      lastResetDate: fields[9] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Session obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.sessionKey)
      ..writeByte(1)
      ..write(obj.habitName)
      ..writeByte(2)
      ..write(obj.durationInSeconds)
      ..writeByte(3)
      ..write(obj.selectedDays)
      ..writeByte(4)
      ..write(obj.strictMode)
      ..writeByte(5)
      ..write(obj.joker)
      ..writeByte(6)
      ..write(obj.totalSecondsLearned)
      ..writeByte(7)
      ..write(obj.streak)
      ..writeByte(8)
      ..write(obj.timeLeftToday)
      ..writeByte(9)
      ..write(obj.lastResetDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
