// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/enums.dart';
import 'package:whisper/constants/ints.dart';
import 'package:whisper/constants/others.dart';
// domain
import 'package:whisper/domain/post/post.dart';
// l10n
import 'package:whisper/l10n/l10n.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/models/posts/posts_model.dart';

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
    
    final postsModel = ref.watch(postsFeaturesProvider);
    final currentWhisperUser = mainModel.currentWhisperUser;
    if (postType != PostType.postSearch ) {
      final bookmarksCount = whisperPost.bookmarkCount;
      final plusOneCount = bookmarksCount + plusOne;
      final L10n l10n = returnL10n(context: context)!;
      return 
      mainModel.bookmarksPostIds.contains(whisperPost.postId) ?
      Row(
        children: [
          InkWell(
            child: Icon(
              Icons.bookmark,
              color: Theme.of(context).highlightColor,
            ),
            onTap: () async => await postsModel.unbookmark(context: context, whisperPost: whisperPost, mainModel: mainModel, bookmarkCategories: mainModel.bookmarkPostCategories )
          ),
          if(currentWhisperUser.uid == whisperPost.uid) Text(
            l10n.count(plusOneCount),
            style: TextStyle(color: Theme.of(context).highlightColor)
          )
        ],
      )
      : Row(
        children: [
          InkWell(
            child: Icon(Icons.bookmark_border),
            onTap: () async => await postsModel.bookmark(context: context, whisperPost: whisperPost, mainModel: mainModel, bookmarkPostLabels: mainModel.bookmarkPostCategories )
          ),
          if(currentWhisperUser.uid == whisperPost.uid) Text(l10n.count(bookmarksCount))
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
        onTap: () async => await postsModel.unbookmark(context: context, whisperPost: whisperPost, mainModel: mainModel, bookmarkCategories: mainModel.bookmarkPostCategories),
      )
      : InkWell(
        child: Icon(Icons.bookmark_border),
        onTap: () async => await postsModel.bookmark(context: context, whisperPost: whisperPost, mainModel: mainModel, bookmarkPostLabels: mainModel.bookmarkPostCategories )
      );
    }
  }
}