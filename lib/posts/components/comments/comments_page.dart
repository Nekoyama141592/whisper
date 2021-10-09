// material
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// components
import 'package:whisper/details/nothing.dart';
import 'package:whisper/details/loading.dart';
import 'package:whisper/posts/components/comments/components/comment_card.dart';
import 'package:whisper/posts/components/replys/replys_page.dart';
// models
import 'package:whisper/posts/components/comments/comments_model.dart';
import 'package:whisper/posts/components/replys/replys_model.dart';
class CommentsPage extends ConsumerWidget {
  
  const CommentsPage({
    Key? key,
    required this.likedCommentIds,
    required this.likedComments,
    required this.currentSongDoc,
    required this.currentUserDoc,
  }) : super(key: key);
  
  final List<dynamic> likedCommentIds;
  final List<dynamic> likedComments;
  final DocumentSnapshot currentSongDoc;
  final DocumentSnapshot currentUserDoc;
  @override  
  Widget build(BuildContext context, ScopedReader watch) {
    final commentsModel = watch(commentsProvider);
    final replysModel = watch(replysProvider);
    final commentEditingController = TextEditingController();

    return replysModel.isReplysMode ?
    ReplysPage(replysModel: replysModel, replyDocs: replysModel.replyDocs, currentSongDoc: currentSongDoc, currentUserDoc: currentUserDoc, thisComment: replysModel.thisComment)
    : Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.new_label,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).highlightColor,
        onPressed: ()  { 
          commentsModel.onFloatingActionButtonPressed(context, currentSongDoc,commentEditingController,currentUserDoc); 
        },
      ),

      body: SafeArea(
        child: replysModel.isLoading ?
        Loading() 
        : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    color: Theme.of(context).focusColor,
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    }, 
                  ),
                ),
              ],
            ),
            currentSongDoc['comments'].isNotEmpty ?
            Expanded(
              child: ListView.builder(
                itemCount: commentsModel.didCommented ? commentsModel.comments.length :  currentSongDoc['comments'].length,
                itemBuilder: (BuildContext context, int i) =>
                InkWell(
                  child: CommentCard(
                    commentsModel: commentsModel,
                    replysModel: replysModel,
                    comment: commentsModel.didCommented ? commentsModel.comments[i] : currentSongDoc['comments'][i],
                    currentUserDoc: currentUserDoc,
                    currentSongDoc: currentSongDoc,
                    likedCommentIds: likedCommentIds,
                    likedComments: likedComments,
                  ),
                  onTap: () {
                    print(commentsModel.comments.length);
                  },
                )
              ),
            )
            : Nothing(),
          ],
        ),
      ),
    );
  }
}