
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/parts/components/loading.dart';

import 'package:whisper/components/home/feeds/feeds_model.dart';

import 'components/feeds_card.dart';

import 'package:whisper/parts/components/nothing.dart';

class FeedsPage extends ConsumerWidget {
  FeedsPage(this.preservatedPostIds,this.likedPostIds);
  final List preservatedPostIds;
  final List likedPostIds;
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _feedsProvider = watch(feedsProvider);
    return _feedsProvider.isLoading ?
    Loading()
    : _feedsProvider.feedDocs.isEmpty ?
    Nothing()
    : FeedsCard(
      _feedsProvider,
      preservatedPostIds,
      likedPostIds
    );
  }
}
