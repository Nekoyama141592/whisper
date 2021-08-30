import 'package:flutter/material.dart';
import 'package:whisper/preservations/preservations_model.dart';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:whisper/parts/posts/notifiers/progress_notifier.dart';
class AudioProgressBar extends StatelessWidget {
  
  AudioProgressBar(this.preservationsProvider);
  final PreservationsModel preservationsProvider;
  @override  
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ProgressBarState>(
      valueListenable: preservationsProvider.progressNotifier,
      builder: (_, value, __) {
        return ProgressBar(
          progress: value.current,
          buffered: value.buffered,
          total: value.total,
          onSeek: preservationsProvider.seek,
        );
      },
    );
  }
}