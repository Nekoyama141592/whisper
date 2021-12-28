// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
// components
import 'package:whisper/details/user_image.dart';
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
    required this.currentUserDoc,
    required this.route
  }) : super(key: key);
  
  final ProgressNotifier progressNotifier;
  final PlayButtonNotifier playButtonNotifier;
  final void Function(Duration) seek;
  final void Function()? play;
  final void Function()? pause;
  final Widget title;
  final DocumentSnapshot currentUserDoc;
  final void Function()? route;

  Widget build(BuildContext context) {
    
    final size = MediaQuery.of(context).size;
    final audioWindowHeight = size.height * 0.15;
    final fontSize = 20.0;

    return Container(
      height: audioWindowHeight,
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
                  child: UserImage(userImageURL: currentUserDoc['imageURL'],length: 60.0,padding: 5.0,)
                ),
                Container(
                  width: size.width * 0.55,
                  child: Column(
                    children: [
                      Text(
                        currentUserDoc['userName'],
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
