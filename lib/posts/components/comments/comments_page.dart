// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// components
import 'package:whisper/details/comments_or_replys_header.dart';
import 'package:whisper/posts/components/replys/replys_page.dart';
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

    return replysModel.isReplysMode ?
    ReplysPage(replysModel: replysModel, currentSongMap: currentSongMap, currentUserDoc: mainModel.currentUserDoc, thisComment: replysModel.giveComment, mainModel: mainModel)
    : Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.new_label,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).highlightColor,
        onPressed: ()  {
          commentsModel.onFloatingActionButtonPressed(context, currentSongMap,commentEditingController, mainModel.currentUserDoc,audioPlayer); 
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            CommentsOrReplysHeader(onBackButtonPressed: () { Navigator.pop(context); } ,onMenuPressed: (){
              commentsModel.showSortDialogue(context, currentSongMap);
            },),
            Expanded(
              child: SmartRefresher(
                enablePullUp: true,
                enablePullDown: true,
                onLoading: () async {
                  print('Loading');
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
                      commentsModel: commentsModel,
                      replysModel: replysModel,
                      comment: comment,
                      currentSongMap: currentSongMap,
                      mainModel: mainModel,
                    );
                  }
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}