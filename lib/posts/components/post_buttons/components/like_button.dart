// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/constants/doubles.dart';
// constants
import 'package:whisper/constants/enums.dart';
import 'package:whisper/constants/ints.dart';
// domain
import 'package:whisper/domain/post/post.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/posts/components/post_buttons/post_futures.dart';

class LikeButton extends ConsumerWidget {
  
  const LikeButton({
    required this.postType,
    required this.whisperPost,
    required this.mainModel
  });
  
  final PostType postType;
  final Post whisperPost;
  final MainModel mainModel;
  
  @override  
  Widget build(BuildContext context, WidgetRef ref) {
    final postFuturesModel = ref.watch(postsFeaturesProvider);
    if (postType != PostType.postSearch) {

      final likeCount = whisperPost.likeCount;
      final plusOneCount = likeCount + plusOne;
      return
      Container(
        child: mainModel.likePostIds.contains(whisperPost.postId) ?
        Row(
          children: [
            InkWell(
              child: Icon(
                Icons.favorite,
                color: Colors.red
              ),
              onTap: () async {
                await postFuturesModel.unlike(whisperPost: whisperPost, mainModel: mainModel);
              },
            ),
            SizedBox(width: defaultPadding(context: context)/2.0),
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
                await postFuturesModel.like(whisperPost: whisperPost, mainModel: mainModel);
              },
            ),
            SizedBox(width: defaultPadding(context: context)/2.0),
            Text(
              likeCount >= 10000 ? (likeCount/1000.floor()/10).toString() + '万' :  likeCount.toString(),
            )
          ],
        ),
        
      );
    } else {
      return Container(
        child: mainModel.likePostIds.contains(whisperPost.postId) ?
        InkWell(
          child: Icon(
            Icons.favorite,
            color: Colors.red
          ),
          onTap: () async {
            await postFuturesModel.unlike(whisperPost: whisperPost, mainModel: mainModel);
          },
        ) 
        : InkWell(
          child: Icon(Icons.favorite),
          onTap: () async {
            await postFuturesModel.like(whisperPost: whisperPost, mainModel: mainModel);
          },
        ),
        
      );
    }
  }
}