// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
// constants
import 'package:whisper/constants/strings.dart';

final themeProvider = ChangeNotifierProvider(
  (ref) => ThemeModel()
);

class ThemeModel extends ChangeNotifier {
  late SharedPreferences preferences;
  bool isDarkTheme = true;

  ThemeModel() {
    init();
  }

  void init() async {
    preferences = await SharedPreferences.getInstance();
    isDarkTheme = preferences.getBool(isDarkThemePrefsKey) ?? true;
    notifyListeners();
  }
  void setIsDartTheme(value) async {
    isDarkTheme = value;
    notifyListeners();
    await preferences.setBool(isDarkThemePrefsKey, value);
  }
}