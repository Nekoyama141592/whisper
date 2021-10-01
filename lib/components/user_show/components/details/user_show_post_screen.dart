// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
// constants
import 'package:whisper/constants/routes.dart' as routes;
// components
import 'package:whisper/details/loading.dart';
import 'package:whisper/details/nothing.dart';
import 'package:whisper/posts/components/audio_window/audio_window.dart';
import 'package:whisper/posts/components/details/post_card.dart';
// model
import 'package:whisper/components/user_show/user_show_model.dart';

class UserShowPostScreen extends StatelessWidget {
  
  const UserShowPostScreen({
    Key? key,
    required UserShowModel userShowProvider,
    required this.currentUserDoc,
    required this.preservatedPostIds,
    required this.likedPostIds,
  }) : userShowModel = userShowProvider, super(key: key);

  final DocumentSnapshot currentUserDoc;
  final UserShowModel userShowModel;
  final List preservatedPostIds;
  final List likedPostIds;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: userShowModel.isLoading ?
      Loading()
      : userShowModel.postDocs.isEmpty ?
      Nothing()
      : Padding(
        padding: EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: userShowModel.postDocs.length,
                itemBuilder: (BuildContext context, int i) =>
                PostCard(postDoc: userShowModel.postDocs[i])
              )
            ),
            AudioWindow(
              preservatedPostIds: preservatedPostIds,
              likedPostIds: likedPostIds,
              route: (){
                routes.toUserShowPostShowPage(context, currentUserDoc, userShowModel, preservatedPostIds, likedPostIds);
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
              currentUserDoc: currentUserDoc
            ),
          ],
        ),
      ),
    );
  }
}