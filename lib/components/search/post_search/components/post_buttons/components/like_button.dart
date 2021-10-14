// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/components/search/post_search/components/post_buttons/posts_futures.dart';

class LikeButton extends ConsumerWidget {
  
  const LikeButton({
    required this.currentUserDoc,
    required this.currentSongMapNotifier,
    required this.mainModel
  });
  
  final DocumentSnapshot currentUserDoc;
  final ValueNotifier<Map<String,dynamic>> currentSongMapNotifier;
  final MainModel mainModel;
  @override  
  Widget build(BuildContext context, ScopedReader watch) {
    final postFuturesModel = watch(postsFeaturesProvider);
    return 
    ValueListenableBuilder<Map<String,dynamic>>(
      valueListenable: currentSongMapNotifier, 
      builder: (_, currentSongMap, __) {
        final List<dynamic> likes = currentSongMap['likes'];
        final likesCount = likes.length;
        final plusOneCount = likes.length + 1;
        return
        mainModel.likedPostIds.contains(currentSongMap['postId']) ?
        Row(
          children: [
            InkWell(
              child: Icon(
                Icons.favorite,
                color: Colors.red
              ),
              onTap: () async {
                mainModel.likedPostIds.remove(currentSongMap['postId']);
                postFuturesModel.reload();
                await postFuturesModel.unlike(currentUserDoc, currentSongMap, mainModel.likes);
              },
            ),
            SizedBox(width: 5.0),
            Text(
              plusOneCount >= 10000 ? (plusOneCount/1000.floor()/10).toString() + '万' :  plusOneCount.toString(),
              style: TextStyle(color: Colors.red)
            )
          ],
        ) : Row(
          children: [
            InkWell(
              child: Icon(Icons.favorite),
              onTap: () async {
                mainModel.likedPostIds.add(currentSongMap['postId']);
                postFuturesModel.reload();
                await postFuturesModel.like(currentUserDoc, currentSongMap,mainModel.likes);
              },
            ),
            SizedBox(width: 5.0),
            Text(
              likesCount >= 10000 ? (likesCount/1000.floor()/10).toString() + '万' :  likesCount.toString(),
            )
          ],
        );
      }
    );
  }
}