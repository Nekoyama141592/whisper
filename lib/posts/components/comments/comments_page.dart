// material
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// components
import 'package:whisper/details/nothing.dart';
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
    required this.currentSongDoc,
    required this.mainModel
  }) : super(key: key);
  
  final DocumentSnapshot currentSongDoc;
  final MainModel mainModel;
  @override  
  Widget build(BuildContext context, ScopedReader watch) {
    final commentsModel = watch(commentsProvider);
    final replysModel = watch(replysProvider);
    final commentEditingController = TextEditingController();
    commentsModel.sortCommentsByLikesUidsCount(currentSongDoc['comments']);

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
          commentsModel.onFloatingActionButtonPressed(context, currentSongDoc,commentEditingController, mainModel.currentUserDoc); 
        },
      ),

      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommentsOrReplysHeader(onBackButtonPressed: () { Navigator.pop(context); } ,onMenuPressed: () { commentsModel.showSortDialogue(context, currentSongDoc['comments']); }),
            currentSongDoc['comments'].isNotEmpty  || commentsModel.comments.isNotEmpty ?
            Expanded(
              child: ListView.builder(
                itemCount: commentsModel.didCommented ? commentsModel.comments.length :  currentSongDoc['comments'].length,
                itemBuilder: (BuildContext context, int i) {
                  
                  return CommentCard(
                    commentsModel: commentsModel,
                    replysModel: replysModel,
                    comment: commentsModel.didCommented ? commentsModel.comments[i] : currentSongDoc['comments'][i],
                    currentSongDoc: currentSongDoc,
                    mainModel: mainModel,
                  );
                }
                
              ),
            )
            : Nothing(),
          ],
        ),
      ),
    );
  }
}