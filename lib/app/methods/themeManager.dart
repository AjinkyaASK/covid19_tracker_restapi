import 'package:coronavirus_tracker_global/app/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemePreferences themePrefs = ThemePreferences();
ThemeProvider themeProvider = ThemeProvider();

class ThemePreferences {
  SharedPreferences sharedPrefs;

  setTheme({bool dark}) async {
    if (sharedPrefs == null) {
      sharedPrefs = await SharedPreferences.getInstance();
    }
    sharedPrefs.setBool(THEME_MODE, dark);
  }

  Future<bool> getTheme() async {
    if (sharedPrefs == null) {
      sharedPrefs = await SharedPreferences.getInstance();
    }
    return sharedPrefs.getBool(THEME_MODE) ?? false;
  }
}

class ThemeProvider with ChangeNotifier {
  bool _darkTheme = false;

  get theme => _darkTheme;

  set theme(bool dark) {
    _darkTheme = dark;
    themePrefs.setTheme(dark: _darkTheme);
    notifyListeners();
  }

  toggleTheme() async {
    _darkTheme = !_darkTheme;
    themePrefs.setTheme(dark: _darkTheme);
    notifyListeners();
  }
}
