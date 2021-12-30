// material
import 'package:flutter/material.dart';
// components
import 'package:whisper/posts/components/post_buttons/components/edit_button.dart';
import 'package:whisper/posts/components/post_buttons/components/like_button.dart';
import 'package:whisper/posts/components/post_buttons/components/bookmark_button.dart';
import 'package:whisper/posts/components/post_buttons/components/comment_button.dart';
import 'package:whisper/posts/components/post_buttons/components/redirect_to_url_button.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/posts/components/other_pages/post_show/components/edit_post_info/edit_post_info_model.dart';

class PostButtons extends StatelessWidget {

  const PostButtons({
    required this.currentSongMapNotifier,
    required this.toCommentsPage,
    required this.toEditingMode,
    required this.mainModel,
    required this.editPostInfoModel
  });

  final ValueNotifier<Map<String,dynamic>> currentSongMapNotifier;
  final void Function()? toCommentsPage;
  final void Function()? toEditingMode;
  final MainModel mainModel;
  final EditPostInfoModel editPostInfoModel;
  
  @override  
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Map<String,dynamic>>(
      valueListenable: currentSongMapNotifier,
      builder: (_,currentSongMap,__) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            LikeButton(currentUserDoc: mainModel.currentUserDoc, currentSongMap: currentSongMap, likedPostIds: mainModel.likedPostIds,likes: mainModel.likes),
            BookmarkButton(currentUserDoc: mainModel.currentUserDoc, currentSongMap: currentSongMap, bookmarkedPostIds: mainModel.bookmarkedPostIds,bookmarks: mainModel.bookmarks),
            CommentButton(currentSongMap: currentSongMap,mainModel: mainModel,toCommentsPage: toCommentsPage),
            if (mainModel.currentUserDoc['uid'] == currentSongMap['uid']) EditButton(currentSongMap: currentSongMap, toEditingMode: toEditingMode,),
            if (currentSongMap['link'].isNotEmpty) RedirectToUrlButton(currentSongMap: currentSongMap,)
          ],
        );
      }
    );
  }
}