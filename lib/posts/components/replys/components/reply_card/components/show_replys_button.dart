// material
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// constants
import 'package:whisper/constants/routes.dart' as routes;
// model
import 'package:whisper/posts/components/replys/replys_model.dart';

class ShowReplyButton extends StatelessWidget {

  const ShowReplyButton({
    Key? key,
    required this.replysModel,
    required this.currentSongDoc,
    required this.currentUserDoc,
    required this.thisComment
  }) : super(key: key);

  final ReplysModel replysModel;
  final DocumentSnapshot currentSongDoc;
  final DocumentSnapshot currentUserDoc;
  final Map<String,dynamic> thisComment;
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        await replysModel.getReplyDocs(context);
        routes.toReplysPage(context, replysModel, replysModel.replyDocs, currentSongDoc, currentUserDoc, thisComment);
      }, 
      icon: Icon(Icons.mode_comment)
    );
  }
}