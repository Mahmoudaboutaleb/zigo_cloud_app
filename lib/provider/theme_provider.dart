// ignore_for_file: file_names, constant_identifier_names

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _darkTheme = false;
  bool get getIsDarkTheme => _darkTheme;
  static const THEME_STATUS = "THEME_STATUS";
  ThemeProvider() {
    getTheme();
  }

  Future<void> setDarkTheme({required bool themeValue}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(THEME_STATUS, themeValue);
    _darkTheme = themeValue;
    notifyListeners();
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _darkTheme = prefs.getBool(THEME_STATUS) ?? false;
    notifyListeners();
    return _darkTheme;
  }
}
