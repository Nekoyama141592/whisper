import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'recommenders_model.dart';

import 'components/recommenders_card.dart';
import 'package:whisper/parts/loading.dart';

class RecommendersPage extends ConsumerWidget {
  RecommendersPage(this.preservatedPostIds,this.likedPostIds);
  final List preservatedPostIds;
  final List likedPostIds;
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _recommendersProvider = watch(recommendersProvider);
    return _recommendersProvider.isLoading ?
    Loading()
    : RecommendersCard(
      _recommendersProvider,
      preservatedPostIds,
      likedPostIds
    );
  }
}

