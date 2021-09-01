
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whisper/parts/posts/feeds/feeds_model.dart';

import 'components/post_card.dart';

class FeedsPage extends ConsumerWidget {
  FeedsPage(this.preservatedPostIds);
  final List preservatedPostIds;
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _feedsProvider = watch(feedsProvider);
    return _feedsProvider.isLoading ?
    Container(
      color: Colors.grey.withOpacity(0.7),
      child: Text('Loading'),
    )
    : _feedsProvider.feedDocs.isEmpty ?
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text('Nothing')
        )
      ],
    )
    : PostCard(
      _feedsProvider,
      preservatedPostIds
    );
  }
}
