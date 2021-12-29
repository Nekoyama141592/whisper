// material
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/posts/components/replys/replys_model.dart';

class ShowReplyButton extends StatelessWidget {

  const ShowReplyButton({
    Key? key,
    required this.mainModel,
    required this.replysModel,
    required this.currentUserDoc,
    required this.thisComment,
    required this.currentSongMap
  }) : super(key: key);

  final MainModel mainModel;
  final ReplysModel replysModel;
  final DocumentSnapshot currentUserDoc;
  final Map<String,dynamic> thisComment;
  final Map<String,dynamic> currentSongMap;

  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        replysModel.getReplysStream(context: context, thisComment: thisComment, replysModel: replysModel, currentSongMap: currentSongMap, mainModel: mainModel);
      }, 
      icon: Icon(Icons.mode_comment)
    );
  }
}