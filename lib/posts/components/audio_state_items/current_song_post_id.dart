import 'package:flutter/cupertino.dart';

class CurrentSongPostId extends StatelessWidget {
  
  CurrentSongPostId(this.currentSongPostIdNotifier);
  final ValueNotifier<String> currentSongPostIdNotifier;
  @override  
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: currentSongPostIdNotifier, 
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