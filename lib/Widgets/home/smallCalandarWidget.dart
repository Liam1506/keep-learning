import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:keep_learning/Data/Porviders/sessionProvider.dart';
import 'package:keep_learning/Data/Storage/SessionStore.dart';
import 'package:keep_learning/Data/models/session_daily.dart';
import 'package:keep_learning/Data/models/session_store_data.dart';
import 'package:provider/provider.dart';

class SmallCalendar extends StatefulWidget {
  const SmallCalendar({super.key});

  @override
  State<SmallCalendar> createState() => _SmallCalenderState();
}

class _SmallCalenderState extends State<SmallCalendar> {
  @override
  void initState() {
    super.initState();
    loadForDay(0);
  }

  Future<double> loadForDay(int diff) async {
    SessionDaily? data = await SessionStore().getSessionsForDate(
      getCurrentDate() - diff,
    );
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

  final List<String> _weekDays = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

  @override
  Widget build(BuildContext context) {
    final int todayIndex = DateTime.now().weekday - 1;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color selectedColor = Theme.of(context).colorScheme.primary;
    final Color unselectedColor =
        Theme.of(context).colorScheme.surfaceContainerHigh;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (index) {
            return GestureDetector(
              onTap: () {
                if (todayIndex != index && index < todayIndex) {
                  context.go("/dateInfo?dateInt=${todayIndex - index}");
                }
              },
              child: CircleAvatar(
                backgroundColor:
                    todayIndex == index ? selectedColor : unselectedColor,
                child: Stack(
                  children: [
                    if (todayIndex != index && index < todayIndex)
                      Center(
                        child: FutureBuilder<double>(
                          future: loadForDay(todayIndex - index),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator(); // Ladeindikator während des Wartens
                            } else if (snapshot.hasData) {
                              return CircularProgressIndicator(
                                value: snapshot.data,
                                color:
                                    todayIndex == index
                                        ? unselectedColor
                                        : selectedColor,
                              );
                            } else {
                              print("Test");
                              return SizedBox(); // Fallback, falls keine Daten vorhanden sind
                            }
                          },
                        ),
                      ),
                    Center(
                      child: Text(
                        _weekDays[index],
                        style: TextStyle(
                          color:
                              todayIndex == index
                                  ? (isDarkMode ? Colors.black : Colors.white)
                                  : (isDarkMode ? Colors.white : Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),

        SizedBox(height: 15),
        FutureBuilder<double>(
          future: loadForDay(0),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Ladeindikator während des Wartens
            } else if (snapshot.hasData) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    LinearProgressIndicator(
                      backgroundColor: unselectedColor,
                      minHeight: 40,
                      value: snapshot.data,
                      borderRadius: BorderRadius.circular(10),
                    ),

                    Container(
                      decoration: BoxDecoration(
                        color: unselectedColor,

                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text(
                          " ${(snapshot.data! * 100).round()}% ",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              print("Test");
              return SizedBox(); // Fallback, falls keine Daten vorhanden sind
            }
          },
        ),
      ],
    );
  }
}
