import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:whisper/parts/posts/recommenders/recommenders_model.dart';

import 'audio_progress_bar.dart';
import 'current_song_title.dart';
import 'audio_controll_buttons.dart';
import 'package:whisper/parts/posts/post_buttons/components/like_button.dart';

import 'package:whisper/constants/routes.dart' as routes;
import 'package:whisper/parts/posts/recommenders/audio_controll/current_song_post_id.dart';
class AudioWindow extends StatelessWidget {
  AudioWindow(this.currentUserDoc,this.recommendersProvider,this.preservatedPostIds,this.likedPostIds);
  
  final DocumentSnapshot currentUserDoc;
  final RecommendersModel recommendersProvider;
  final List preservatedPostIds;
  final List likedPostIds;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final audioWindowHeight = size.height * 0.12;
    return InkWell(
      onTap: () {
        
        routes.toRecommenderShowPage(context,currentUserDoc, recommendersProvider, preservatedPostIds, likedPostIds);
      },
      child: Container(
        height: audioWindowHeight,
        child: Column(
          children: [
            AudioProgressBar(recommendersProvider),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.03,
                  ),
                  child: CircleAvatar(
                    radius: 20,
                    foregroundColor: Colors.blue,
                  ),
                ),
                Container(
                  width: size.width * 0.55,
                  child: Column(
                    children: [
                      CurrentSongTitle(recommendersProvider),
                      CurrentSongPostId(recommendersProvider)
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      PlayButton(recommendersProvider),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          LikeButton(
                            currentUserDoc,
                            recommendersProvider.currentSongPostIdNotifier.value,
                            likedPostIds
                          ),
                          
                        ],
                      ),
                      
                    ],
                  ),
                  
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}