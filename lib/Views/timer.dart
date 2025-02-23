import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:keep_learning/Data/Porviders/sessionProvider.dart';
import 'package:keep_learning/Data/Porviders/timerProvider.dart';
import 'package:provider/provider.dart';

bool isStarted = false;
double textSize = 70;
double textWidth = 40;

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
              Stack(
                children: [
                  Center(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(
                        begin:
                            session.timeLeftToday / session.durationInSeconds,
                        end: session.timeLeftToday / session.durationInSeconds,
                      ),
                      duration: Duration(seconds: 1),
                      builder: (context, value, child) {
                        return Center(
                          child: SizedBox(
                            width: MediaQuery.sizeOf(context).width - 30,
                            height: MediaQuery.sizeOf(context).width - 30,
                            child: CircularProgressIndicator(
                              value: value,
                              strokeWidth: 7,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (session.timeLeftToday == 0)
                    TimerFinishedWidget()
                  else
                    TimeDisplayer(timeLeft: timeLeft),
                ],
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
                    if (session.timeLeftToday == 0)
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // Start the timer for the specific session
                            context.go("/");
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
                            child: Icon(Icons.home, size: 50),
                          ),
                        ),
                      )
                    else
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

class TimerFinishedWidget extends StatelessWidget {
  const TimerFinishedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 50),
          Icon(
            Icons.emoji_events, // Pokal-Icon für Erfolg
            size: 80,
          ),
          SizedBox(height: 20),
          Text(
            "Finished, good job!",
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            "Keep up the great work!",
            style: TextStyle(fontSize: 20, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

class TimeDisplayer extends StatelessWidget {
  const TimeDisplayer({super.key, required this.timeLeft});

  final String timeLeft;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).width - 30,
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Left part of the time (hours)
            Row(
              children:
                  timeLeft.split(":")[0].split('').map((char) {
                    return SizedBox(
                      width: textWidth, // Fixed width
                      child: Center(
                        child: Text(
                          char,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: textSize,
                            fontWeight:
                                FontWeight
                                    .w500, // Slightly bolder for readability
                            // You can adjust the color as needed
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),

            // Separator ":"
            SizedBox(
              width: 28,
              child: Center(
                child: Text(
                  ":",
                  style: TextStyle(
                    fontSize: textSize * 1.2, // Slightly larger colon
                    fontWeight: FontWeight.w500, // Bold colon
                  ),
                ),
              ),
            ),

            // Middle part of the time (minutes)
            Row(
              children:
                  timeLeft.split(":")[1].split('').map((char) {
                    return SizedBox(
                      width: textWidth, // Fixed width
                      child: Center(
                        child: Text(
                          char,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: textSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),

            // Separator ":"
            SizedBox(
              width: 28,
              child: Center(
                child: Text(
                  ":",
                  style: TextStyle(
                    fontSize: textSize * 1.2, // Slightly larger colon
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            // Right part of the time (seconds)
            Row(
              children:
                  timeLeft.split(":")[2].split('').map((char) {
                    return SizedBox(
                      width: textWidth, // Fixed width
                      child: Center(
                        child: Text(
                          char,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: textSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
