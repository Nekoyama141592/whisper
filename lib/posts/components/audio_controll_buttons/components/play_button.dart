// material
import 'package:flutter/material.dart';
// notifier
import 'package:whisper/posts/notifiers/play_button_notifier.dart';

class PlayButton extends StatelessWidget {
  
  const PlayButton({
    required this.playButtonNotifier,
    required this.play,
    required this.pause
  });
  
  final PlayButtonNotifier playButtonNotifier;
  final void Function()? play;
  final void Function()? pause;

  @override
  Widget build(BuildContext context) {
    final iconSize = 32.0;
    return ValueListenableBuilder<ButtonState>(
      valueListenable: playButtonNotifier,
      builder: (_, value, __){
        switch (value) {
          case ButtonState.loading:
            return Container(
              margin: EdgeInsets.all(8.0),
              width: iconSize,
              height: iconSize,
              child: CircularProgressIndicator(),
            );
          case ButtonState.paused:
            return IconButton(
              icon: Icon(Icons.play_arrow),
              iconSize: iconSize,
              onPressed: play
            );
          case ButtonState.playing:
            return IconButton(
              icon: Icon(Icons.pause),
              iconSize: iconSize,
              onPressed: pause
            );
        }
      },
    );
  }
}