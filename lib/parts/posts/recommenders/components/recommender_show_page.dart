import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whisper/constants/colors.dart';

import 'package:whisper/parts/posts/recommenders/audio_controll/audio_state_design.dart';
import 'package:whisper/parts/posts/recommenders/recommenders_model.dart';

import 'package:whisper/parts/posts/post_buttons/post_buttons.dart';

import 'package:whisper/parts/comments/comments.dart';
import 'package:whisper/constants/routes.dart' as routes;
class RecommenderShowPage extends StatelessWidget{
  final DocumentSnapshot doc;
  final RecommendersModel recommendersProvider;
  final List preservatedPostIds;
  final List likedPostIds;
  RecommenderShowPage(this.doc,this.recommendersProvider,this.preservatedPostIds,this.likedPostIds);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBackgroundColor,
        extendBodyBehindAppBar: false,
        
        body: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  padding: EdgeInsets.symmetric(
                    vertical: 20,
                    
                  ),
                  color: Colors.blue,
                  icon: Icon(Icons.keyboard_arrow_down),
                  onPressed: (){
                    Navigator.pop(context);
                  }, 
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  // margin: EdgeInsets.only(top: 100),
                  child: Column(
                    children: [
                      Center(
                        // image
                        child: Text(doc.id),
                      ),
                      Center(
                        child: Text(doc['title']),
                      ),
                      PostButtons(
                        recommendersProvider.currentUser!.uid,
                        doc,
                        preservatedPostIds,
                        likedPostIds
                      ),
                      AudioStateDesign(recommendersProvider,preservatedPostIds,likedPostIds),
                      Comments(recommendersProvider.currentSongDoc['postId'])
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}