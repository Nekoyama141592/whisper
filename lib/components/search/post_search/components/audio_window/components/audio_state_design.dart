// material
import 'package:flutter/material.dart';
// components
import 'package:whisper/posts/components/audio_controll_buttons/audio_controll_buttons.dart';
import 'audio_progress_bar.dart';
import 'current_song_title.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/components/search/post_search/post_search_model.dart';

class AudioStateDesign extends StatelessWidget {
  
  const AudioStateDesign({
    Key? key,
    required this.mainModel,
    required this.postSearchModel
  }) : super(key: key);
  
  
  final PostSearchModel postSearchModel;
  final MainModel mainModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      child: Column(
        children: [
          AudioControllButtons(
            repeatButtonNotifier: postSearchModel.repeatButtonNotifier, 
            onRepeatButtonPressed: postSearchModel.onRepeatButtonPressed, 
            isFirstSongNotifier: postSearchModel.isFirstSongNotifier, 
            onPreviousSongButtonPressed: () { postSearchModel.onPreviousSongButtonPressed(); }, 
            playButtonNotifier: postSearchModel.playButtonNotifier, 
            play: () {
              postSearchModel.play(mainModel.readPostIds, mainModel.readPosts, mainModel.currentUserDoc);
            }, 
            pause: () {
              postSearchModel.pause();
            }, 
            isLastSongNotifier: postSearchModel.isLastSongNotifier, 
            onNextSongButtonPressed: () { postSearchModel.onNextSongButtonPressed(); }
          ),
          AudioProgressBar(progressNotifier: postSearchModel.progressNotifier, seek: postSearchModel.seek),
          CurrentSongTitle(currentSongMapNotifier: postSearchModel.currentSongMapNotifier)
        ],
      ),
    );
  }
}