import 'package:flutter/material.dart';

class PreviousSongButton extends StatelessWidget {
  
  PreviousSongButton(this.isFirstSongNotifier,this.onPreviousSongButtonPressed);
  final ValueNotifier<bool> isFirstSongNotifier;
  final void Function()? onPreviousSongButtonPressed;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isFirstSongNotifier,
      builder: (_, isFirst, __){
        return IconButton(
          onPressed: (isFirst) ? 
          null
          : onPreviousSongButtonPressed,
          icon: Icon(Icons.skip_previous)
        );
      },
    );
  }
}
