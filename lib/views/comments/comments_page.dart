// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
// components
import 'package:whisper/details/refresh_screen.dart';
import 'package:whisper/details/comments_or_replys_header.dart';
import 'package:whisper/domain/whisper_post_comment/whisper_post_comment.dart';
import 'package:whisper/views/comments/components/comment_card.dart';
// domain
import 'package:whisper/domain/post/post.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/models/comments/comments_model.dart';
import 'package:whisper/models/replies/replies_model.dart';
import 'package:whisper/posts/components/comments_or_replys/comments_or_replys_model.dart';

class CommentsPage extends ConsumerWidget {
  
  const CommentsPage({
    Key? key,
    required this.audioPlayer,
    required this.whisperPost,
    required this.mainModel,
    required this.commentsOrReplysModel
  }) : super(key: key);

  final AudioPlayer audioPlayer;
  final Post whisperPost;
  final MainModel mainModel;
  final CommentsOrReplysModel commentsOrReplysModel;

  @override  
  Widget build(BuildContext context, WidgetRef ref) {
    final commentsModel = ref.watch(commentsProvider);
    final replysModel = ref.watch(repliesProvider);
    final commentEditingController = TextEditingController();
    
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.new_label,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).highlightColor,
        onPressed: ()  => commentsModel.onFloatingActionButtonPressed(context: context, whisperPost: whisperPost, commentEditingController: commentEditingController, audioPlayer: audioPlayer, mainModel: mainModel),
      ),
      body: SafeArea(
        child: Column(
          children: [
            CommentsOrReplysHeader(
              onMenuPressed: () => commentsModel.showSortDialogue( context :context, whisperPost :whisperPost),
            ),
            RefreshScreen(
              isEmpty: commentsModel.commentDocs.isEmpty,
              subWidget: SizedBox.shrink(),
              controller: commentsModel.refreshController,
              onRefresh: () async => await commentsModel.onRefresh(context: context, whisperPost: whisperPost),
              onReload: () async => await commentsModel.onReload(whisperPost: whisperPost),
              onLoading: () async => await commentsModel.onLoading(whisperPost: whisperPost),
              child: ListView.builder(
                itemCount: commentsModel.commentDocs.length,
                itemBuilder: (BuildContext context,int i) {
                  final commentDoc = commentsModel.commentDocs[i];
                  final Map<String, dynamic> comment = commentDoc.data() as Map<String,dynamic>;
                  final WhisperPostComment whisperComment = WhisperPostComment.fromJson(comment);
                  return CommentCard(
                    i: i,
                    whisperPostComment: whisperComment,
                    commentDoc: commentDoc,
                    whisperPost: whisperPost,
                    commentsModel: commentsModel,
                    replysModel: replysModel,
                    mainModel: mainModel,
                    commentsOrReplysModel: commentsOrReplysModel,
                  );
                }
              ),
            )
          ],
        ),
      )
    );
  }
}