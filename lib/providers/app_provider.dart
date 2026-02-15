import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;
  String _language = 'pt_BR';

  ThemeMode get themeMode => _themeMode;
  String get language => _language;

  AppProvider() {
    _loadPreferences();
  }

  void _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? theme = prefs.getString('theme');
    String? lang = prefs.getString('lang');

    if (theme == 'light') {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.dark;
    }

    if (lang != null) {
      _language = lang;
    }

    notifyListeners();
  }

  void toggleTheme() async {
    if (_themeMode == ThemeMode.dark) {
      _themeMode = ThemeMode.light;
      await _saveTheme('light');
    } else {
      _themeMode = ThemeMode.dark;
      await _saveTheme('dark');
    }
    notifyListeners();
  }

  Future<void> _saveTheme(String theme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', theme);
  }

  void setLanguage(String lang) async {
    _language = lang;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang', lang);
    notifyListeners();
  }
}
