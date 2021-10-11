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
import 'package:whisper/main_model.dart';

class RecommendersPage extends ConsumerWidget {
  
  const RecommendersPage({
    Key? key,
    required this.mainModel
  }) : super(key: key);
  
  final MainModel mainModel;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final recommendersModel = watch(recommendersProvider);
    return recommendersModel.isLoading ?
    Loading()
    : JudgeScreen(
      list: recommendersModel.recommenderDocs ,
      content: PostCards(
        postDocs: recommendersModel.recommenderDocs, 
        route: () {
          routes.toPostShowPage(
            context, 
            recommendersModel.currentSongDocNotifier, 
            recommendersModel.progressNotifier, 
            recommendersModel.seek, 
            recommendersModel.repeatButtonNotifier, 
            () { recommendersModel.onRepeatButtonPressed(); }, 
            recommendersModel.isFirstSongNotifier, 
            () { recommendersModel.onPreviousSongButtonPressed(); }, 
            recommendersModel.playButtonNotifier, 
            () { recommendersModel.play(mainModel.readPostIds, mainModel.readPosts, mainModel.currentUserDoc); }, 
            () { recommendersModel.pause(); }, 
            recommendersModel.isLastSongNotifier, 
            () { recommendersModel.onNextSongButtonPressed(); },
            mainModel
          );
        },  
        progressNotifier: recommendersModel.progressNotifier, 
        seek: recommendersModel.seek, 
        currentSongDocNotifier: recommendersModel.currentSongDocNotifier ,
        playButtonNotifier: recommendersModel.playButtonNotifier, 
        play: () { recommendersModel.play(mainModel.readPostIds, mainModel.readPosts, mainModel.currentUserDoc); }, 
        pause: () { recommendersModel.pause(); }, 
        currentUserDoc: mainModel.currentUserDoc,
        refreshController: recommendersModel.refreshController,
        onRefresh: () { recommendersModel.onRefresh(); },
        onLoading: () { recommendersModel.onLoading(); },
        mainModel: mainModel,
      )
    );
  }
}

