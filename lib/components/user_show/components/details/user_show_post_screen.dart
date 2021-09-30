// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
// constants
import 'package:whisper/constants/routes.dart' as routes;
// components
import 'package:whisper/details/loading.dart';
import 'package:whisper/details/nothing.dart';
import 'package:whisper/posts/components/audio_state_items/audio_window.dart';
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
  }) : _userShowProvider = userShowProvider, super(key: key);

  final DocumentSnapshot currentUserDoc;
  final UserShowModel _userShowProvider;
  final List preservatedPostIds;
  final List likedPostIds;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _userShowProvider.isLoading ?
      Loading()
      : _userShowProvider.postDocs.isEmpty ?
      Nothing()
      : Padding(
        padding: EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _userShowProvider.postDocs.length,
                itemBuilder: (BuildContext context, int i) =>
                PostCard(postDoc: _userShowProvider.postDocs[i])
              )
            ),
            AudioWindow(
              preservatedPostIds,
              likedPostIds,
              (){
                routes.toUserShowPostShowPage(context, currentUserDoc, _userShowProvider, preservatedPostIds, likedPostIds);
              },
              _userShowProvider.progressNotifier,
              _userShowProvider.seek,
              _userShowProvider.currentSongTitleNotifier,
              _userShowProvider.currentSongPostIdNotifier,
              _userShowProvider.playButtonNotifier,
              (){
                _userShowProvider.play();
              },
            (){
              _userShowProvider.pause();
            },
              currentUserDoc
            ),
          ],
        ),
      ),
    );
  }
}