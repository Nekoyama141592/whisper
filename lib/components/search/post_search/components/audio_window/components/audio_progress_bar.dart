// material
import 'package:flutter/cupertino.dart';
// packages
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
// notifiers
import 'package:whisper/posts/notifiers/progress_notifier.dart';

class AudioProgressBar extends StatelessWidget {
  
  const AudioProgressBar({
    Key? key,
    required this.progressNotifier,
    required this.seek
  }) : super(key: key);

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