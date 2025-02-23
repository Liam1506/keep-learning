import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:keep_learning/Data/Storage/saveSession.dart';
import 'package:keep_learning/Data/models/session_model.dart';

import 'package:keep_learning/Widgets/addSession/dayPicker.dart';

class AddSession extends StatefulWidget {
  const AddSession({super.key});

  @override
  State<AddSession> createState() => _AddSessionState();
}

class _AddSessionState extends State<AddSession> {
  final TextEditingController _habitNameController = TextEditingController();
  Duration _selectedDuration = const Duration(hours: 1, minutes: 0);
  List<int> _selectedDays = [0, 1, 2, 3, 4, 5, 6];
  bool _strictMode = false;
  final int _joker = 0;

  void _onSelectionChanged(List<int> selectedDays) {
    setState(() {
      _selectedDays = selectedDays;
    });
  }

  void _createSession() {
    final session = Session(
      habitName: _habitNameController.text,
      durationInSeconds: _selectedDuration.inSeconds,
      selectedDays: _selectedDays,
      strictMode: _strictMode,
      joker: _joker,
      timeLeftToday: _selectedDuration.inSeconds,
    );
    saveSession(session);

    print("Session Created: ${session.toJson()}");
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Habit"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _habitNameController,
                  decoration: const InputDecoration(
                    labelText: 'Habit Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                CupertinoTimerPicker(
                  mode: CupertinoTimerPickerMode.hm,
                  initialTimerDuration: _selectedDuration,
                  onTimerDurationChanged: (Duration newDuration) {
                    setState(() {
                      _selectedDuration = newDuration;
                    });
                  },
                ),
                const SizedBox(height: 20),
                DayPicker(onSelectionChanged: _onSelectionChanged),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Strict Mode'),
                        Switch(
                          value: _strictMode,
                          onChanged: (bool value) {
                            setState(() {
                              _strictMode = value; // Toggle strict mode
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                /*
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Joker'),

                      _strictMode
                          ? SizedBox(
                            width: 50,
                            height: 50,
                            child: Center(
                              child: Text("0", style: TextStyle(fontSize: 15)),
                            ),
                          )
                          : SizedBox(
                            width: 50,
                            height: 50,
                            child: DropdownButtonFormField<int>(
                              value: _strictMode ? 0 : _joker,
                              items:
                                  List.generate(
                                        _selectedDays.length,
                                        (index) => index,
                                      ) // Numbers 0-7
                                      .map(
                                        (number) => DropdownMenuItem(
                                          value: number,
                                          child: Text(
                                            number.toString(),
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),
                                      )
                                      .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _joker = value ?? 0;
                                });
                              },
                            ),
                          ),
                    ],
                  ),
                ),*/
                if (_strictMode)
                  Text(
                    "When Strict Mode is enabled, exiting the app or stopping the timer will result in a 5-minute penalty, keeping you disciplined and focused.",
                    style: TextStyle(color: Colors.red),
                  ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _createSession,
                child: const Text("Add"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
