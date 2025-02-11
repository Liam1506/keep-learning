import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:keep_learning/Data/Porviders/sessionProvider.dart';
import 'package:keep_learning/Data/Porviders/timerProvider.dart';
import 'package:provider/provider.dart';

bool isStarted = false;
double textSize = 80;
double textWidth = 47;

class Timer extends StatelessWidget {
  final String sessionKey;

  const Timer({super.key, required this.sessionKey});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TimerProvider>(
        builder: (context, timerProvider, child) {
          // Find the session by ID
          final session = Provider.of<SessionsProvider>(
            context,
          ).getSessionById(sessionKey);
          if (session == null) {
            return Center(child: Text('Session not found'));
          }

          // Format the remaining time into minutes:seconds
          String timeLeft = _formatDuration(session.timeLeftToday);

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!isStarted) {
              timerProvider.startTimer(context, session);
            }
            isStarted = true;
          });

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 80, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      session.habitName,
                      style: TextStyle(fontSize: 30),
                      textAlign: TextAlign.left,
                    ),
                    IconButton(
                      onPressed: () {
                        timerProvider.stopTimer();
                        context.go("/");
                      },
                      icon: Icon(Icons.close, size: 30, weight: 10),
                      // Optional: reduce padding around the button
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          timeLeft.split(":")[0].split('').map((char) {
                            return SizedBox(
                              width: textWidth,
                              child: Center(
                                child: Text(
                                  char,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: textSize,
                                    fontWeight: FontWeight.w100,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                    SizedBox(
                      width: 30,
                      child: Center(
                        child: Text(
                          ":",
                          style: const TextStyle(
                            fontSize: 100,
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          timeLeft.split(":")[1].split('').map((char) {
                            return SizedBox(
                              width: textWidth,
                              child: Center(
                                child: Text(
                                  char,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: textSize,
                                    fontWeight: FontWeight.w100,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                    SizedBox(
                      width: 30,
                      child: Center(
                        child: Text(
                          ":",
                          style: const TextStyle(
                            fontSize: 80,
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          timeLeft.split(":")[2].split('').map((char) {
                            return SizedBox(
                              width: textWidth,
                              child: Center(
                                child: Text(
                                  char,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: textSize,
                                    fontWeight: FontWeight.w100,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 40),
                child: Row(
                  children: [
                    /*Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // Stop the timer for the specific session
                          timerProvider.stopTimer();
                        },
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.red.withAlpha(75),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(Icons.stop, size: 60),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),*/
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // Start the timer for the specific session

                          if (timerProvider.isRunning) {
                            timerProvider.stopTimer();
                          } else {
                            timerProvider.startTimer(context, session);
                          }
                        },
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            color:
                                Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            timerProvider.isRunning
                                ? Icons.pause
                                : Icons.play_arrow,
                            size: 60,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Formats seconds into minutes:seconds
  String _formatDuration(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
