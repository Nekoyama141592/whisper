// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// constants
import 'package:whisper/constants/strings.dart';
// components
import 'package:whisper/details/nothing.dart';
import 'package:whisper/details/comments_or_replys_header.dart';
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
  Widget build(BuildContext context, ScopedReader watch) {
    final commentsModel = watch(commentsProvider);
    final replysModel = watch(replysProvider);
    final commentEditingController = TextEditingController();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.new_label,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).highlightColor,
        onPressed: ()  {
          commentsModel.onFloatingActionButtonPressed(context: context, currentSongMap: currentSongMap, commentEditingController: commentEditingController, audioPlayer: audioPlayer, mainModel: mainModel);
        },
      ),
      body: SafeArea(
        child: Column(

          children: [
            CommentsOrReplysHeader(
              onMenuPressed: (){
                commentsModel.showSortDialogue(context, currentSongMap);
              },
            ),
            commentsModel.commentDocs.isEmpty ?
            Expanded(
              child: Nothing(reload: () async {
                await commentsModel.getCommentDocs(currentSongMap[postIdKey]);
              }),
            )
            : Expanded(
              child: SmartRefresher(
                enablePullUp: true,
                enablePullDown: true,
                onLoading: () async {
                  await commentsModel.onLoading(currentSongMap);
                },
                onRefresh: () {
                  commentsModel.onRefresh(context, currentSongMap);
                },
                header: WaterDropHeader(),
                controller: commentsModel.refreshController,
                child: ListView.builder(
                  itemCount: commentsModel.commentDocs.length,
                  itemBuilder: (BuildContext context,int i) {
                    Map<String, dynamic> comment = commentsModel.commentDocs[i].data() as Map<String,dynamic>;
                    return CommentCard(
                      comment: comment,
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