// material
import 'package:flutter/material.dart';
import 'package:whisper/constants/doubles.dart';
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
    final iconSize = defaultPadding(context: context) * 2.0;
    return ValueListenableBuilder<ButtonState>(
      valueListenable: playButtonNotifier,
      builder: (_, value, __){
        switch (value) {
          case ButtonState.loading:
            return Container(
              margin: EdgeInsets.all(defaultPadding(context: context)),
              width: iconSize,
              height: iconSize,
              child: CircularProgressIndicator(),
            );
          case ButtonState.paused:
            return IconButton(
              icon: Icon(Icons.play_arrow),
              iconSize: iconSize,
              onPressed: play,
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