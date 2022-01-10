// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/strings.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/posts/components/post_buttons/post_futures.dart';

class LikeButton extends ConsumerWidget {
  
  const LikeButton({
    required this.currentSongMap,
    required this.mainModel
  });
  
  final Map<String,dynamic> currentSongMap;
  final MainModel mainModel;
  
  @override  
  Widget build(BuildContext context, ScopedReader watch) {
    final postFuturesModel = watch(postsFeaturesProvider);
    
    List<dynamic> likesOfCurrentSong = currentSongMap[likesKey];
    likesOfCurrentSong.removeWhere((likeOfCurrentSong) => likeOfCurrentSong[uidKey] == mainModel.currentWhisperUser.uid );
    final likesCount = likesOfCurrentSong.length;
    final plusOneCount = likesOfCurrentSong.length + 1;
    return
    Container(
      child: mainModel.likePostIds.contains(currentSongMap[postIdKey]) ?
      Row(
        children: [
          InkWell(
            child: Icon(
              Icons.favorite,
              color: Colors.red
            ),
            onTap: () async {
              await postFuturesModel.unlike(currentSongMap: currentSongMap, mainModel: mainModel);
            },
          ),
          SizedBox(width: 5.0),
          Text(
            plusOneCount >= 10000 ? (plusOneCount/1000.floor()/10).toString() + '万' :  plusOneCount.toString(),
            style: TextStyle(color: Colors.red)
          )
        ],
      ) 
      : Row(
        children: [
          InkWell(
            child: Icon(Icons.favorite),
            onTap: () async {
              await postFuturesModel.like(currentSongMap: currentSongMap, mainModel: mainModel);
            },
          ),
          SizedBox(width: 5.0),
          Text(
            likesCount >= 10000 ? (likesCount/1000.floor()/10).toString() + '万' :  likesCount.toString(),
          )
        ],
      ),
      
    );
      
  }
}