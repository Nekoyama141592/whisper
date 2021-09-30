// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeProvider = ChangeNotifierProvider(
  (ref) => ThemeModel()
);

class ThemeModel extends ChangeNotifier {
  bool isDarkTheme = false;

  void toggoleIsDarkTheme() {
    isDarkTheme = !isDarkTheme;
    notifyListeners();
  }
}