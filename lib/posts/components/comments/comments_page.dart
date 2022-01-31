// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// constants
import 'package:whisper/constants/others.dart';
// components
import 'package:whisper/details/nothing.dart';
import 'package:whisper/details/comments_or_replys_header.dart';
import 'package:whisper/domain/comment/whisper_comment.dart';
import 'package:whisper/posts/components/comments/components/comment_card.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/posts/components/comments/comments_model.dart';
import 'package:whisper/posts/components/replys/replys_model.dart';

class CommentsPage extends ConsumerWidget {
  
  const CommentsPage({
    Key? key,
    required this.audioPlayer,
    required this.currentSongMap,
    required this.mainModel
  }) : super(key: key);

  final AudioPlayer audioPlayer;
  final Map<String,dynamic> currentSongMap;
  final MainModel mainModel;

  @override  
  Widget build(BuildContext context, WidgetRef ref) {
    final commentsModel = ref.watch(commentsProvider);
    final replysModel = ref.watch(replysProvider);
    final commentEditingController = TextEditingController();
    final whisperPost = fromMapToPost(postMap: currentSongMap);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.new_label,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).highlightColor,
        onPressed: ()  {
          commentsModel.onFloatingActionButtonPressed(context: context, whisperPost: whisperPost, commentEditingController: commentEditingController, audioPlayer: audioPlayer, mainModel: mainModel);
        },
      ),
      body: SafeArea(
        child: Column(

          children: [
            CommentsOrReplysHeader(
              onMenuPressed: (){
                commentsModel.showSortDialogue(context, whisperPost);
              },
            ),
            commentsModel.commentDocs.isEmpty ?
            Expanded(
              child: Nothing(reload: () async {
                await commentsModel.getCommentDocs(whisperPost.postId);
              }),
            )
            : Expanded(
              child: SmartRefresher(
                enablePullUp: true,
                enablePullDown: true,
                onLoading: () async {
                  await commentsModel.onLoading(whisperPost);
                },
                onRefresh: () {
                  commentsModel.onRefresh(context, whisperPost);
                },
                header: WaterDropHeader(),
                controller: commentsModel.refreshController,
                child: ListView.builder(
                  itemCount: commentsModel.commentDocs.length,
                  itemBuilder: (BuildContext context,int i) {
                    final Map<String, dynamic> comment = commentsModel.commentDocs[i].data() as Map<String,dynamic>;
                    final WhisperComment whisperComment = WhisperComment.fromJson(comment);
                    return CommentCard(
                      whisperComment: whisperComment,
                      currentSongMap: currentSongMap,
                      commentsModel: commentsModel,
                      replysModel: replysModel,
                      mainModel: mainModel,
                    );
                  }
                ),
              )
            )
          ],
        ),
      )
    );
  }
}