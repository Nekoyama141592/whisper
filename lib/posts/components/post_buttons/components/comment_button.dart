// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
// constants
import 'package:whisper/constants/routes.dart' as routes;
import 'package:whisper/main_model.dart';


class CommentButton extends StatelessWidget {

  CommentButton({
    Key? key,
    required this.currentSongDocNotifier,
    required this.toCommentsPage,
    required this.mainModel
  }) : super(key: key);

  final ValueNotifier<DocumentSnapshot?> currentSongDocNotifier;
  void Function()? toCommentsPage;
  final MainModel mainModel;

  @override  
  Widget build(BuildContext context) {
    return 
    IconButton(
      // onPressed: () {
      //   routes.toCommentsPage(context, mainModel.likedCommentIds, mainModel.likedComments, currentSongDocNotifier, mainModel.currentUserDoc,mainModel); 
      // }, 
      onPressed: toCommentsPage,
      icon: Icon(Icons.comment)
    );

  }
}