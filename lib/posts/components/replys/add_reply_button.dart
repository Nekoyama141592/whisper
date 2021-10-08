// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
// model
import 'package:whisper/posts/components/replys/replys_model.dart';

class AddReplyButton extends StatelessWidget {

  const AddReplyButton({
    Key? key,
    required this.replysModel,
    required this.currentSongDoc,
    required this.replyEditingController,
    required this.currentUserDoc,
    required this.thisComment,
  }) : super(key: key);
  
  final ReplysModel replysModel;
  final DocumentSnapshot currentSongDoc;
  final TextEditingController replyEditingController;
  final DocumentSnapshot currentUserDoc;
  final Map<String,dynamic> thisComment;

  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        replysModel.onAddReplyButtonPressed(context, currentSongDoc, replyEditingController, currentUserDoc, thisComment);
      }, 
      icon: Icon(Icons.add_comment)
    );
  }
}