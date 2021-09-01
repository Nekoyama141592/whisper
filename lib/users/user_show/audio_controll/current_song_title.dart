import 'package:flutter/material.dart';
import 'package:whisper/users/user_show/user_show_model.dart';

class CurrentSongTitle extends StatelessWidget {
  
  CurrentSongTitle(this.userShowProvider);
  final UserShowModel userShowProvider;
  @override  
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: userShowProvider.currentSongTitleNotifier, 
      builder: (_, title, __) {
        return Text(
          title, 
          style: TextStyle(fontSize: 20),
          overflow: TextOverflow.ellipsis,
        );
      }
    );
  }
}