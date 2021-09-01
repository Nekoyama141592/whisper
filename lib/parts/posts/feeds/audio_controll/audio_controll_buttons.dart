import 'package:flutter/material.dart';

import 'package:whisper/parts/posts/notifiers/play_button_notifier.dart';
import 'package:whisper/parts/posts/notifiers/repeat_button_notifier.dart';

import 'package:whisper/parts/posts/feeds/feeds_model.dart';

class AudioControllButtons extends StatelessWidget {
  
  AudioControllButtons(this.feedsProvider);
  final FeedsModel feedsProvider;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          RepeatButton(feedsProvider),
          PreviousSongButton(feedsProvider),
          PlayButton(feedsProvider),
          NextSongButton(feedsProvider)
        ],
      ),
    );
  }
}

class NextSongButton extends StatelessWidget {
  NextSongButton(this.feedsProvider);
  final FeedsModel feedsProvider;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: feedsProvider.isLastSongNotifier,
      builder: (_, isLast, __) {
        return IconButton(
          icon: Icon(Icons.skip_next),
          onPressed: isLast ?
          null
          : () {
            feedsProvider.onNextSongButtonPressed();
          }, 
        );
      },
    );
  }
}

class PlayButton extends StatelessWidget {
  PlayButton(this.feedsProvider);
  final FeedsModel feedsProvider;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ButtonState>(
      valueListenable: feedsProvider.playButtonNotifier,
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
                feedsProvider.play();
              },
            );
          case ButtonState.playing:
            return IconButton(
              icon: Icon(Icons.pause),
              iconSize: 32.0,
              onPressed: () {
                feedsProvider.pause();
              },
            );
        }
      },
    );
  }
}

class PreviousSongButton extends StatelessWidget {
  
  PreviousSongButton(this.feedsProvider);
  final FeedsModel feedsProvider;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: feedsProvider.isFirstSongNotifier,
      builder: (_, isFirst, __){
        return IconButton(
          onPressed: (isFirst) ? 
          null
          : (){
            feedsProvider.onPreviousSongButtonPressed();
          },
          icon: Icon(Icons.skip_previous)
        );
      },
    );
  }
}

class RepeatButton extends StatelessWidget {
  
  RepeatButton(this.feedsProvider);
  final FeedsModel feedsProvider;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<RepeatState>(
      valueListenable: feedsProvider.repeatButtonNotifier,
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
            feedsProvider.onRepeatButtonPressed();
          }, 
        );
      },
    );
  }
}

