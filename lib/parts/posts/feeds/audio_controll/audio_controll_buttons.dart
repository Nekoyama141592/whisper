import 'package:flutter/material.dart';

import 'package:whisper/parts/posts/notifiers/play_button_notifier.dart';
import 'package:whisper/parts/posts/notifiers/repeat_button_notifier.dart';

import 'package:whisper/parts/posts/posts_model.dart';

class AudioControllButtons extends StatelessWidget {
  const AudioControllButtons({
    Key? key,
    required PostsModel postsProvider,
  }) : _postsProvider = postsProvider, super(key: key);

  final PostsModel _postsProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          RepeatButton(postsProvider: _postsProvider),
          PreviousSongButton(postsProvider: _postsProvider),
          PlayButton(postsProvider: _postsProvider),
          NextSongButton(postsProvider: _postsProvider)
        ],
      ),
    );
  }
}

class NextSongButton extends StatelessWidget {
  const NextSongButton({
    Key? key,
    required PostsModel postsProvider,
  }) : _postsProvider = postsProvider, super(key: key);

  final PostsModel _postsProvider;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _postsProvider.isLastSongNotifier,
      builder: (_, isLast, __) {
        return IconButton(
          icon: Icon(Icons.skip_next),
          onPressed: isLast ?
          null
          : () {
            _postsProvider.onNextSongButtonPressed(_postsProvider.feedsAudioPlayer);
          }, 
        );
      },
    );
  }
}

class PlayButton extends StatelessWidget {
  const PlayButton({
    Key? key,
    required PostsModel postsProvider,
  }) : _postsProvider = postsProvider, super(key: key);

  final PostsModel _postsProvider;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ButtonState>(
      valueListenable: _postsProvider.playButtonNotifier,
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
                _postsProvider.play(_postsProvider.feedsAudioPlayer);
              },
            );
          case ButtonState.playing:
            return IconButton(
              icon: Icon(Icons.pause),
              iconSize: 32.0,
              onPressed: () {
                _postsProvider.pause(_postsProvider.feedsAudioPlayer);
              },
            );
        }
      },
    );
  }
}

class PreviousSongButton extends StatelessWidget {
  const PreviousSongButton({
    Key? key,
    required PostsModel postsProvider,
  }) : _postsProvider = postsProvider, super(key: key);

  final PostsModel _postsProvider;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _postsProvider.isFirstSongNotifier,
      builder: (_, isFirst, __){
        return IconButton(
          onPressed: (isFirst) ? 
          null
          : (){
            _postsProvider.onPreviousSongButtonPressed(_postsProvider.feedsAudioPlayer);
          },
          icon: Icon(Icons.skip_previous)
        );
      },
    );
  }
}

class RepeatButton extends StatelessWidget {
  const RepeatButton({
    Key? key,
    required PostsModel postsProvider,
  }) : _postsProvider = postsProvider, super(key: key);

  final PostsModel _postsProvider;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<RepeatState>(
      valueListenable: _postsProvider.repeatButtonNotifier,
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
            _postsProvider.onRepeatButtonPressed(_postsProvider.feedsAudioPlayer);
          }, 
        );
      },
    );
  }
}

