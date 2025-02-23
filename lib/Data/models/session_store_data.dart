import 'package:hive/hive.dart';

part 'session_store_data.g.dart'; // for the generated code

@HiveType(typeId: 2)
class SessionStoreData {
  @HiveField(0)
  final String sessionId;

  @HiveField(1)
  final bool completed;

  @HiveField(2)
  int timeLearned;

  @HiveField(3)
  int timeTotal;

  SessionStoreData({
    required this.sessionId,
    required this.completed,
    required this.timeLearned,
    required this.timeTotal,
  });
}
