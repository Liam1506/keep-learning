import 'package:hive/hive.dart';
import 'session_store_data.dart'; // Import the renamed class

part 'session_daily.g.dart'; // for the generated code

@HiveType(typeId: 1)
class SessionDaily {
  @HiveField(0)
  final int date; // Store the date as an integer (e.g., timestamp or YYYYMMDD)

  @HiveField(1)
  final List<SessionStoreData> sessions;

  SessionDaily({required this.date, required this.sessions});
}
