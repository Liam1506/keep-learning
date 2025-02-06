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
      habitName: fields[0] as String,
      durationInSeconds: fields[1] as int,
      selectedDays: (fields[2] as List).cast<int>(),
      strictMode: fields[3] as bool,
      joker: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Session obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.habitName)
      ..writeByte(1)
      ..write(obj.durationInSeconds)
      ..writeByte(2)
      ..write(obj.selectedDays)
      ..writeByte(3)
      ..write(obj.strictMode)
      ..writeByte(4)
      ..write(obj.joker);
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
