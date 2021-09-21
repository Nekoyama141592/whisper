import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:whisper/preservations/preservations_model.dart';
import 'package:whisper/preservations/components/post_screen.dart';
class PreservationsPage extends ConsumerWidget {
  PreservationsPage(this.currentUserDoc,this.preservatedPostIds,this.likedPostIds);
  final DocumentSnapshot currentUserDoc;
  final List preservatedPostIds;
  final List likedPostIds;
  @override 
  Widget build(BuildContext context, ScopedReader watch) {
    final _preservationsProvider = watch(preservationsProvider);
    return Scaffold(
      body: PostScreen(
        preservationsProvider: _preservationsProvider,
        currentUserDoc: currentUserDoc, 
        preservatedPostIds: preservatedPostIds, 
        likedPostIds: likedPostIds
      )
    );
  }
}

