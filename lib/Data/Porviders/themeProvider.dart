import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  late ThemeData _themeData;
  late bool _isDarkMode;
  late Color _primaryColor;

  ThemeProvider() {
    _isDarkMode = true; // Default value
    _primaryColor = Colors.blue; // Default primary color
    _themeData = _buildTheme();
  }

  ThemeData get themeData => _themeData;
  bool get isDarkMode => _isDarkMode;
  Color get primaryColor => _primaryColor;

  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    _themeData = _buildTheme();

    notifyListeners();
  }

  void setPrimaryColor(Color color) {
    _primaryColor = color;
    _themeData = _buildTheme();

    notifyListeners();
  }

  ThemeData _buildTheme() {
    return ThemeData(
      brightness: _isDarkMode ? Brightness.dark : Brightness.light,
      primaryColor: _primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        brightness: _isDarkMode ? Brightness.dark : Brightness.light,
      ),
    );
  }
}
