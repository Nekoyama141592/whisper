// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/enums.dart';
import 'package:whisper/constants/ints.dart';
import 'package:whisper/constants/strings.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/posts/components/post_buttons/post_futures.dart';

class LikeButton extends ConsumerWidget {
  
  const LikeButton({
    required this.postType,
    required this.currentSongMap,
    required this.mainModel
  });
  
  final PostType postType;
  final Map<String,dynamic> currentSongMap;
  final MainModel mainModel;
  
  @override  
  Widget build(BuildContext context, ScopedReader watch) {
    final postFuturesModel = watch(postsFeaturesProvider);
    if (postType != PostType.postSearch) {

      final likeCount = currentSongMap[likeCountKey];
      final plusOneCount = likeCount + plusOne;
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
              likeCount >= 10000 ? (likeCount/1000.floor()/10).toString() + '万' :  likeCount.toString(),
            )
          ],
        ),
        
      );
    } else {
      return Container(
        child: mainModel.likePostIds.contains(currentSongMap[postIdKey]) ?
        InkWell(
          child: Icon(
            Icons.favorite,
            color: Colors.red
          ),
          onTap: () async {
            await postFuturesModel.unlike(currentSongMap: currentSongMap, mainModel: mainModel);
          },
        ) 
        : InkWell(
          child: Icon(Icons.favorite),
          onTap: () async {
            await postFuturesModel.like(currentSongMap: currentSongMap, mainModel: mainModel);
          },
        ),
        
      );
    }
  }
}