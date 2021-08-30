import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:just_audio/just_audio.dart';

import 'package:whisper/parts/posts/notifiers/play_button_notifier.dart';
import 'package:whisper/parts/posts/notifiers/progress_notifier.dart';
import 'package:whisper/parts/posts/notifiers/repeat_button_notifier.dart';

final feedsProvider = ChangeNotifierProvider(
  (ref) => FeedsModel()
);

class FeedsModel extends ChangeNotifier {
  
  bool isLoading = false;
  User? currentUser;
  List<DocumentSnapshot> feedDocs = [];
  late QuerySnapshot<Map<String, dynamic>> snapshots;
}