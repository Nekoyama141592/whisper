import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whisper/constants/colors.dart';

import 'package:whisper/users/user_show/audio_controll/audio_state_design.dart';
import 'package:whisper/users/user_show/user_show_model.dart';


import 'package:whisper/parts/posts/post_buttons/post_buttons.dart';

class UserShowPostShowPage extends StatelessWidget {
  UserShowPostShowPage(this.doc,this.userShowProvider,this.preservatedPostIds,this.likedPostIds);
  final UserShowModel userShowProvider;
  final DocumentSnapshot doc;
  final List preservatedPostIds;
  final List likedPostIds;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 10
            ),
            child: IconButton(
              icon: Icon(Icons.keyboard_arrow_down),
              onPressed: (){
                Navigator.pop(context);
              }, 
            ),
          ),
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  // image
                  child: Text(doc.id),
                ),
                Center(
                  child: Text(doc['title']),
                ),
                PostButtons(
                  userShowProvider.currentUser!.uid,
                  doc,
                  preservatedPostIds,
                  likedPostIds
                ),
                AudioStateDesign(userShowProvider,preservatedPostIds,likedPostIds),
                
              ],
            ),
        ],
      ),
    );
  }
}