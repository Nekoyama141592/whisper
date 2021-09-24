import 'package:flutter/cupertino.dart';

class CurrentSongTitle extends StatelessWidget {
  
  CurrentSongTitle(this.currentSongTitleNotifier);
  final ValueNotifier<String> currentSongTitleNotifier;
  @override  
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: currentSongTitleNotifier, 
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