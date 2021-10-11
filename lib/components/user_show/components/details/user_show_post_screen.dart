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
import 'package:whisper/main_model.dart';
import 'package:whisper/components/user_show/user_show_model.dart';

class UserShowPostScreen extends StatelessWidget {
  
  const UserShowPostScreen({
    Key? key,
    required this.userShowModel,
    required this.currentUserDoc,
    required this.mainModel
  }) : super(key: key);

  final DocumentSnapshot currentUserDoc;
  final UserShowModel userShowModel;
  final MainModel mainModel;

  @override
  Widget build(BuildContext context) {
    final isLoading = userShowModel.isLoading;
    final postDocs = userShowModel.postDocs;
    final content =  Padding(
      padding: EdgeInsets.only(top: 20),
      child: PostCards(
        likedPostIds: mainModel.likedPostIds, 
        bookmarkedPostIds: mainModel.bookmarkedPostIds, 
        likes: mainModel.likes,
        postDocs: userShowModel.postDocs, 
        route: (){
          routes.toPostShowPage(
          context, 
          mainModel.likedPostIds, 
          mainModel.bookmarkedPostIds,
          mainModel.likedCommentIds,
          mainModel.likedComments,
          mainModel.bookmarks,
          mainModel.likes,
          currentUserDoc, 
          userShowModel.currentSongDocNotifier, 
          userShowModel.progressNotifier, 
          userShowModel.seek, 
          userShowModel.repeatButtonNotifier, 
          () { userShowModel.onRepeatButtonPressed(); }, 
          userShowModel.isFirstSongNotifier, 
          () { userShowModel.onPreviousSongButtonPressed(); }, 
          userShowModel.playButtonNotifier, 
          () { userShowModel.play(mainModel.readPostIds, mainModel.readPosts, currentUserDoc); }, 
          () { userShowModel.pause(); }, 
          userShowModel.isLastSongNotifier, 
          () { userShowModel.onNextSongButtonPressed(); },
          mainModel
          );
        },
        progressNotifier: userShowModel.progressNotifier,
        seek: userShowModel.seek,
        currentSongDocNotifier: userShowModel.currentSongDocNotifier,
        playButtonNotifier: userShowModel.playButtonNotifier,
        play: (){
          userShowModel.play(mainModel.readPostIds, mainModel.readPosts, currentUserDoc);
        },
        pause: (){
          userShowModel.pause();
        }, 
        currentUserDoc: currentUserDoc,
        refreshController: userShowModel.refreshController,
        onRefresh: (){ userShowModel.onRefresh(); },
        onLoading: () { userShowModel.onLoading(); },
        mainModel: mainModel,
      ),
    );
    
    return isLoading ?
    Loading()
    : JudgeScreen(
      list: postDocs, 
      content: content
    );
    
  }
}