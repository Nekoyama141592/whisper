// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/routes.dart' as routes;
// components
import 'package:whisper/details/judge_screen.dart';
import 'package:whisper/details/loading.dart';
import 'package:whisper/posts/components/details/post_cards.dart';
// model
import 'package:whisper/components/home/feeds/feeds_model.dart';



class FeedsPage extends ConsumerWidget {
  
  const FeedsPage({
    Key? key,
    required this.bookmarkedPostIds,
    required this.likedPostIds,
    required this.likedCommentIds,
    required this.likedComments,
    required this.bookmarks,
    required this.likes
  }) : super(key: key);

  final List bookmarkedPostIds;
  final List likedPostIds;
  final List likedCommentIds;
  final List likedComments;
  final List bookmarks;
  final List likes;
  @override
  
  Widget build(BuildContext context, ScopedReader watch) {
    
    final feedsModel = watch(feedsProvider);
    final isLoading = feedsModel.isLoading;
    final postDocs = feedsModel.feedDocs;
    
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
            feedsModel.currentUserDoc, 
            feedsModel.currentSongDocNotifier, 
            feedsModel.progressNotifier, 
            feedsModel.seek, 
            feedsModel.repeatButtonNotifier, 
            () { feedsModel.onRepeatButtonPressed(); }, 
            feedsModel.isFirstSongNotifier, 
            () { feedsModel.onPreviousSongButtonPressed(); }, 
            feedsModel.playButtonNotifier, 
            () { feedsModel.play(); }, 
            () { feedsModel.pause(); }, 
            feedsModel.isLastSongNotifier, 
            () { feedsModel.onNextSongButtonPressed(); }
          );
        }, 
        progressNotifier: feedsModel.progressNotifier, 
        seek: feedsModel.seek, 
        currentSongDocNotifier: feedsModel.currentSongDocNotifier ,
        playButtonNotifier: feedsModel.playButtonNotifier, 
        play: () { feedsModel.play(); }, 
        pause: () { feedsModel.pause(); }, 
        currentUserDoc: feedsModel.currentUserDoc,
        refreshController: feedsModel.refreshController,
        onRefresh: () { feedsModel.onRefresh(); },
        onLoading: () { feedsModel.onLoading();},
      )
    );
  }

}
