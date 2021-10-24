// material
import 'package:flutter/material.dart';
// components
import 'package:whisper/components/search/post_search/components/post_buttons/components/bookmark_button.dart';
import 'package:whisper/components/search/post_search/components/post_buttons/components/comment_button.dart';
import 'package:whisper/components/search/post_search/components/post_buttons/components/edit_button.dart';
import 'package:whisper/components/search/post_search/components/post_buttons/components/like_button.dart';
import 'package:whisper/components/search/post_search/components/post_buttons/components/redirect_to_url_button.dart';
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
    return ValueListenableBuilder<Map<String,dynamic>>(
      valueListenable: currentSongMapNotifier,
      builder: (_,currentSongMap,__) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            LikeButton(currentUserDoc: mainModel.currentUserDoc, currentSongMap: currentSongMap, mainModel: mainModel),
            BookmarkButton(currentUserDoc: mainModel.currentUserDoc, currentSongMap: currentSongMap, bookmarkedPostIds: mainModel.bookmarkedPostIds, bookmarks: mainModel.bookmarks),
            CommentButton(currentSongMap: currentSongMap,postSearchModel: postSearchModel, mainModel: mainModel),
            if(mainModel.currentUserDoc['uid'] == currentSongMap['uid']) EditButton(currentUserDoc: mainModel.currentUserDoc, currentSongMap: currentSongMap, searchEditPostInfoModel: searchEditPostInfoModel),
            if(currentSongMap['link'].isNotEmpty) RedirectToUrlButton(currentSongMap: currentSongMap)
          ],
        );
      }
    );
  }
}