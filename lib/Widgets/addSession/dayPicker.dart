import 'package:flutter/material.dart';

class DayPicker extends StatefulWidget {
  final Function(List<int>) onSelectionChanged; // Callback to notify parent
  const DayPicker({super.key, required this.onSelectionChanged});

  @override
  State<DayPicker> createState() => _DayPickerState();
}

class _DayPickerState extends State<DayPicker> {
  final List<int> _selectedDays = [0, 1, 2, 3, 4, 5, 6];
  final List<String> _weekDays = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color selectedColor = Theme.of(context).colorScheme.primary;
    final Color unselectedColor =
        Theme.of(context).colorScheme.surfaceContainerHigh;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              if (_selectedDays.contains(index)) {
                _selectedDays.remove(index);
              } else {
                _selectedDays.add(index);
              }
            });
            widget.onSelectionChanged(
              _selectedDays,
            ); // Notify parent about the selected days
          },
          child: CircleAvatar(
            backgroundColor:
                _selectedDays.contains(index) ? selectedColor : unselectedColor,
            child: Text(
              _weekDays[index],
              style: TextStyle(
                color:
                    _selectedDays.contains(index)
                        ? (isDarkMode ? Colors.black : Colors.white)
                        : (isDarkMode ? Colors.white : Colors.black),
              ),
            ),
          ),
        );
      }),
    );
  }
}
