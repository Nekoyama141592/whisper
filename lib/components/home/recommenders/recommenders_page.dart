// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/routes.dart' as routes;
// components
import 'package:whisper/details/loading.dart';
import 'package:whisper/details/judge_screen.dart';
import 'package:whisper/posts/components/details/post_cards.dart';
// model
import 'recommenders_model.dart';

class RecommendersPage extends ConsumerWidget {
  
  const RecommendersPage({
    Key? key,
    required this.currentUserDoc,
    required this.bookmarkedPostIds,
    required this.likedPostIds,
    required this.likedCommentIds,
    required this.likedComments
  }) : super(key: key);
  
  final DocumentSnapshot currentUserDoc;
  final List bookmarkedPostIds;
  final List likedPostIds;
  final List likedCommentIds;
  final List likedComments;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final recommendersModel = watch(recommendersProvider);
    final isLoading = recommendersModel.isLoading;
    final postDocs = recommendersModel.recommenderDocs;
    return isLoading ?
    Loading()
    : JudgeScreen(
      postDocs: postDocs, 
      content: PostCards(
        likedPostIds: likedPostIds, 
        bookmarkedPostIds: bookmarkedPostIds, 
        postDocs: postDocs, 
        route: () {
          routes.toPostShowPage(
            context, 
            likedPostIds, 
            bookmarkedPostIds,
            likedCommentIds,
            likedComments,
            currentUserDoc,
            recommendersModel.currentSongDocNotifier, 
            recommendersModel.progressNotifier, 
            recommendersModel.seek, 
            recommendersModel.repeatButtonNotifier, 
            () { recommendersModel.onRepeatButtonPressed(); }, 
            recommendersModel.isFirstSongNotifier, 
            () { recommendersModel.onPreviousSongButtonPressed(); }, 
            recommendersModel.playButtonNotifier, 
            () { recommendersModel.play(); }, 
            () { recommendersModel.pause(); }, 
            recommendersModel.isLastSongNotifier, 
            () { recommendersModel.onNextSongButtonPressed(); }
          );
        },  
        progressNotifier: recommendersModel.progressNotifier, 
        seek: recommendersModel.seek, 
        currentSongDocNotifier: recommendersModel.currentSongDocNotifier ,
        playButtonNotifier: recommendersModel.playButtonNotifier, 
        play: () { recommendersModel.play(); }, 
        pause: () { recommendersModel.pause(); }, 
        currentUserDoc: currentUserDoc,
        refreshController: recommendersModel.refreshController,
        onRefresh: () { recommendersModel.onRefresh(); },
        onLoading: () { recommendersModel.onLoading(); },
      )
    );
  }
}

