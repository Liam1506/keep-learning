import 'package:hive/hive.dart';

part 'session_model.g.dart'; // Make sure the name matches your actual file

@HiveType(typeId: 0)
class Session {
  @HiveField(0)
  String habitName;

  @HiveField(1)
  int durationInSeconds; // Store duration as seconds

  @HiveField(2)
  List<int> selectedDays;

  @HiveField(3)
  bool strictMode;

  @HiveField(4)
  int joker;

  Session({
    required this.habitName,
    required this.durationInSeconds,
    required this.selectedDays,
    required this.strictMode,
    required this.joker,
  });

  // When you access duration, it should be returned as a Duration object
  Duration get duration => Duration(seconds: durationInSeconds);

  // To store as seconds when converting to JSON
  Map<String, dynamic> toJson() {
    return {
      'habitName': habitName,
      'duration': durationInSeconds, // Store seconds
      'selectedDays': selectedDays.toList(),
      'strictMode': strictMode,
      'joker': joker,
    };
  }

  // When loading, parse duration as seconds
  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      habitName: json['habitName'],
      durationInSeconds: json['duration'], // Parse duration as seconds
      selectedDays: List<int>.from(json['selectedDays']),
      strictMode: json['strictMode'],
      joker: json['joker'],
    );
  }
}
