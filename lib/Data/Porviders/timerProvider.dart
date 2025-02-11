import 'dart:async';
import 'package:flutter/material.dart';
import 'package:keep_learning/Data/Porviders/sessionProvider.dart';
import 'package:keep_learning/Data/Storage/SessionStore.dart';
import 'package:keep_learning/Data/models/session_model.dart';
import 'package:provider/provider.dart';

class TimerProvider with ChangeNotifier, WidgetsBindingObserver {
  Timer? _timer;
  bool isRunning = false;
  Session? currentSession;

  TimerProvider() {
    // Register the lifecycle observer
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _timer?.cancel();
    // Unregister the lifecycle observer
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      print("TIMER STOP");
      // App is being paused or exited, stop the timer
      stopTimer();
    }
  }

  /// Start the timer for a specific session
  void startTimer(BuildContext context, Session session) {
    final sessionsProvider = Provider.of<SessionsProvider>(
      context,
      listen: false,
    );

    if (isRunning || session.timeLeftToday <= 0) return;

    isRunning = true;
    currentSession = session;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (currentSession == null) return;

      if (currentSession!.timeLeftToday > 0) {
        currentSession!.timeLeftToday -= 1;
        sessionsProvider.updateSession(
          sessionsProvider.sessions.indexOf(currentSession!),
          currentSession!,
        );

        if (currentSession!.timeLeftToday == 0) {
          print("SESSION FINISHED");
          var sessionStoreManager = SessionStore();
          sessionStoreManager.finishSession(currentSession!.sessionKey, true);
        }
      } else {
        stopTimer();
      }
    });

    notifyListeners();
  }

  /// Stop the timer
  void stopTimer() {
    _timer?.cancel();
    isRunning = false;
    notifyListeners();
  }

  /// Reset the timer for the current session
  void resetTimer(BuildContext context) {
    if (currentSession == null) return;

    stopTimer();
    final sessionsProvider = Provider.of<SessionsProvider>(
      context,
      listen: false,
    );
    //currentSession!.resetForNewDay();
    sessionsProvider.updateSession(
      sessionsProvider.sessions.indexOf(currentSession!),
      currentSession!,
    );
  }
}
