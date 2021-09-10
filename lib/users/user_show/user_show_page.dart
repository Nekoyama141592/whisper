
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/parts/loading.dart';
import 'package:whisper/parts/nothing.dart';

import 'user_show_model.dart';
import 'package:whisper/users/user_show/audio_controll/audio_window.dart';
import 'package:whisper/parts/posts/components/post_card.dart';

class UserShowPage extends ConsumerWidget {
  final DocumentSnapshot doc;
  final List preservatedPostIds;
  final List likedPostIds;
  UserShowPage(this.doc,this.preservatedPostIds,this.likedPostIds);
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _userShowProvider = watch(userShowProvider);
    return Scaffold(
      extendBodyBehindAppBar: false,
      body: 
      SafeArea(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
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
                    Text(doc['userName'],style: TextStyle(color: Colors.white, fontSize: 20)),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        UserImage(doc: doc),
                        Text(doc['description'])
                      ],
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 5),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(50)
                    )
                  ),
                  child: UserShowPostScreen(userShowProvider: _userShowProvider, preservatedPostIds: preservatedPostIds, likedPostIds: likedPostIds),
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}

class UserImage extends StatelessWidget {
  const UserImage({
    Key? key,
    required this.doc,
  }) : super(key: key);

  final DocumentSnapshot doc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(25),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.fill,
          image: NetworkImage(doc['imageURL'])
        ),
      ),
    );
  }
}

class UserShowPostScreen extends StatelessWidget {
  const UserShowPostScreen({
    Key? key,
    required UserShowModel userShowProvider,
    required this.preservatedPostIds,
    required this.likedPostIds,
  }) : _userShowProvider = userShowProvider, super(key: key);

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
      : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _userShowProvider.postDocs.length,
              itemBuilder: (BuildContext context, int i) =>
              PostCard(_userShowProvider.postDocs[i])
            )
          ),
          AudioWindow(_userShowProvider,preservatedPostIds,likedPostIds)
        ],
      ),
    );
  }
}