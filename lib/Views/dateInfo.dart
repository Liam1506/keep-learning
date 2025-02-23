import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:keep_learning/Data/Porviders/sessionProvider.dart';
import 'package:keep_learning/Data/Storage/SessionStore.dart';
import 'package:keep_learning/Data/models/session_daily.dart';
import 'package:keep_learning/Data/models/session_model.dart';
import 'package:keep_learning/Data/models/session_store_data.dart';
import 'package:provider/provider.dart';

class Dateinfo extends StatefulWidget {
  const Dateinfo({super.key, required this.dateInt});
  final int dateInt;

  @override
  State<Dateinfo> createState() => _DateinfoState();
}

DateTime date = DateTime.now();
String formattedDate = "";

class _DateinfoState extends State<Dateinfo> {
  @override
  void initState() {
    super.initState();
    date = DateTime.now().subtract(Duration(days: widget.dateInt));
    formattedDate = DateFormat.yMMMMd().format(date);
    print(date);
  }

  double calcMetrics(SessionDaily data) {
    print(data.sessions);
    int timeLearned = 0;
    int timeTotal = 0;
    for (SessionStoreData session in data.sessions) {
      timeTotal = timeTotal + session.timeTotal;

      timeLearned = timeLearned + session.timeLearned;
    }
    print(timeTotal);
    print(timeLearned);
    if (timeTotal == 0) {
      return 0;
    }
    return timeLearned / timeTotal;
  }

  @override
  Widget build(BuildContext context) {
    final sessionsProvider = Provider.of<SessionsProvider>(context);
    final Color unselectedColor =
        Theme.of(context).colorScheme.surfaceContainerHigh;
    return Scaffold(
      appBar: AppBar(
        title: Text(formattedDate.toString()),
        actions: [
          IconButton(
            onPressed: () {
              context.go("/");
            },
            icon: Icon(Icons.close, size: 30, weight: 10),
            // Optional: reduce padding around the button
          ),
        ],
      ),
      body: FutureBuilder(
        future: SessionStore().getSessionsForDate(getDateDiff(widget.dateInt)),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            SessionDaily sesionDay = snapshot.data!;

            return Column(
              children: [
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      Center(
                        child: SizedBox(
                          width: 200,
                          height: 200,
                          child: CircularProgressIndicator(
                            value: calcMetrics(sesionDay),
                            strokeWidth: 7,
                            backgroundColor: unselectedColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 200,
                        child: Center(
                          child: Text(
                            compactDuration(
                              Duration(seconds: sesionDay.totalMiutesLearned),
                            ),
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: sesionDay.sessions.length,
                    itemBuilder: (context, index) {
                      Session session = sessionsProvider.getSessionById(
                        sesionDay.sessions[index].sessionId,
                      );
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        child: ListTile(
                          leading: SizedBox(
                            child:
                                sesionDay.sessions[index].completed
                                    ? Icon(Icons.check)
                                    : Icon(Icons.close),
                          ),
                          title: Text(session.habitName),
                          subtitle: Text(
                            formatDurationText(
                              Duration(
                                seconds: sesionDay.sessions[index].timeLearned,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text("No data found"));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

String formatDurationText(Duration duration) {
  int hours = duration.inHours;
  int minutes = duration.inMinutes.remainder(60);
  int seconds = duration.inSeconds.remainder(60);

  List<String> parts = [];
  if (hours > 0) parts.add("$hours h");
  if (minutes > 0) parts.add("$minutes min");
  if (seconds > 0) parts.add("$seconds sec");

  return parts.join(" "); // Example: "2 h 5 min 30 sec"
}

String compactDuration(Duration duration) {
  int hours = duration.inHours;
  int minutes = duration.inMinutes.remainder(60);
  int seconds = duration.inSeconds.remainder(60);

  if (hours > 0) {
    return "$hours:${minutes.toString().padLeft(2, '0')}h"; // Example: "2:05h"
  } else if (minutes > 0) {
    return "$minutes:${seconds.toString().padLeft(2, '0')}m"; // Example: "5:30m"
  } else {
    return "${seconds}s"; // Example: "30s"
  }
}
