import 'package:hive/hive.dart';
import 'package:keep_learning/Data/Storage/DataStore.dart';
import 'package:uuid/uuid.dart';

part 'session_model.g.dart'; // Ensure this file is generated using Hive's build runner

@HiveType(typeId: 0)
class Session {
  @HiveField(0)
  String sessionKey; // Unique session identifier

  @HiveField(1)
  String habitName;

  @HiveField(2)
  int durationInSeconds; // Store duration as seconds

  @HiveField(3)
  List<int> selectedDays;

  @HiveField(4)
  bool strictMode;

  @HiveField(5)
  int joker;

  @HiveField(6)
  int totalSecondsLearned;

  @HiveField(7)
  int streak;

  @HiveField(8)
  int timeLeftToday;

  @HiveField(9)
  DateTime lastResetDate; // New field for tracking the last reset date

  Session({
    String? sessionKey, // Allow optional sessionKey
    required this.habitName,
    required this.durationInSeconds,
    required this.selectedDays,
    required this.strictMode,
    required this.joker,
    this.totalSecondsLearned = 0,
    this.streak = 0,
    this.timeLeftToday = 0,
    DateTime? lastResetDate,
  }) : sessionKey =
           sessionKey ?? const Uuid().v4(), // Generate UUID if not providedπ
       lastResetDate =
           lastResetDate ?? DateTime.now(); // Default to now if not set

  /// Returns the duration as a `Duration` object.
  Duration get duration => Duration(seconds: durationInSeconds);

  Duration get durationLeft => Duration(seconds: timeLeftToday);

  Duration get totalDuration => Duration(seconds: totalSecondsLearned);

  /// Checks if a new day has started and resets `timeLeftToday`.
  void checkAndResetTimeLeft() {

    DateTime now = DateTime.now();
    if (lastResetDate.day != now.day ||
        lastResetDate.month != now.month ||
        lastResetDate.year != now.year) {
      timeLeftToday = durationInSeconds; // Reset timeLeftToday
      lastResetDate = now; // Update last reset date
    }
  }

  /// Converts the session to a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return {
      'sessionKey': sessionKey,
      'habitName': habitName,
      'duration': durationInSeconds, // Store seconds
      'selectedDays': selectedDays.toList(),
      'strictMode': strictMode,
      'joker': joker,
      'totalSecondsLearned': totalSecondsLearned,
      'streak': streak,
      'timeLeftToday': timeLeftToday,
      'lastResetDate': lastResetDate.toIso8601String(), // Store as string
    };
  }

  /// Creates a session from a JSON map.
  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      sessionKey:
          json['sessionKey'] ?? const Uuid().v4(), // Ensure a key exists
      habitName: json['habitName'],
      durationInSeconds: json['duration'], // Parse duration as seconds
      selectedDays: List<int>.from(json['selectedDays']),
      strictMode: json['strictMode'],
      joker: json['joker'],
      totalSecondsLearned: json['totalSecondsLearned'] ?? 0,
      streak: json['streak'] ?? 0,
      timeLeftToday: json['timeLeftToday'] ?? 0,
      lastResetDate:
          json['lastResetDate'] != null
              ? DateTime.parse(json['lastResetDate'])
              : DateTime.now(), // Handle null case
    );
  }
}
