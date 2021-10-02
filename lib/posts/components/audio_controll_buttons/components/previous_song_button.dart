// material
import 'package:flutter/material.dart';

class PreviousSongButton extends StatelessWidget {
  
  const PreviousSongButton({
    Key? key,
    required this.isFirstSongNotifier,
    required this.onPreviousSongButtonPressed
  }) : super(key: key);

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
