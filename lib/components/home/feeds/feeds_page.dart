// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
// components
import 'components/feeds_card.dart';
import 'package:whisper/details/loading.dart';
import 'package:whisper/details/nothing.dart';
// model
import 'package:whisper/components/home/feeds/feeds_model.dart';



class FeedsPage extends ConsumerWidget {
  
  const FeedsPage({
    Key? key,
    required this.preservatedPostIds,
    required this.likedPostIds
  }) : super(key: key);

  final List preservatedPostIds;
  final List likedPostIds;

  @override
  
  Widget build(BuildContext context, ScopedReader watch) {
    final feedsModel = watch(feedsProvider);
    return feedsModel.isLoading ?
    Loading()
    : feedsModel.feedDocs.isEmpty ?
    Nothing()
    : FeedsCard(feedsModel: feedsModel, preservatedPostIds: preservatedPostIds, likedPostIds: likedPostIds);
  }

}
