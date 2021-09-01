import 'package:flutter/material.dart';

import 'package:whisper/parts/posts/recommenders/recommenders_model.dart';

import 'audio_progress_bar.dart';
import 'current_song_title.dart';
import 'audio_controll_buttons.dart';
import 'package:whisper/parts/posts/post_buttons/components/like_button.dart';

import 'package:whisper/constants/routes.dart' as routes;

class AudioWindow extends StatelessWidget {
  AudioWindow(this.recommendersProvider,this.preservatedPostIds,this.likedPostIds);
  final RecommendersModel recommendersProvider;
  final List preservatedPostIds;
  final List likedPostIds;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final audioWindowHeight = size.height * 0.12;
    return InkWell(
      onTap: () {
        
        routes.toRecommenderShowPage(context, recommendersProvider.currentSongDoc, recommendersProvider, preservatedPostIds, likedPostIds);
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
                      Text(
                        '(${recommendersProvider.currentSongDoc.id})',
                        overflow: TextOverflow.ellipsis,
                      )
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
                            recommendersProvider.currentUser!.uid,
                            recommendersProvider.currentSongDoc,
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