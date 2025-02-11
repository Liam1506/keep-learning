import 'dart:async';
import 'package:hive/hive.dart';
import 'package:keep_learning/Data/models/session_model.dart';

class SessionTimer {
  final Box sessionBox;
  final String sessionKey;
  Timer? _timer;
  late Session session;

  SessionTimer({required this.sessionBox, required this.sessionKey}) {
    session = sessionBox.get(sessionKey) as Session;
    session.checkAndResetTimeLeft();
    sessionBox.put(sessionKey, session); // Save updated session
  }

  void startTimer() {
    if (_timer != null && _timer!.isActive) return; // Prevent multiple timers

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (session.timeLeftToday > 0) {
        session.timeLeftToday -= 1;
        sessionBox.put(sessionKey, session);
      } else {
        stopTimer();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void resetTimer() {
    session.timeLeftToday = session.durationInSeconds;
    sessionBox.put(sessionKey, session);
  }
}
