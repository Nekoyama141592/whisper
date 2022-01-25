// material
import 'package:flutter/material.dart';
// constants
import 'package:whisper/constants/enums.dart';
import 'package:whisper/constants/others.dart';
// components
import 'package:whisper/posts/components/post_buttons/components/edit_button.dart';
import 'package:whisper/posts/components/post_buttons/components/like_button.dart';
import 'package:whisper/posts/components/post_buttons/components/bookmark_button.dart';
import 'package:whisper/posts/components/post_buttons/components/comment_button.dart';
import 'package:whisper/posts/components/post_buttons/components/redirect_to_url_button.dart';
// domain
import 'package:whisper/domain/whisper_link/whisper_link.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/posts/components/other_pages/post_show/components/edit_post_info/edit_post_info_model.dart';

class PostButtons extends StatelessWidget {

  const PostButtons({
    required this.currentSongMapNotifier,
    required this.postType,
    required this.toCommentsPage,
    required this.toEditingMode,
    required this.mainModel,
    required this.editPostInfoModel
  });

  final ValueNotifier<Map<String,dynamic>> currentSongMapNotifier;
  final PostType postType;
  final void Function()? toCommentsPage;
  final void Function()? toEditingMode;
  final MainModel mainModel;
  final EditPostInfoModel editPostInfoModel;
  
  @override  
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Map<String,dynamic>>(
      valueListenable: currentSongMapNotifier,
      builder: (_,currentSongMap,__) {
        final whisperPost = fromMapToPost(postMap: currentSongMapNotifier.value);
        final WhisperLink whisperLink = fromMapToWhisperLink(whisperLink: whisperPost.links.first as Map<String,dynamic> );
        final link = whisperLink.url;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            LikeButton(postType: postType, whisperPost: whisperPost, mainModel: mainModel),
            BookmarkButton(postType: postType, whisperPost: whisperPost, mainModel: mainModel),
            CommentButton(currentSongMap: currentSongMap,mainModel: mainModel,toCommentsPage: toCommentsPage),
            if (mainModel.currentWhisperUser.uid == whisperPost.uid) EditButton(currentSongMap: currentSongMap, toEditingMode: toEditingMode,),
            if (link.isNotEmpty) RedirectToUrlButton(currentSongMap: currentSongMap,)
          ],
        );
      }
    );
  }
}