// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/enums.dart';
// domain
import 'package:whisper/domain/post/post.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/posts/components/post_buttons/post_futures.dart';

class BookmarkButton extends ConsumerWidget {
  
  const BookmarkButton({
    Key? key,
    required this.postType,
    required this.whisperPost,
    required this.mainModel
  }) : super(key: key);

  final PostType postType;
  final Post whisperPost;
  final MainModel mainModel;
  @override  
  Widget build(BuildContext context, WidgetRef ref) {
    
    final postFuturesModel = ref.watch(postsFeaturesProvider);
    final currentWhisperUser = mainModel.currentWhisperUser;
    if (postType != PostType.postSearch ) {
      final bookmarksCount = whisperPost.bookmarkCount;
      final plusOneCount = bookmarksCount + 1;
      return 
      mainModel.bookmarksPostIds.contains(whisperPost.postId) ?
      Row(
        children: [
          InkWell(
            child: Icon(
              Icons.bookmark,
              color: Theme.of(context).highlightColor,
            ),
            onTap: () async {
              await postFuturesModel.unbookmark(context: context, whisperPost: whisperPost, mainModel: mainModel, bookmarkCategories: mainModel.bookmarkPostCategories );
            }),
          SizedBox(width: 5.0),
          if(currentWhisperUser.uid == whisperPost.uid) Text(
            plusOneCount >= 10000 ? (plusOneCount/1000.floor()/10).toString() + '万' :  plusOneCount.toString(),
            style: TextStyle(color: Theme.of(context).highlightColor)
          )
        ],
      )
      : Row(
        children: [
          InkWell(
            child: Icon(Icons.bookmark_border),
            onTap: () async {
              await postFuturesModel.bookmark(context: context, whisperPost: whisperPost, mainModel: mainModel, bookmarkPostLabels: mainModel.bookmarkPostCategories );
            }, 
          ),
          SizedBox(width: 5.0),
          if(currentWhisperUser.uid == whisperPost.uid) Text(
            bookmarksCount >= 10000 ? (bookmarksCount/1000.floor()/10).toString() + '万' :  bookmarksCount.toString(),
          )
        ],
      );
    } else {
      return 
      mainModel.bookmarksPostIds.contains(whisperPost.postId) ?
      InkWell(
        child: Icon(
          Icons.bookmark,
          color: Theme.of(context).highlightColor,
        ),
        onTap: () async {
          await postFuturesModel.unbookmark(context: context, whisperPost: whisperPost, mainModel: mainModel, bookmarkCategories: mainModel.bookmarkPostCategories);
        })
      : InkWell(
        child: Icon(Icons.bookmark_border),
        onTap: () async {
          await postFuturesModel.bookmark(context: context, whisperPost: whisperPost, mainModel: mainModel, bookmarkPostLabels: mainModel.bookmarkPostCategories );
        }, 
      );
    }
  }
}