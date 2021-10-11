// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/routes.dart' as routes;
// components
import 'package:whisper/details/judge_screen.dart';
import 'package:whisper/components/user_show/components/details/post_cards.dart';
import 'package:whisper/details/loading.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/components/user_show/user_show_model.dart';
import 'package:whisper/posts/components/other_pages/post_show/components/edit_post_info/edit_post_info_model.dart';

class UserShowPostScreen extends ConsumerWidget {
  
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
  Widget build(BuildContext context,ScopedReader watch) {

    final editPostInfoModel = watch(editPostInfoProvider);
    final isLoading = userShowModel.isLoading;
    final postDocs = userShowModel.postDocs;
    final content =  Padding(
      padding: EdgeInsets.only(top: 20),
      child: PostCards(
        postDocs: userShowModel.postDocs, 
        route: (){
          routes.toPostShowPage(
          context, 
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
          () {
            userShowModel.pause();
            routes.toCommentsPage(context, userShowModel.currentSongDocNotifier, mainModel);
          },
          () {
            userShowModel.pause();
            editPostInfoModel.isEditing = true;
            editPostInfoModel.reload();
          },
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
        userShowModel: userShowModel,
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