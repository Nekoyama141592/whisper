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
    required this.likedComments,
    required this.bookmarks,
    required this.likes,
    required this.readPostIds,
    required this.readPosts
  }) : super(key: key);
  
  final DocumentSnapshot currentUserDoc;
  final List bookmarkedPostIds;
  final List likedPostIds;
  final List likedCommentIds;
  final List likedComments;
  final List bookmarks;
  final List likes;
  final List readPostIds;
  final List readPosts;

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
        likes: likes,
        postDocs: postDocs, 
        route: () {
          routes.toPostShowPage(
            context, 
            likedPostIds, 
            bookmarkedPostIds,
            likedCommentIds,
            likedComments,
            bookmarks,
            likes,
            currentUserDoc,
            recommendersModel.currentSongDocNotifier, 
            recommendersModel.progressNotifier, 
            recommendersModel.seek, 
            recommendersModel.repeatButtonNotifier, 
            () { recommendersModel.onRepeatButtonPressed(); }, 
            recommendersModel.isFirstSongNotifier, 
            () { recommendersModel.onPreviousSongButtonPressed(); }, 
            recommendersModel.playButtonNotifier, 
            () { recommendersModel.play(readPostIds, readPosts, currentUserDoc); }, 
            () { recommendersModel.pause(); }, 
            recommendersModel.isLastSongNotifier, 
            () { recommendersModel.onNextSongButtonPressed(); }
          );
        },  
        progressNotifier: recommendersModel.progressNotifier, 
        seek: recommendersModel.seek, 
        currentSongDocNotifier: recommendersModel.currentSongDocNotifier ,
        playButtonNotifier: recommendersModel.playButtonNotifier, 
        play: () { recommendersModel.play(readPostIds, readPosts, currentUserDoc); }, 
        pause: () { recommendersModel.pause(); }, 
        currentUserDoc: currentUserDoc,
        refreshController: recommendersModel.refreshController,
        onRefresh: () { recommendersModel.onRefresh(); },
        onLoading: () { recommendersModel.onLoading(); },
      )
    );
  }
}

