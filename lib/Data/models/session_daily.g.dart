// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_daily.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SessionDailyAdapter extends TypeAdapter<SessionDaily> {
  @override
  final int typeId = 1;

  @override
  SessionDaily read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SessionDaily(
      date: fields[0] as int,
      sessions: (fields[1] as List).cast<SessionStoreData>(),
      totalMiutesLearned: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SessionDaily obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.sessions)
      ..writeByte(2)
      ..write(obj.totalMiutesLearned);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionDailyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
