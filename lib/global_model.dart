// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';


final globalProvider = ChangeNotifierProvider(
  (ref) => GlobalModel()
);

class GlobalModel extends ChangeNotifier {
  final isLoggedInNotifier = ValueNotifier<bool>(false);
}