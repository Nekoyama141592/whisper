// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/constants/doubles.dart';
// constants
import 'package:whisper/constants/enums.dart';
import 'package:whisper/constants/strings.dart';
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
              onTap: () async => await postFuturesModel.unlike(whisperPost: whisperPost, mainModel: mainModel)
            ),
            SizedBox(width: defaultPadding(context: context)/2.0),
            Text(
              returnJaInt(count: likeCount),
              style: TextStyle(color: Colors.red)
            )
          ],
        ) 
        : Row(
          children: [
            InkWell(
              child: Icon(Icons.favorite),
              onTap: () async => await postFuturesModel.like(whisperPost: whisperPost, mainModel: mainModel)
            ),
            SizedBox(width: defaultPadding(context: context)/2.0),
            Text(
              returnJaInt(count: likeCount)
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