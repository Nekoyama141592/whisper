// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/others.dart';
// components
import 'package:whisper/details/comments_or_replys_header.dart';
import 'package:whisper/details/refresh_screen.dart';
import 'package:whisper/domain/reply/whipser_reply.dart';
import 'package:whisper/views/replies/components/reply_card.dart';
import 'package:whisper/domain/whisper_post_comment/whisper_post_comment.dart';
// domain
import 'package:whisper/domain/post/post.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/models/replies/replies_model.dart';
import 'package:whisper/posts/components/comments_or_replys/comments_or_replys_model.dart';

class ReplysPage extends ConsumerWidget {

  const ReplysPage({
    Key? key,
    required this.whisperPost,
    required this.whisperPostComment,
    required this.mainModel,
    required this.commentsOrReplysModel
  }) : super(key: key);

  final Post whisperPost;
  final WhisperPostComment whisperPostComment;
  final MainModel mainModel;
  final CommentsOrReplysModel commentsOrReplysModel;

  Widget build(BuildContext context,WidgetRef ref ) {

    final replyEditingController = TextEditingController();
    final RepliesModel repliesModel = ref.watch(repliesProvider);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: Icon(Icons.add_comment),
        onPressed: () => repliesModel.onAddReplyButtonPressed(context: context, whisperPost: whisperPost, replyEditingController: replyEditingController, whisperComment: whisperPostComment, mainModel: mainModel),
      ),
      body: SafeArea(
        child: Column(
          children: [
            CommentsOrReplysHeader(
              onMenuPressed: () => repliesModel.showSortDialogue(context: context,whisperPostComment: whisperPostComment),
            ),
            RefreshScreen(
              isEmpty: repliesModel.postCommentReplyDocs.isEmpty,
              subWidget: SizedBox.shrink(),
              controller: repliesModel.refreshController,
              onLoading: () async => await repliesModel.onLoading( whisperPostComment: whisperPostComment),
              onRefresh: () async => await repliesModel.onRefresh(whisperPostComment: whisperPostComment),
              onReload: () async => await repliesModel.onReload(whisperPostComment: whisperPostComment),
              child: ListView.builder(
                itemCount: repliesModel.postCommentReplyDocs.length,
                itemBuilder: (BuildContext context,int i) {
                  final postCommentReplyDoc = repliesModel.postCommentReplyDocs[i];
                  final WhisperReply whisperReply  = fromMapToWhisperReply(replyMap: postCommentReplyDoc.data()! );
                  return ReplyCard(i: i,whisperReply: whisperReply, replyDoc: postCommentReplyDoc,repliesModel: repliesModel, mainModel: mainModel,commentsOrReplysModel: commentsOrReplysModel,  );
                }
              ),
            )
          ]  
        )
      ),
    );
  }
}