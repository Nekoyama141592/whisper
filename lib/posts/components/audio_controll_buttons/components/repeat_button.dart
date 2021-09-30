import 'package:flutter/material.dart';

import 'package:whisper/posts/notifiers/repeat_button_notifier.dart';

class RepeatButton extends StatelessWidget {
  
  RepeatButton(this.repeatButtonNotifier,this.onRepeatButtonPressed);
  final RepeatButtonNotifier repeatButtonNotifier;
  final void Function()? onRepeatButtonPressed;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<RepeatState>(
      valueListenable: repeatButtonNotifier,
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
          onPressed: onRepeatButtonPressed
        );
      },
    );
  }
}