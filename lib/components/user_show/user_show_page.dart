// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// constants
import 'package:whisper/constants/colors.dart';
// components
import 'package:whisper/posts/components/details/user_image.dart';
import 'package:whisper/components/user_show/components/details/user_show_button.dart';
import 'package:whisper/components/user_show/components/edit_profile/edit_profile_screen.dart';
import 'package:whisper/components/user_show/components/details/user_show_post_screen.dart';
// models
import 'package:whisper/components/user_show/user_show_model.dart';
import 'package:whisper/components/user_show/components/follow/follow_model.dart';
import 'user_show_model.dart';

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
                Theme.of(context).primaryColor.withOpacity(0.9),
                Theme.of(context).primaryColor.withOpacity(0.8),
                Theme.of(context).primaryColor.withOpacity(0.4),
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
                    Text(
                      !_userShowProvider.isEdited ? doc['userName'] : _userShowProvider.userName,
                      style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold)
                    ),
                    
                    SizedBox(height: 10),
                    Row(
                      children: [
                        UserImage(doc: doc),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            !_userShowProvider.isEdited ? doc['description'] : _userShowProvider.description,
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
                      ],
                    )

                  ],
                ),
              ),
              
              SizedBox(height: 10),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
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

