import 'package:flutter/material.dart';

import 'package:whisper/preservations/preservations_model.dart';
import 'audio_progress_bar.dart';
import 'current_song_title.dart';
import 'audio_controll_buttons.dart';
import 'package:whisper/parts/posts/post_buttons/components/like_button.dart';

import 'package:whisper/constants/routes.dart' as routes;

class AudioWindow extends StatelessWidget {
  AudioWindow(this.preservationsProvider,this.preservatedPostIds,this.likedPostIds);
  final PreservationsModel preservationsProvider;
  final List preservatedPostIds;
  final List likedPostIds;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final audioWindowHeight = size.height * 0.12;
    return InkWell(
      onTap: () {
        
        routes.toPreservationsShowPage(context, preservationsProvider.currentSongDoc, preservationsProvider, preservatedPostIds, likedPostIds);
      },
      child: Container(
        height: audioWindowHeight,
        child: Column(
          children: [
            AudioProgressBar(preservationsProvider),
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
                      CurrentSongTitle(preservationsProvider),
                      Text(
                        '(${preservationsProvider.currentSongDoc.id})',
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      PlayButton(preservationsProvider),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          LikeButton(
                            preservationsProvider.currentUser!.uid,
                            preservationsProvider.currentSongDoc,
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