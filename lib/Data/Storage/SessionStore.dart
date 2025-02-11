import 'package:hive/hive.dart';
import 'package:keep_learning/Data/models/session_daily.dart';
import 'package:keep_learning/Data/models/session_store_data.dart';

class SessionStore {
  // Open the Hive box where sessions are stored
  Future<Box> _getBox() async {
    return await Hive.openBox('sessionsBox');
  }

  // Function to finish a session for today
  Future<void> finishSession(String sessionId, bool completed) async {
    final date = _getCurrentDate(); // Get today's date

    var box = await _getBox();
    SessionDaily? dailySessions = box.get(date);

    // If no sessions exist for today, create a new entry
    dailySessions ??= SessionDaily(date: date, sessions: []);

    // Add new session to the list
    dailySessions.sessions.add(
      SessionStoreData(sessionId: sessionId, completed: completed),
    );

    // Save or update the entry in Hive
    await box.put(date, dailySessions);
  }

  // Function to update a session for a given date and sessionId
  Future<void> updateSession(int date, String sessionId, bool completed) async {
    var box = await _getBox();
    SessionDaily? dailySessions = box.get(date);

    if (dailySessions != null) {
      // Find the session to update
      final sessionIndex = dailySessions.sessions.indexWhere(
        (session) => session.sessionId == sessionId,
      );

      if (sessionIndex != -1) {
        // Update the session
        dailySessions.sessions[sessionIndex] = SessionStoreData(
          sessionId: sessionId,
          completed: completed,
        );

        // Save the updated dailySessions back to Hive
        await box.put(date, dailySessions);
      }
    }
  }

  // Function to get sessions for a specific date
  Future<SessionDaily?> getSessionsForDate(int date) async {
    var box = await _getBox();
    return box.get(date);
  }

  // Function to get all sessions across all dates
  Future<List<SessionStoreData>> getAllSessions() async {
    var box = await _getBox();
    List<SessionStoreData> allSessions = [];

    // Iterate through all the entries in the box
    for (var key in box.keys) {
      SessionDaily? dailySessions = box.get(key);
      if (dailySessions != null) {
        allSessions.addAll(dailySessions.sessions);
      }
    }

    return allSessions;
  }

  // Function to delete a session for a given date and sessionId
  Future<void> deleteSession(int date, String sessionId) async {
    var box = await _getBox();
    SessionDaily? dailySessions = box.get(date);

    if (dailySessions != null) {
      // Find the session to delete
      final sessionIndex = dailySessions.sessions.indexWhere(
        (session) => session.sessionId == sessionId,
      );

      if (sessionIndex != -1) {
        // Remove the session
        dailySessions.sessions.removeAt(sessionIndex);

        // Save the updated dailySessions back to Hive
        await box.put(date, dailySessions);
      }
    }
  }

  // Helper function to get today's date as an integer (YYYYMMDD)
  int _getCurrentDate() {
    final now = DateTime.now();
    return int.parse(
      '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}',
    );
  }
}

// Function to get today's date as an integer (YYYYMMDD)
int getCurrentDate() {
  final now = DateTime.now();
  return int.parse(
    '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}',
  );
}
