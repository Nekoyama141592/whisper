import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themesProvider = ChangeNotifierProvider(
  (ref) => ThemesModel()
);

class ThemesModel extends ChangeNotifier {
  
}