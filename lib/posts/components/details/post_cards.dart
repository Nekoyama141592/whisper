// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
// components
import 'package:whisper/posts/components/details/post_card.dart';
import 'package:whisper/posts/components/audio_window/audio_window.dart';
// notifiers
import 'package:whisper/posts/notifiers/progress_notifier.dart';
import 'package:whisper/posts/notifiers/play_button_notifier.dart';

class PostCards extends StatelessWidget {

  const PostCards({
    Key? key,
    required this.likedPostIds,
    required this.bookmarkedPostIds,
    required this.postDocs,
    required this.route,
    required this.progressNotifier,
    required this.seek,
    required this.currentSongDocNotifier,
    required this.playButtonNotifier,
    required this.play,
    required this.pause,
    required this.currentUserDoc
  }) : super(key: key);

  final List likedPostIds;
  final List bookmarkedPostIds;
  final List<DocumentSnapshot> postDocs;
  final void Function()? route;
  final ProgressNotifier progressNotifier;
  final void Function(Duration)? seek;
  final ValueNotifier<DocumentSnapshot?> currentSongDocNotifier;
  final PlayButtonNotifier playButtonNotifier;
  final void Function()? play;
  final void Function()? pause;
  final DocumentSnapshot currentUserDoc;

  @override 
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: postDocs.length,
            itemBuilder: (BuildContext context, int i) =>
              PostCard(postDoc: postDocs[i])
          ),
        ),
        AudioWindow(
          bookmarkedPostIds: bookmarkedPostIds, 
          likedPostIds: likedPostIds, 
          route: route, 
          progressNotifier: progressNotifier, 
          seek: seek, 
          currentSongDocNotifier: currentSongDocNotifier, 
          playButtonNotifier: playButtonNotifier, 
          play: play, 
          pause: pause, 
          currentUserDoc: currentUserDoc
        )
      ],
    );
  }
}