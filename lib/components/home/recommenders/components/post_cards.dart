// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// constants
import 'package:whisper/constants/voids.dart' as voids;
// components
import 'package:whisper/posts/components/audio_window/audio_window.dart';
import 'package:whisper/posts/components/details/post_card.dart';
// notifiers
import 'package:whisper/posts/notifiers/progress_notifier.dart';
import 'package:whisper/posts/notifiers/play_button_notifier.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/components/home/recommenders/recommenders_model.dart';
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
    required this.recommendersModel
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
  final RecommendersModel recommendersModel;
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
                  onDeleteButtonPressed: () { voids.onPostDeleteButtonPressed(context: context, audioPlayer: recommendersModel.audioPlayer, postMap: postDocs[i].data() as Map<String,dynamic>, afterUris: recommendersModel.afterUris, results: recommendersModel.recommenderDocs, mainModel: mainModel, i: i); },
                  initAudioPlayer: () async {
                    await voids.initAudioPlayer(audioPlayer: recommendersModel.audioPlayer, afterUris: recommendersModel.afterUris, i: i);
                  },
                  muteUser: () async {
                    await voids.muteUser(audioPlayer: recommendersModel.audioPlayer, afterUris: recommendersModel.afterUris, mutesUids: mainModel.mutesUids, i: i, results: recommendersModel.recommenderDocs, mutesIpv6AndUids: mainModel.mutesIpv6AndUids, post: post, mainModel: mainModel);
                  },
                  mutePost: () async {
                    await voids.mutePost(mainModel: mainModel, i: i, post: post, afterUris: recommendersModel.afterUris, audioPlayer: recommendersModel.audioPlayer, results: recommendersModel.recommenderDocs );
                  },
                  blockUser: () async {
                    await voids.blockUser(audioPlayer: recommendersModel.audioPlayer, afterUris: recommendersModel.afterUris, blocksUids: mainModel.blocksUids, blocksIpv6AndUids: mainModel.blocksIpv6AndUids, i: i, results: recommendersModel.recommenderDocs, post: post, mainModel: mainModel);
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