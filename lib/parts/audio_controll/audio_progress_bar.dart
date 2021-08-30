import 'package:flutter/material.dart';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

import 'package:whisper/parts/posts/posts_model.dart';
import 'package:whisper/parts/posts/notifiers/progress_notifier.dart';

class AudioProgressBar extends StatelessWidget {
  const AudioProgressBar({
    Key? key,
    required PostsModel postsProvider,
  }) : _postsProvider = postsProvider, super(key: key);

  final PostsModel _postsProvider;

  @override  
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ProgressBarState>(
      valueListenable: _postsProvider.progressNotifier,
      builder: (_, value, __) {
        return ProgressBar(
          progress: value.current,
          buffered: value.buffered,
          total: value.total,
          onSeek: _postsProvider.seek,
        );
      },
    );
  }
}