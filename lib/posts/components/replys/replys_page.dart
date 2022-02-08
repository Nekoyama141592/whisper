// material
import 'package:flutter/material.dart';
// package
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:whisper/constants/others.dart';
// components
import 'package:whisper/details/loading.dart';
import 'package:whisper/details/comments_or_replys_header.dart';
import 'package:whisper/domain/reply/whipser_reply.dart';
import 'package:whisper/domain/whisper_post_comment/whisper_post_comment.dart';
// domain
import 'package:whisper/domain/post/post.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/posts/components/replys/components/reply_card.dart';
import 'package:whisper/posts/components/replys/replys_model.dart';
import 'package:whisper/posts/components/comments_or_replys/comments_or_replys_model.dart';

class ReplysPage extends StatelessWidget {

  const ReplysPage({
    Key? key,
    required this.replysModel,
    required this.whisperPost,
    required this.whisperPostComment,
    required this.mainModel,
    required this.commentsOrReplysModel
  }) : super(key: key);

  final ReplysModel replysModel;
  final Post whisperPost;
  final WhisperPostComment whisperPostComment;
  final MainModel mainModel;
  final CommentsOrReplysModel commentsOrReplysModel;

  Widget build(BuildContext context) {

    final replyEditingController = TextEditingController();
    
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_comment),
        onPressed: () {
          replysModel.onAddReplyButtonPressed(context: context, whisperPost: whisperPost, replyEditingController: replyEditingController, whisperComment: whisperPostComment, mainModel: mainModel);
        },
      ),
      body: SafeArea(
        child: replysModel.isLoading ?
        Loading()
        : Column(
          children: [
            CommentsOrReplysHeader(
              onMenuPressed: () { replysModel.showSortDialogue(context, whisperPostComment); }
            ),
            Expanded(
              child: replysModel.isLoading ?
              SizedBox.shrink() : 
              SmartRefresher(
                enablePullUp: true,
                enablePullDown: true,
                header: WaterDropHeader(),
                controller: replysModel.refreshController,
                onLoading: () async {
                  await replysModel.onLoading(whisperComment: whisperPostComment);
                },
                onRefresh: () async {
                  await replysModel.onRefresh(whisperPostComment: whisperPostComment);
                },
                child: ListView.builder(
                  itemCount: replysModel.postCommentReplyDocs.length,
                  itemBuilder: (BuildContext context,int i) {
                    final WhisperReply whisperReply  = fromMapToWhisperReply(replyMap: replysModel.postCommentReplyDocs[i].data()! );
                    return ReplyCard(whisperReply: whisperReply, replysModel: replysModel, mainModel: mainModel,commentsOrReplysModel: commentsOrReplysModel,  );
                  }
                ),
              )
            )
          ]  
        )
      ),
    );
  }
}