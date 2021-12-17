// material
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// components
import 'package:whisper/details/loading.dart';
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommentsOrReplysHeader(onBackButtonPressed: () { Navigator.pop(context); } ,onMenuPressed: (){
              commentsModel.showSortDialogue(context, currentSongMap);
            },),
            Expanded(
              child: StreamBuilder(
                stream: commentsModel.commentsStream,
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) Text('something went wrong');
                  if (snapshot.connectionState == ConnectionState.waiting) Loading();
                  return !snapshot.hasData || snapshot.data == null  ?
                  SizedBox.shrink()
                  : SmartRefresher(
                    enablePullUp: true,
                    enablePullDown: false,
                    header: WaterDropHeader(),
                    controller: replysModel.refreshController,
                    child: ListView(
                      children: snapshot.data!.docs.map((DocumentSnapshot doc) {
                        Map<String, dynamic> comment = doc.data()! as Map<String, dynamic>;
                        return CommentCard(
                          commentsModel: commentsModel,
                          replysModel: replysModel,
                          comment: comment,
                          currentSongMap: currentSongMap,
                          mainModel: mainModel,
                        );
                      }).toList() 
                      
                    ),
                  );
                }
              )
            ),
          ],
        ),
      )
    );
  }
}