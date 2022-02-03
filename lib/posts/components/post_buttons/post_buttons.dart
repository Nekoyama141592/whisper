// material
import 'package:flutter/material.dart';
// constants
import 'package:whisper/constants/enums.dart';
import 'package:whisper/domain/post/post.dart';
import 'package:whisper/domain/whisper_link/whisper_link.dart';
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
    required this.whisperPost,
    required this.postType,
    required this.toCommentsPage,
    required this.toEditingMode,
    required this.mainModel,
    required this.editPostInfoModel
  });

  final Post whisperPost;
  final PostType postType;
  final void Function()? toCommentsPage;
  final void Function()? toEditingMode;
  final MainModel mainModel;
  final EditPostInfoModel editPostInfoModel;
  
  @override  
  Widget build(BuildContext context) {
    final String link = whisperPost.links.isEmpty ? '' 
    : WhisperLink.fromJson(whisperPost.links.first).link;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        LikeButton(postType: postType, whisperPost: whisperPost, mainModel: mainModel),
        BookmarkButton(postType: postType, whisperPost: whisperPost, mainModel: mainModel),
        CommentButton(mainModel: mainModel,toCommentsPage: toCommentsPage),
        if (mainModel.currentWhisperUser.uid == whisperPost.uid) EditButton(toEditingMode: toEditingMode,),
        if (link.isNotEmpty) RedirectToUrlButton(whisperPost: whisperPost,)
      ],
    );
  }
}