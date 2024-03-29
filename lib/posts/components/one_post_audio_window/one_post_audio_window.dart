// material
import 'package:flutter/material.dart';
import 'package:whisper/constants/doubles.dart';
// components
import 'package:whisper/details/user_image.dart';
import 'package:whisper/main_model.dart';
import 'package:whisper/posts/components/audio_window/components/audio_progress_bar.dart';
import 'package:whisper/posts/components/audio_controll_buttons/components/play_button.dart';
// notifiers
import 'package:whisper/posts/notifiers/progress_notifier.dart';
import 'package:whisper/posts/notifiers/play_button_notifier.dart';

class OnePostAudioWindow extends StatelessWidget {
  
  const OnePostAudioWindow({
    Key? key,
    required this.progressNotifier,
    required this.playButtonNotifier,
    required this.seek,
    required this.play,
    required this.pause,
    required this.title,
    required this.mainModel,
    required this.route,
  }) : super(key: key);
  
  final ProgressNotifier progressNotifier;
  final PlayButtonNotifier playButtonNotifier;
  final void Function(Duration) seek;
  final void Function()? play;
  final void Function()? pause;
  final Widget title;
  final MainModel mainModel;
  final void Function()? route;

  Widget build(BuildContext context) {
    
    final size = MediaQuery.of(context).size;
    final fontSize = defaultHeaderTextSize(context: context);

    return Container(
      child: InkWell(
        onTap: route,
        child: Column(
          children: [
            AudioProgressBar(progressNotifier: progressNotifier, seek: seek),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.03,
                  ),
                  child: UserImage(userImageURL: mainModel.currentWhisperUser.userImageURL,length: defaultHeaderTextSize(context: context) * 1.5 ,padding: 0,uid: mainModel.currentWhisperUser.uid,mainModel: mainModel, )
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      children: [
                        Text(
                          mainModel.currentWhisperUser.userName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: fontSize
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        title
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      PlayButton(playButtonNotifier: playButtonNotifier, play: play, pause: pause)
                    ],
                  ),
                )
              ],
            )
          ]
        ),
      ),
    );
  }
}
