// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_store_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SessionStoreDataAdapter extends TypeAdapter<SessionStoreData> {
  @override
  final int typeId = 2;

  @override
  SessionStoreData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SessionStoreData(
      sessionId: fields[0] as String,
      completed: fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SessionStoreData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.sessionId)
      ..writeByte(1)
      ..write(obj.completed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionStoreDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
