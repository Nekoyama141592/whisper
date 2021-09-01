import 'package:flutter/material.dart';

import 'package:whisper/parts/posts/notifiers/play_button_notifier.dart';
import 'package:whisper/parts/posts/notifiers/repeat_button_notifier.dart';

import 'package:whisper/users/user_show/user_show_model.dart';

class AudioControllButtons extends StatelessWidget {
  
  AudioControllButtons(this.userShowProvider);
  final UserShowModel userShowProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          RepeatButton(userShowProvider),
          PreviousSongButton(userShowProvider),
          PlayButton(userShowProvider),
          NextSongButton(userShowProvider)
        ],
      ),
    );
  }
}

class NextSongButton extends StatelessWidget {
  
   
  NextSongButton(this.userShowProvider);
  final UserShowModel userShowProvider;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: userShowProvider.isLastSongNotifier,
      builder: (_, isLast, __) {
        return IconButton(
          icon: Icon(Icons.skip_next),
          onPressed: isLast ?
          null
          : () {
            userShowProvider.onNextSongButtonPressed();
          }, 
        );
      },
    );
  }
}

class PlayButton extends StatelessWidget {
  
  PlayButton(this.userShowProvider);
  final UserShowModel userShowProvider;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ButtonState>(
      valueListenable: userShowProvider.playButtonNotifier,
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
              onPressed: userShowProvider.play,
            );
          case ButtonState.playing:
            return IconButton(
              icon: Icon(Icons.pause),
              iconSize: 32.0,
              onPressed: userShowProvider.pause,
            );
        }
      },
    );
  }
}

class PreviousSongButton extends StatelessWidget {
  
  PreviousSongButton(this.userShowProvider);
  final UserShowModel userShowProvider;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: userShowProvider.isFirstSongNotifier,
      builder: (_, isFirst, __){
        return IconButton(
          onPressed: (isFirst) ? 
          null
          : (){
            userShowProvider.onPreviousSongButtonPressed();
          },
          icon: Icon(Icons.skip_previous)
        );
      },
    );
  }
}

class RepeatButton extends StatelessWidget {
  
  RepeatButton(this.userShowProvider);
  final UserShowModel userShowProvider;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<RepeatState>(
      valueListenable: userShowProvider.repeatButtonNotifier,
      builder: (context, value, child) {
        Icon icon;
        switch (value) {
          case RepeatState.off:
            icon = Icon(Icons.repeat, color: Colors.grey);
            break;
          case RepeatState.repeatSong:
            icon = Icon(Icons.repeat_one);
            break;
          case RepeatState.repeatPlaylist:
            icon = Icon(Icons.repeat);
            break;
        }
        return IconButton(
          icon: icon,
          onPressed: () {
            userShowProvider.onRepeatButtonPressed();
          }, 
        );
      },
    );
  }
}

