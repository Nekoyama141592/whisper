// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/constants/doubles.dart';
// constants
import 'package:whisper/constants/enums.dart';
import 'package:whisper/constants/ints.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/widgets.dart';
// domain
import 'package:whisper/domain/post/post.dart';
// l10n
import 'package:whisper/l10n/l10n.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/models/posts/posts_model.dart';

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
      final L10n l10n = returnL10n(context: context)!;
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
            likeText(text: l10n.count(plusOneCount))
          ],
        ) 
        : Row(
          children: [
            InkWell(
              child: Icon(Icons.favorite),
              onTap: () async => await postFuturesModel.like(whisperPost: whisperPost, mainModel: mainModel)
            ),
            SizedBox(width: defaultPadding(context: context)/2.0),
            Text(l10n.count(likeCount))
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
          onTap: () async => await postFuturesModel.unlike(whisperPost: whisperPost, mainModel: mainModel),
        ) 
        : InkWell(
          child: Icon(Icons.favorite),
          onTap: () async => await postFuturesModel.like(whisperPost: whisperPost, mainModel: mainModel)
        ),
        
      );
    }
  }
}