// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
// constants
import 'package:whisper/constants/routes.dart' as routes;
// components
import 'package:whisper/details/judge_screen.dart';
import 'package:whisper/posts/components/details/post_cards.dart';
import 'package:whisper/details/loading.dart';
// model
import 'package:whisper/components/user_show/user_show_model.dart';

class UserShowPostScreen extends StatelessWidget {
  
  const UserShowPostScreen({
    Key? key,
    required this.userShowModel,
    required this.currentUserDoc,
    required this.bookmarkedPostIds,
    required this.likedPostIds,
  }) : super(key: key);

  final DocumentSnapshot currentUserDoc;
  final UserShowModel userShowModel;
  final List bookmarkedPostIds;
  final List likedPostIds;

  @override
  Widget build(BuildContext context) {
    final isLoading = userShowModel.isLoading;
    final postDocs = userShowModel.postDocs;
    final content =  Padding(
      padding: EdgeInsets.only(top: 20),
      child: PostCards(
        likedPostIds: likedPostIds, 
        bookmarkedPostIds: bookmarkedPostIds, 
        postDocs: userShowModel.postDocs, 
        route: (){
          routes.toPostShowPage(
          context, 
          likedPostIds, 
          bookmarkedPostIds, 
          currentUserDoc, 
          userShowModel.currentSongDocNotifier, 
          userShowModel.progressNotifier, 
          userShowModel.seek, 
          userShowModel.repeatButtonNotifier, 
          () { userShowModel.onRepeatButtonPressed(); }, 
          userShowModel.isFirstSongNotifier, 
          () { userShowModel.onPreviousSongButtonPressed(); }, 
          userShowModel.playButtonNotifier, 
          () { userShowModel.play(); }, 
          () { userShowModel.pause(); }, 
          userShowModel.isLastSongNotifier, 
          () { userShowModel.onNextSongButtonPressed(); }
          );
        },
        progressNotifier: userShowModel.progressNotifier,
        seek: userShowModel.seek,
        currentSongDocNotifier: userShowModel.currentSongDocNotifier,
        playButtonNotifier: userShowModel.playButtonNotifier,
        play: (){
          userShowModel.play();
        },
        pause: (){
          userShowModel.pause();
        }, 
        currentUserDoc: currentUserDoc,
        refreshController: userShowModel.refreshController,
        onRefresh: (){ userShowModel.onRefresh(); },
        onLoading: () { userShowModel.onLoading(); },
      ),
    );
    
    return isLoading ?
    Loading()
    : JudgeScreen(
      postDocs: postDocs, 
      content: content
    );
    
  }
}