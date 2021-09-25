
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/details/loading.dart';
import 'package:whisper/details/nothing.dart';

import 'user_show_model.dart';
import 'package:whisper/posts/components/audio_state_items/audio_window.dart';
import 'package:whisper/posts/components/details/post_card.dart';
import 'package:whisper/posts/components/details/user_image.dart';
import 'package:whisper/components/user_show/components/user_show_button.dart';
import 'package:whisper/components/user_show/components/edit_profile/edit_profile_screen.dart';
import 'package:whisper/components/user_show/user_show_model.dart';
import 'package:whisper/components/user_show/components/follow/follow_model.dart';
import 'package:whisper/constants/routes.dart' as routes;

class UserShowPage extends ConsumerWidget {
  
  final DocumentSnapshot currentUserDoc;
  final DocumentSnapshot doc;
  final List preservatedPostIds;
  final List likedPostIds;
  final List followingUids;
  UserShowPage(
    this.currentUserDoc,
    this.doc,
    this.preservatedPostIds,
    this.likedPostIds,
    this.followingUids
  );
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _userShowProvider = watch(userShowProvider);
    final _followProvider = watch(followProvider);
    final List<dynamic> followerUids = currentUserDoc['followerUids'];

    return Scaffold(
      extendBodyBehindAppBar: false,
      body: 
      SafeArea(
        child: _userShowProvider.isEditing ?
        EditProfileScreen(userShowProvider: _userShowProvider, currentUserDoc: currentUserDoc)
        : Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              colors: [
                kPrimaryColor.withOpacity(0.9),
                kPrimaryColor.withOpacity(0.8),
                kPrimaryColor.withOpacity(0.4),
              ]
            )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  20, 
                  20, 
                  20, 
                  5
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(doc['userName'],style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text(doc['subUserName'],style: TextStyle(color: Colors.white, fontSize: 15)),
                    
                    SizedBox(height: 10),
                    Row(
                      children: [
                        UserImage(doc: doc),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            doc['description'],
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        UserShowButton(
                          currentUserDoc: currentUserDoc, 
                          userDoc: doc, 
                          userShowProvider: _userShowProvider, 
                          followingUids: followingUids, 
                          followProvider: _followProvider
                        )
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          'following' +followingUids.length.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(width: 20,),
                        Text(
                          'follower' + followerUids.length.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(width: 20,),
                        // if (doc.id == currentUserDoc.id) Text('変更')
                      ],
                    )

                  ],
                ),
              ),
              
              SizedBox(height: 10),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: kBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35)
                    )
                  ),
                  child: UserShowPostScreen(
                    currentUserDoc: currentUserDoc,
                    userShowProvider: _userShowProvider, 
                    preservatedPostIds: preservatedPostIds, 
                    likedPostIds: likedPostIds
                  ),
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}

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
                PostCard(_userShowProvider.postDocs[i])
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