import 'package:hive/hive.dart';

part 'session_store_data.g.dart'; // for the generated code

@HiveType(typeId: 2)
class SessionStoreData {
  @HiveField(0)
  final String sessionId;

  @HiveField(1)
  final bool completed;

  SessionStoreData({required this.sessionId, required this.completed});
}
