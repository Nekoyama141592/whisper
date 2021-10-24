// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// model
import 'package:whisper/posts/components/post_buttons/posts_futures.dart';

class LikeButton extends ConsumerWidget {
  
  const LikeButton({
    required this.currentUserDoc,
    required this.currentSongDoc,
    required this.likedPostIds,
    required this.likes
  });
  
  final DocumentSnapshot currentUserDoc;
  final DocumentSnapshot currentSongDoc;
  final List likedPostIds;
  final List likes;
  
  @override  
  Widget build(BuildContext context, ScopedReader watch) {
    final postFuturesModel = watch(postsFeaturesProvider);
    
        final List<dynamic> likes = currentSongDoc['likes'];
        final likesCount = likes.length;
        final plusOneCount = likes.length + 1;
        return
        Container(
          child: likedPostIds.contains(currentSongDoc['postId']) ?
          Row(
            children: [
              InkWell(
                child: Icon(
                  Icons.favorite,
                  color: Colors.red
                ),
                onTap: () async {
                  await postFuturesModel.unlike(likedPostIds, currentUserDoc, currentSongDoc, likes);
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
                  await postFuturesModel.like(likedPostIds, currentUserDoc, currentSongDoc, likes);
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