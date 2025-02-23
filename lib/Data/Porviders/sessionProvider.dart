import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:keep_learning/Data/Storage/SessionStore.dart';
import 'package:keep_learning/Data/models/session_model.dart';

class SessionsProvider with ChangeNotifier {
  List<Session> _sessions = [];

  // Box name for storing sessions
  final String _boxName = 'sessions';

  // Getter for all sessions
  List<Session> get sessions => _sessions;

  // Load all sessions from Hive

  Future<void> loadSessions() async {
    final box = await Hive.openBox<Session>(_boxName);
    _sessions =
        box.values
            .where(
              (session) => session.selectedDays.contains(getCurrentWeekday()),
            )
            .toList();

    _streak = await SessionStore().initToday(_sessions);

    notifyListeners();
  }

  resetStreak() {
    SessionStore().resetStreak();
    _streak = 0;
    notifyListeners();
  }

  Session getSessionById(String sessionKey) {
    Session session = _sessions.firstWhere(
      (session) => session.sessionKey == sessionKey,
      orElse:
          () => Session(
            habitName: "[Deleted Session]",
            durationInSeconds: 0,
            selectedDays: [],
            strictMode: false,
            joker: 0,
          ),
    );
    return session;
  }

  int _streak = 0;

  // Getter for all sessions
  int get streak => _streak;

  Future updateSessionStore() async {
    SessionStore().initToday(_sessions);
  }

  Future<Status> checkSessionsFinished() async {
    await loadSessions();
    print("SESSION FINISHED CHECK");
    bool finished = true;
    int tasksLeft = 0;
    int tasksFinished = _sessions.length;
    int timeLeftSeconds = 0;
    int timeTotal = 0;

    for (Session session in _sessions) {
      print("Habit: ${session.habitName}");

      print("Habit time left: ${session.timeLeftToday}");
      if (session.timeLeftToday != 0) {
        finished = false;
        tasksLeft++;
        tasksFinished--;
        timeLeftSeconds = timeLeftSeconds + session.timeLeftToday;
      }
      timeTotal = timeTotal + session.durationInSeconds;
    }

    SessionStore().initToday(_sessions);
    return Status(
      finished: finished,
      tasksLeft: tasksLeft,
      tasksFinished: tasksFinished,
      timeLeftSeconds: timeLeftSeconds,
      timeCompleted: timeTotal - timeLeftSeconds,
      timeTotal: timeTotal,
    );
  }

  // Add a new session
  Future<void> addSession(Session session) async {
    final box = await Hive.openBox<Session>(_boxName);
    await box.add(session); // Add to Hive box
    _sessions.add(session); // Add to local list
    notifyListeners();

    SessionStore().initToday(_sessions);
  }

  // Remove a session by index
  Future<void> removeSession(int index) async {
    final box = await Hive.openBox<Session>(_boxName);
    String? sessionId = box.getAt(index)!.sessionKey;
    await box.deleteAt(index); // Remove from Hive box
    _sessions.removeAt(index); // Remove from local list
    notifyListeners();
    var sessionStoreManager = SessionStore();
    sessionStoreManager.deleteSession(getCurrentDate(), sessionId);

    SessionStore().initToday(_sessions);
  }

  // Update a session by index
  Future<void> updateSession(int index, Session newSession) async {
    final box = await Hive.openBox<Session>(_boxName);
    await box.putAt(index, newSession); // Update in Hive box
    _sessions[index] = newSession; // Update in local list
    notifyListeners();
    /*
    SessionStore().initToday(_sessions);
    */
  }

  // Save sessions data (if needed)
  Future<void> saveSessions() async {
    final box = await Hive.openBox<Session>(_boxName);
    for (var session in _sessions) {
      await box.put(session.habitName, session); // Save each session
    }

    SessionStore().initToday(_sessions);
    notifyListeners();
  }
}

class Status {
  bool finished;
  int tasksLeft;
  int tasksFinished;
  int timeLeftSeconds;
  int timeCompleted;
  int timeTotal;

  Status({
    required this.finished,
    required this.tasksLeft,
    required this.tasksFinished,
    required this.timeLeftSeconds,
    required this.timeCompleted,
    required this.timeTotal,
  });

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      finished: json['finished'],
      tasksLeft: json['tasksLeft'],
      tasksFinished: json['tasksFinished'],
      timeLeftSeconds: json['timeLeftSeconds'],
      timeCompleted: json['timeCompleted'],
      timeTotal: json['timeTotal'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'finished': finished,
      'tasksLeft': tasksLeft,
      'tasksFinished': tasksFinished,
      'timeLeftSeconds': timeLeftSeconds,
      'timeCompleted': timeCompleted,
      'timeTotal': timeTotal,
    };
  }
}

int getCurrentWeekday() {
  int weekday = DateTime.now().weekday;
  return weekday - 1; // Convert Monday (1) to 0, Tuesday (2) to 1, etc.
}
