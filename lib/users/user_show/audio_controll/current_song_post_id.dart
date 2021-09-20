import 'package:flutter/cupertino.dart';

import 'package:whisper/users/user_show/user_show_model.dart';
class CurrentSongPostId extends StatelessWidget {
  
  CurrentSongPostId(this.userShowProvider);
  final UserShowModel userShowProvider;
  @override  
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: userShowProvider.currentSongPostIdNotifier, 
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