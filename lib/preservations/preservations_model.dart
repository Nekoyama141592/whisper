import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final preservationsProvider = ChangeNotifierProvider(
  (ref) => PreservationsModel()
);

class PreservationsModel extends ChangeNotifier {
  
}