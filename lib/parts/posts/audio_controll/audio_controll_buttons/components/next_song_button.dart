import 'package:flutter/material.dart';

class NextSongButton extends StatelessWidget {
  NextSongButton(this.isLastSongNotifier,this.onNextSongButtonPressed);
  final ValueNotifier<bool> isLastSongNotifier;
  final void Function()? onNextSongButtonPressed;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isLastSongNotifier,
      builder: (_, isLast, __) {
        return IconButton(
          icon: Icon(Icons.skip_next),
          onPressed: isLast ?
          null
          : onNextSongButtonPressed
        );
      },
    );
  }
}
