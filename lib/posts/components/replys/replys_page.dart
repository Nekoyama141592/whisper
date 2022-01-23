// material
import 'package:flutter/material.dart';
// package
import 'package:whisper/details/loading.dart';
// components
import 'package:whisper/details/comments_or_replys_header.dart';
import 'package:whisper/posts/components/replys/components/reply_cards/reply_cards.dart';
// domain
import 'package:whisper/domain/post/post.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/posts/components/replys/replys_model.dart';

class ReplysPage extends StatelessWidget {

  const ReplysPage({
    Key? key,
    required this.replysModel,
    required this.whisperPost,
    required this.thisComment,
    required this.mainModel
  }) : super(key: key);

  final ReplysModel replysModel;
  final Post whisperPost;
  final Map<String,dynamic> thisComment;
  final MainModel mainModel;

  Widget build(BuildContext context) {

    final replyEditingController = TextEditingController();
    
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_comment),
        onPressed: () {
          replysModel.onAddReplyButtonPressed(context: context, whisperPost: whisperPost, replyEditingController: replyEditingController, thisComment: thisComment, mainModel: mainModel);
        },
      ),
      body: SafeArea(
        child: replysModel.isLoading ?
        Loading()
        : Column(
          children: [
            CommentsOrReplysHeader(
              onMenuPressed: () { replysModel.showSortDialogue(context, thisComment); }
            ),
            Expanded(child: ReplyCards(thisComment: thisComment,mainModel: mainModel, replysModel: replysModel))
          ]
        )
      ),
    );
  }
}