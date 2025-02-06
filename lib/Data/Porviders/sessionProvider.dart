import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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
    _sessions = box.values.toList();
    notifyListeners();
  }

  // Add a new session
  Future<void> addSession(Session session) async {
    final box = await Hive.openBox<Session>(_boxName);
    await box.add(session); // Add to Hive box
    _sessions.add(session); // Add to local list
    notifyListeners();
  }

  // Remove a session by index
  Future<void> removeSession(int index) async {
    final box = await Hive.openBox<Session>(_boxName);
    await box.deleteAt(index); // Remove from Hive box
    _sessions.removeAt(index); // Remove from local list
    notifyListeners();
  }

  // Update a session by index
  Future<void> updateSession(int index, Session newSession) async {
    final box = await Hive.openBox<Session>(_boxName);
    await box.putAt(index, newSession); // Update in Hive box
    _sessions[index] = newSession; // Update in local list
    notifyListeners();
  }

  // Save sessions data (if needed)
  Future<void> saveSessions() async {
    final box = await Hive.openBox<Session>(_boxName);
    for (var session in _sessions) {
      await box.put(session.habitName, session); // Save each session
    }
    notifyListeners();
  }
}
