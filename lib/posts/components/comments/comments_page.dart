// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
// components
import 'package:whisper/details/nothing.dart';
import 'package:whisper/details/comments_or_replys_header.dart';
import 'package:whisper/details/rounded_button.dart';
import 'package:whisper/posts/components/replys/replys_page.dart';
import 'package:whisper/posts/components/comments/components/comment_card.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/posts/components/comments/comments_model.dart';
import 'package:whisper/posts/components/replys/replys_model.dart';

class CommentsPage extends ConsumerWidget {
  
  const CommentsPage({
    Key? key,
    required this.showSortDialogue,
    required this.audioPlayer,
    required this.currentSongMapCommentsNotifier,
    required this.currentSongDoc,
    required this.mainModel
  }) : super(key: key);

  final void Function()? showSortDialogue;
  final AudioPlayer audioPlayer;
  final ValueNotifier<List<dynamic>> currentSongMapCommentsNotifier;
  final DocumentSnapshot currentSongDoc;
  final MainModel mainModel;

  @override  
  Widget build(BuildContext context, ScopedReader watch) {
    final commentsModel = watch(commentsProvider);
    final replysModel = watch(replysProvider);
    final commentEditingController = TextEditingController();

    return replysModel.isReplysMode ?
    ReplysPage(replysModel: replysModel, currentSongDoc: currentSongDoc, currentUserDoc: mainModel.currentUserDoc, thisComment: replysModel.giveComment, mainModel: mainModel)
    : Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.new_label,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).highlightColor,
        onPressed: ()  {
          commentsModel.onFloatingActionButtonPressed(context, currentSongDoc,commentEditingController, mainModel.currentUserDoc,audioPlayer ,currentSongMapCommentsNotifier); 
        },
      ),

      body: SafeArea(
        child: ValueListenableBuilder<List<dynamic>>(
          valueListenable: currentSongMapCommentsNotifier,
          builder: (_,currentSongMapComments,__) {
            return SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CommentsOrReplysHeader(onBackButtonPressed: () { Navigator.pop(context); } ,onMenuPressed: showSortDialogue,),
                  currentSongMapComments.isNotEmpty ?
                  Expanded(
                    child: ListView.builder(
                      itemCount: currentSongMapComments.length,
                      itemBuilder: (BuildContext context, int i) {
                        
                        return CommentCard(
                          commentsModel: commentsModel,
                          replysModel: replysModel,
                          comment: currentSongMapComments[i],
                          currentSongDoc: currentSongDoc,
                          mainModel: mainModel,
                        );
                      }
                      
                    ),
                  )
                  : Nothing(),
                  Center(
                    child: RoundedButton(
                      text: '並び替え実行', 
                      widthRate: 0.40, 
                      verticalPadding: 16.0, 
                      horizontalPadding: 0.0, 
                      press: () { commentsModel.reload(); }, 
                      textColor: Colors.white, 
                      buttonColor: Theme.of(context).primaryColor
                    ),
                  )
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}