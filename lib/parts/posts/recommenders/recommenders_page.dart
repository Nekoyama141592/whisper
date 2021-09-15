import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/parts/nothing.dart';
import 'recommenders_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'components/recommenders_card.dart';
import 'package:whisper/parts/loading.dart';
class RecommendersPage extends ConsumerWidget {
  RecommendersPage(this.currentUserDoc,this.preservatedPostIds,this.likedPostIds);
  
  final DocumentSnapshot currentUserDoc;
  final List preservatedPostIds;
  final List likedPostIds;
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _recommendersProvider = watch(recommendersProvider);
    return _recommendersProvider.isLoading ?
    Loading()
    : _recommendersProvider.recommenderDocs.isEmpty ?
    Nothing()
    : RecommendersCard(
      currentUserDoc,
      _recommendersProvider,
      preservatedPostIds,
      likedPostIds
    );
  }
}

