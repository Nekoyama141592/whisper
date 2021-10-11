// material
import 'package:flutter/material.dart';
// components
import 'components/audio_progress_bar.dart';
import 'components/current_song_user_name.dart';
import 'components/current_song_title.dart';
import 'package:whisper/posts/components/audio_controll_buttons/components/play_button.dart';
import 'package:whisper/components/search/post_search/components/audio_window/components/audio_window_user_image.dart';
// other_pages
import 'package:whisper/components/search/post_search/components/other_pages/post_show/post_show_page.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/components/search/post_search/post_search_model.dart';

class AudioWindow extends StatelessWidget {
  
  AudioWindow({
    Key? key,
    required this.mainModel,
    required this.postSearchModel
  }) : super(key: key);
  
  final MainModel mainModel;
  final PostSearchModel postSearchModel;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final audioWindowHeight = size.height * 0.12;
    return InkWell(
      onTap: () { Navigator.push(context, MaterialPageRoute(builder: (context) => PostShowPage(mainModel: mainModel, postSearchModel: postSearchModel) ) ); },
      child: Container(
        height: audioWindowHeight,
        child: Column(
          children: [
            AudioProgressBar(progressNotifier: postSearchModel.progressNotifier, seek: postSearchModel.seek),
            Row(
              children: [
                AudioWindowUserImage(currentSongMapNotifier: postSearchModel.currentSongMapNotifier,mainModel: mainModel,),
                Container(
                  width: size.width * 0.55,
                  child: Column(
                    children: [
                      CurrentSongUserName(currentSongMapNotifier: postSearchModel.currentSongMapNotifier),
                      CurrentSongTitle(currentSongMapNotifier: postSearchModel.currentSongMapNotifier)
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      PlayButton(playButtonNotifier: postSearchModel.playButtonNotifier, play: () { postSearchModel.play(mainModel.readPostIds, mainModel.readPosts, mainModel.currentUserDoc); }, pause: () { postSearchModel.pause(); }),
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
