import 'package:flutter/material.dart';

import 'package:whisper/parts/posts/feeds/feeds_model.dart';

import 'audio_progress_bar.dart';
import 'current_song_title.dart';
import 'audio_controll_buttons.dart';
import 'package:whisper/parts/posts/post_buttons/components/like_button.dart';


import 'package:whisper/constants/routes.dart' as routes;

class AudioWindow extends StatelessWidget {
  AudioWindow(this.feedsProvider,this.preservatedPostIds,this.likedPostIds);
  final FeedsModel feedsProvider;
  final List preservatedPostIds;
  final List likedPostIds;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final audioWindowHeight = size.height * 0.12;
    return InkWell(
      onTap: () {
        // feeds_show
        routes.toFeedShowPage(context, feedsProvider.currentSongDoc, feedsProvider,preservatedPostIds,likedPostIds);
      },
      child: Container(
        height: audioWindowHeight,
        child: Column(
          children: [
            AudioProgressBar(feedsProvider),
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
                      CurrentSongTitle(feedsProvider),
                      Text(
                        '(${feedsProvider.currentSongDoc.id})',
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      PlayButton(feedsProvider),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          LikeButton(
                            feedsProvider.currentUserDoc,
                            feedsProvider.currentSongDoc,
                            likedPostIds
                          ),
                          
                        ],
                      ),
                      
                    ],
                  ),
                  
                )
              ],
            ),
           
          ],
        ),
      ),
    );
  }
}