import 'package:hive/hive.dart';
import 'package:keep_learning/Data/models/session_daily.dart';
import 'package:keep_learning/Data/models/session_model.dart';
import 'package:keep_learning/Data/models/session_store_data.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SessionStore {
  // Open the Hive box where sessions are stored
  Future<Box> _getBox() async {
    return await Hive.openBox('sessionsBox');
  }

  Future<int> initToday(List<Session> sessions) async {
    print("Lenght Session ${sessions.length}");
    int time = 0;
    for (Session session in sessions) {
      time = time + (session.durationInSeconds - session.timeLeftToday);
    }
    await clearData(time);
    for (Session session in sessions) {
      /*print("==== SESSION DATA =====");
      print("Learned today $time");
      print(session.sessionKey);
      print(session.habitName);
      print(session.durationInSeconds - session.timeLeftToday);
      print(session.timeLeftToday);
      print((session.timeLeftToday == 0));
      print("=======================");
*/
      await updateSession(
        getCurrentDate(),
        session,
        (session.timeLeftToday == 0),
        autoAdd: true,
      );
    }
    int lastStreakResteDate = await getLastStreakResetDate();
    int streak = await getStreakLentgh(1, lastStreakResteDate) - 1;

    //print("Streak: $streak");
    return streak;
  }

  // Function to finish a session for today
  Future<void> finishSession(Session session, bool completed) async {
    final date = getCurrentDate(); // Get today's date

    var box = await _getBox();
    SessionDaily? dailySessions = box.get(date);

    // If no sessions exist for today, create a new entry
    dailySessions ??= SessionDaily(
      date: date,
      sessions: [],
      totalMiutesLearned: 0,
    );

    // Add new session to the list
    dailySessions.sessions.add(
      SessionStoreData(
        sessionId: session.sessionKey,
        completed: completed,
        timeLearned: session.durationInSeconds - session.timeLeftToday,
        timeTotal: session.durationInSeconds,
      ),
    );

    // Save or update the entry in Hive
    await box.put(date, dailySessions);
  }

  // Function to update a session for a given date and sessionId
  Future<void> updateSession(
    int date,
    Session session,
    bool completed, {
    bool autoAdd = false,
  }) async {
    var box = await _getBox();
    SessionDaily? dailySessions = box.get(date);

    if (dailySessions != null) {
      // Find the session to update
      final sessionIndex = dailySessions.sessions.indexWhere(
        (session) => session.sessionId == session.sessionId,
      );
      if (sessionIndex == -1 && autoAdd) {
        addSessionForDate(date, session, completed);
      }

      if (sessionIndex != -1) {
        // Update the session
        dailySessions.sessions[sessionIndex] = SessionStoreData(
          sessionId: session.sessionKey,
          completed: completed,
          timeLearned: session.durationInSeconds - session.timeLeftToday,
          timeTotal: session.durationInSeconds,
        );

        // Save the updated dailySessions back to Hive
        await box.put(date, dailySessions);
      }
    }
  }

  Future<int> getLastStreakResetDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('lastStreakResteDate') ?? -1;
  }

  Future resetStreak() async {
    saveLastResetDate(getCurrentDate() - 1);
  }

  Future<void> saveLastResetDate(int restedate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastStreakResteDate', restedate);
  }

  Future<int> getStreakLentgh(int dayDiff, int lastStreakResteDate) async {
    int dayInt = getDateDiff(dayDiff);
    if (dayInt == lastStreakResteDate) {
      return dayDiff;
    }
    SessionDaily? day = await getSessionsForDate(dayInt);
    print(dayDiff);
    if (day.sessions.isEmpty) {
      return dayDiff;
    }
    for (SessionStoreData data in day.sessions) {
      print("Completed ${data.completed}");

      print("Completed ${data.sessionId}");
      if (data.completed == false) {
        return dayDiff;
      }
    }
    return getStreakLentgh(dayDiff + 1, lastStreakResteDate);
  }

  // Function to get sessions for a specific date
  Future<SessionDaily> getSessionsForDate(int date) async {
    var box = await _getBox();
    SessionDaily sassionDaily =
        box.get(date) ??
        SessionDaily(date: date, sessions: [], totalMiutesLearned: 0);

    return sassionDaily;
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

  Future clearData(int time) async {
    var box = await _getBox();
    await box.put(
      getCurrentDate(),
      SessionDaily(
        date: getCurrentDate(),
        sessions: [],
        totalMiutesLearned: time,
      ),
    );
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

  // Function to add a session for a specific date
  Future<void> addSessionForDate(
    int date,
    Session session,
    bool completed,
  ) async {
    var box = await _getBox();

    // Check if sessions already exist for the given date
    SessionDaily? dailySessions = await getSessionsForDate(date);

    dailySessions ??= SessionDaily(
      date: date,
      sessions: [],
      totalMiutesLearned: 0,
    );

    // Add the new session to the list of sessions
    dailySessions.sessions.add(
      SessionStoreData(
        sessionId: session.sessionKey,
        completed: completed,
        timeLearned: session.durationInSeconds - session.timeLeftToday,
        timeTotal: session.durationInSeconds,
      ),
    );

    // Save the updated sessions back to Hive
    await box.put(date, dailySessions);
  }

  // Helper function to get today's date as an integer (YYYYMMDD)
}

// Function to get today's date as an integer (YYYYMMDD)

int getDateDiff(int diff) {
  final now = DateTime.now().subtract(Duration(days: diff));
  return int.parse(
    '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}',
  );
}

int getCurrentDate() {
  final now = DateTime.now();
  return int.parse(
    '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}',
  );
}
