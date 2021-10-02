// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// components
import 'package:whisper/details/nothing.dart';
import 'components/recommenders_card.dart';
import 'package:whisper/details/loading.dart';
// model
import 'recommenders_model.dart';

class RecommendersPage extends ConsumerWidget {
  
  const RecommendersPage({
    Key? key,
    required this.currentUserDoc,
    required this.preservatedPostIds,
    required this.likedPostIds
  }) : super(key: key);
  
  final DocumentSnapshot currentUserDoc;
  final List preservatedPostIds;
  final List likedPostIds;
  
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final recommendersModel = watch(recommendersProvider);
    return recommendersModel.isLoading ?
    Loading()
    : recommendersModel.recommenderDocs.isEmpty ?
    Nothing()
    : RecommendersCard(currentUserDoc: currentUserDoc, recommendersModel: recommendersModel, preservatedPostIds: preservatedPostIds, likedPostIds: likedPostIds);
  }
}

