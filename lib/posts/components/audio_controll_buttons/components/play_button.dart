import 'package:flutter/material.dart';

import 'package:whisper/posts/notifiers/play_button_notifier.dart';

class PlayButton extends StatelessWidget {
  PlayButton(this.playButtonNotifier,this.play,this.pause);
  final PlayButtonNotifier playButtonNotifier;
  final void Function()? play;
  final void Function()? pause;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ButtonState>(
      valueListenable: playButtonNotifier,
      builder: (_, value, __){
        switch (value) {
          case ButtonState.loading:
            return Container(
              margin: EdgeInsets.all(8.0),
              width: 32.0,
              height: 32.0,
              child: CircularProgressIndicator(),
            );
          case ButtonState.paused:
            return IconButton(
              icon: Icon(Icons.play_arrow),
              iconSize: 32.0,
              onPressed: play
            );
          case ButtonState.playing:
            return IconButton(
              icon: Icon(Icons.pause),
              iconSize: 32.0,
              onPressed: pause
            );
        }
      },
    );
  }
}