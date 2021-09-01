import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'recommenders_model.dart';

import 'components/post_card.dart';
class RecommendersPage extends ConsumerWidget {
  RecommendersPage(this.preservatedPostIds);
  final List preservatedPostIds;
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _recommendersProvider = watch(recommendersProvider);
    return _recommendersProvider.isLoading ?
    Container(
      color: Colors.grey.withOpacity(0.7),
      child: Text('Loading'),
    )
    : PostCard(
      _recommendersProvider,
      preservatedPostIds
    );
  }
}

