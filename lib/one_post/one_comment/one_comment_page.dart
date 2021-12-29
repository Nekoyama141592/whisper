// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
// components
import 'package:whisper/details/back_arrow_button.dart';
import 'package:whisper/posts/components/comments/components/comment_card.dart';
import 'package:whisper/posts/components/one_post_audio_window/one_post_audio_window.dart';
// constants
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/constants/routes.dart' as routes;
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/one_post/one_post_model.dart';
import 'package:whisper/posts/components/replys/replys_model.dart';
import 'package:whisper/posts/components/comments/comments_model.dart';
import 'package:whisper/one_post/one_comment/one_comment_model.dart';
import 'package:whisper/posts/components/other_pages/post_show/components/edit_post_info/edit_post_info_model.dart';

class OneCommentPage extends ConsumerWidget {
  
  OneCommentPage({
    Key? key,
    required this.mainModel,
  }) : super(key: key);

  final MainModel mainModel;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    
    final editPostInfoModel = watch(editPostInfoProvider); 
    final OneCommentModel oneCommentModel = watch(oneCommentProvider);
    final CommentsModel commentsModel = watch(commentsProvider);
    final ReplysModel replysModel = watch(replysProvider);
    final OnePostModel onePostModel = watch(onePostProvider);

    return Scaffold(
      body: oneCommentModel.isLoading ?
      SizedBox.shrink()
      : Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BackArrowButton(),
              CommentCard(comment: oneCommentModel.oneCommentMap, commentsModel: commentsModel, replysModel: replysModel, mainModel: mainModel, currentSongMap: onePostModel.currentSongMapNotifier.value,),
              OnePostAudioWindow(
                route: () {
                  routes.toPostShowPage(
                    context,
                    onePostModel.speedNotifier,
                    () async { onePostModel.speedControll(prefs: mainModel.prefs); },
                    onePostModel.currentSongMapNotifier, 
                    onePostModel.progressNotifier, 
                    onePostModel.seek, 
                    onePostModel.repeatButtonNotifier, 
                    () { onePostModel.onRepeatButtonPressed(); }, 
                    onePostModel.isFirstSongNotifier, 
                    () { onePostModel.onPreviousSongButtonPressed(); }, 
                    onePostModel.playButtonNotifier, 
                    () async { 
                      await voids.play(audioPlayer: onePostModel.audioPlayer, readPostIds: mainModel.readPostIds, readPosts: mainModel.readPosts, currentUserDoc: mainModel.currentUserDoc, postId: onePostModel.currentSongMapNotifier.value['postId'] );
                    }, 
                    () { voids.pause(audioPlayer: onePostModel.audioPlayer); }, 
                    onePostModel.isLastSongNotifier, 
                    () { onePostModel.onNextSongButtonPressed(); },
                    () async {
                      await commentsModel.init(context, onePostModel.audioPlayer, onePostModel.currentSongMapNotifier, mainModel, onePostModel.currentSongMapNotifier.value['postId']);
                    },
                    () {
                      onePostModel.toEditPostInfoMode(editPostInfoModel: editPostInfoModel);
                    },
                    mainModel
                  );
                }, 
                progressNotifier: onePostModel.progressNotifier, 
                playButtonNotifier: onePostModel.playButtonNotifier, 
                seek: onePostModel.seek, 
                play: () async { await voids.play(audioPlayer: onePostModel.audioPlayer, readPostIds: mainModel.readPostIds, readPosts: mainModel.readPosts, currentUserDoc: mainModel.currentUserDoc, postId: onePostModel.currentSongMapNotifier.value['postId'] ); },
                pause: () { voids.pause(audioPlayer: onePostModel.audioPlayer); }, 
                title: Text(
                  onePostModel.currentSongMapNotifier.value['title'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0 ),
                ), 
                currentUserDoc: mainModel.currentUserDoc
              )
            ],
          ),
        ),
      ),
    );
  }
}