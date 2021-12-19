// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// components
import 'package:whisper/posts/components/details/post_card.dart';
import 'package:whisper/components/user_show/user_show_model.dart';
import 'package:whisper/posts/components/audio_window/audio_window.dart';
// notifiers
import 'package:whisper/posts/notifiers/progress_notifier.dart';
import 'package:whisper/posts/notifiers/play_button_notifier.dart';
// model
import 'package:whisper/main_model.dart';

class PostCards extends StatelessWidget {

  const PostCards({
    Key? key,
    required this.postDocs,
    required this.route,
    required this.progressNotifier,
    required this.seek,
    required this.currentSongMapNotifier,
    required this.playButtonNotifier,
    required this.play,
    required this.pause,
    required this.currentUserDoc,
    required this.refreshController,
    required this.onRefresh,
    required this.onLoading,
    required this.isFirstSongNotifier,
    required this.onPreviousSongButtonPressed,
    required this.isLastSongNotifier,
    required this.onNextSongButtonPressed,
    required this.mainModel,
    required this.userShowModel
  }) : super(key: key);

 
  final List<DocumentSnapshot> postDocs;
  final void Function()? route;
  final ProgressNotifier progressNotifier;
  final void Function(Duration)? seek;
  final ValueNotifier<Map<String,dynamic>> currentSongMapNotifier;
  final PlayButtonNotifier playButtonNotifier;
  final void Function()? play;
  final void Function()? pause;
  final DocumentSnapshot currentUserDoc;
  // refresh
  final RefreshController refreshController;
  final void Function()? onRefresh;
  final void Function()? onLoading;
  final ValueNotifier<bool> isFirstSongNotifier;
  final void Function()? onPreviousSongButtonPressed;
  final ValueNotifier<bool> isLastSongNotifier;
  final void Function()? onNextSongButtonPressed;
  final MainModel mainModel;
  final UserShowModel userShowModel;

  @override 
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            header: WaterDropHeader(),
            controller: refreshController,
            onRefresh: onRefresh,
            onLoading: onLoading,
            child: ListView.builder(
              itemCount: postDocs.length,
              itemBuilder: (BuildContext context, int i) {
                final Map<String,dynamic> post = postDocs[i].data() as Map<String,dynamic>;
                return 
                PostCard(
                  post: post,
                  onDeleteButtonPressed: () { userShowModel.onDeleteButtonPressed(context, postDocs[i], mainModel.currentUserDoc, i); },
                  initAudioPlayer: () async {
                    await userShowModel.initAudioPlayer(i);
                  },
                  muteUser: () async {
                    await userShowModel.muteUser(mainModel.mutesUids, post['uid'], mainModel.prefs, i, mainModel.currentUserDoc,mainModel.mutesIpv6AndUids,post);
                  },
                  mutePost: () async {
                    await userShowModel.mutePost(mainModel.mutesPostIds, post['postId'], mainModel.prefs, i);
                  },
                  blockUser: () async {
                    await userShowModel.blockUser(mainModel.currentUserDoc, mainModel.blockingUids, post['uid'], i,mainModel.mutesIpv6AndUids,post);
                  },
                  mainModel: mainModel,
                );
              }
            ),
          ),
        ),
        AudioWindow(
          route: route, 
          progressNotifier: progressNotifier, 
          seek: seek, 
          currentSongMapNotifier: currentSongMapNotifier, 
          playButtonNotifier: playButtonNotifier, 
          play: play, 
          pause: pause, 
          currentUserDoc: currentUserDoc,
           isFirstSongNotifier: isFirstSongNotifier,
          onPreviousSongButtonPressed: onPreviousSongButtonPressed,
          isLastSongNotifier: isLastSongNotifier,
          onNextSongButtonPressed: onNextSongButtonPressed,
          mainModel: mainModel,
        )
      ],
    );
  }
}