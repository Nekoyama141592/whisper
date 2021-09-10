import 'package:flutter/material.dart';

import 'package:whisper/parts/posts/notifiers/play_button_notifier.dart';
import 'package:whisper/add_post/add_post_model.dart';

class PlayButton extends StatelessWidget {
  PlayButton(this.addPostProvider);
  final AddPostModel addPostProvider;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ButtonState>(
      valueListenable: addPostProvider.playButtonNotifier,
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
              onPressed: (){
                addPostProvider.play();
              },
            );
          case ButtonState.playing:
            return IconButton(
              icon: Icon(Icons.pause),
              iconSize: 32.0,
              onPressed: () {
                addPostProvider.pause();
              },
            );
        }
      },
    );
  }
}
