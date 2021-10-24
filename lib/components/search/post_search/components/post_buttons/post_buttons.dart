// material
import 'package:flutter/material.dart';
// components
import 'package:whisper/components/search/post_search/components/post_buttons/components/bookmark_button.dart';
import 'package:whisper/components/search/post_search/components/post_buttons/components/comment_button.dart';
import 'package:whisper/components/search/post_search/components/post_buttons/components/edit_button.dart';
import 'package:whisper/components/search/post_search/components/post_buttons/components/like_button.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/components/search/post_search/post_search_model.dart';
import 'package:whisper/components/search/post_search/components/other_pages/post_show/components/edit_post_info/search_edit_post_info_model.dart';


class PostButtons extends StatelessWidget {

  const PostButtons({
    required this.currentSongMapNotifier,
    required this.postSearchModel,
    required this.mainModel,
    required this.searchEditPostInfoModel
  });

  final ValueNotifier<Map<String,dynamic>> currentSongMapNotifier;
  final PostSearchModel postSearchModel;
  final MainModel mainModel;
  final SearchEditPostInfoModel searchEditPostInfoModel;
  
  @override  
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        LikeButton(currentUserDoc: mainModel.currentUserDoc, currentSongMapNotifier: currentSongMapNotifier, mainModel: mainModel),
        BookmarkButton(currentUserDoc: mainModel.currentUserDoc, currentSongMapNotifier: currentSongMapNotifier, bookmarkedPostIds: mainModel.bookmarkedPostIds, bookmarks: mainModel.bookmarks),
        CommentButton(postSearchModel: postSearchModel, mainModel: mainModel),
        EditButton(currentUserDoc: mainModel.currentUserDoc, currentSongMapNotifier: currentSongMapNotifier, searchEditPostInfoModel: searchEditPostInfoModel)
      ],
    );
  }
}