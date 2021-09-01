import 'package:flutter/material.dart';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

import 'package:whisper/parts/posts/recommenders/recommenders_model.dart';
import 'package:whisper/parts/posts/notifiers/progress_notifier.dart';

class AudioProgressBar extends StatelessWidget {
  AudioProgressBar(this.recommendersProvider);
  final RecommendersModel recommendersProvider;
  @override  
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ProgressBarState>(
      valueListenable: recommendersProvider.progressNotifier,
      builder: (_, value, __) {
        return ProgressBar(
          progress: value.current,
          buffered: value.buffered,
          total: value.total,
          onSeek: recommendersProvider.seek,
        );
      },
    );
  }
}