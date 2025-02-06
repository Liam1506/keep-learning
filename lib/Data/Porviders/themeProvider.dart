import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = ThemeData.dark();
  bool _isDarkMode = true;

  ThemeProvider() {
    _loadTheme();
  }

  ThemeData get themeData => _themeData;
  bool get isDarkMode => _isDarkMode;

  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    _themeData = _isDarkMode ? ThemeData.dark() : ThemeData.light();

    notifyListeners();
    _saveTheme();
  }

  void _saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _isDarkMode);
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? true;
    _themeData = _isDarkMode ? ThemeData.dark() : ThemeData.light();
    notifyListeners();
  }
}
