import 'package:flutter/cupertino.dart';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

import 'package:whisper/posts/notifiers/progress_notifier.dart';

class AudioProgressBar extends StatelessWidget {
  
  AudioProgressBar(this.progressNotifier,this.seek);
  final ProgressNotifier progressNotifier;
  final void Function(Duration)? seek;
  @override  
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ProgressBarState>(
      valueListenable: progressNotifier,
      builder: (_, value, __) {
        return ProgressBar(
          progress: value.current,
          buffered: value.buffered,
          total: value.total,
          onSeek: seek,
       );
      },
    );
  }
}