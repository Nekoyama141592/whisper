import 'package:flutter/material.dart';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:whisper/parts/posts/audio_controll/notifiers/progress_notifier.dart';

import 'package:whisper/parts/add_post/add_post_model.dart';

class AudioProgressbar extends StatelessWidget {
  
  AudioProgressbar(this.addPostProvider);
  final AddPostModel addPostProvider;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ProgressBarState>(
      valueListenable: addPostProvider.progressNotifier,
      builder: (_, value, __) {
        return ProgressBar(
          progress: value.current,
          buffered: value.buffered,
          total: value.total,
          onSeek: addPostProvider.seek,
       );
      },
    );
  }
}