// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
// model
import 'package:whisper/components/search/post_search/components/replys/search_replys_model.dart';

class ShowReplyButton extends StatelessWidget {

  const ShowReplyButton({
    Key? key,
    required this.searchReplysModel,
    required this.currentSongMap,
    required this.currentUserDoc,
    required this.thisComment
  }) : super(key: key);

  final SearchReplysModel searchReplysModel;
  final Map<String,dynamic> currentSongMap;
  final DocumentSnapshot currentUserDoc;
  final Map<String,dynamic> thisComment;
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        searchReplysModel.getReplyDocs(context,thisComment);
      }, 
      icon: Icon(Icons.mode_comment)
    );
  }
}