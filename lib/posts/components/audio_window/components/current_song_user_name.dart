// material
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// constants
import 'package:whisper/constants/strings.dart';

class CurrentSongUserName extends StatelessWidget {
  
  const CurrentSongUserName({
    Key? key,
    required this.currentSongMapNotifier
  }) : super(key: key);

  final ValueNotifier<Map<String,dynamic>> currentSongMapNotifier;
  
  @override
  
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Map<String,dynamic>>(
      valueListenable: currentSongMapNotifier, 
      builder: (_, currentSongMap, __) {
        return Text(
          currentSongMap[userNameKey], 
          style: TextStyle(
            fontSize: 20
          ),
          overflow: TextOverflow.ellipsis,
        );
      }
    );
  }
}