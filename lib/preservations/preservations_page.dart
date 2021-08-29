import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/preservations/preservations_model.dart';

class PreservationsPage extends ConsumerWidget {
  @override 
  Widget build(BuildContext context, ScopedReader watch) {
    final _preservationsProvider = watch(preservationsProvider);
    return Scaffold();
  }
}