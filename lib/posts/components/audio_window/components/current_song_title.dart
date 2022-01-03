// material
import 'package:flutter/cupertino.dart';
// constants
import 'package:whisper/constants/strings.dart';
class CurrentSongTitle extends StatelessWidget {
  
  const CurrentSongTitle({
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
          currentSongMap[titleKey], 
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
          overflow: TextOverflow.ellipsis,
        );
      }
    );
  }
}