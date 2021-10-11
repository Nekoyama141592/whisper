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
    required this.likedCommentIds,
    required this.likedComments,
    required this.currentSongDocNotifier,
    required this.currentUserDoc,
    required this.mainModel
  }) : super(key: key);

  final List<dynamic> likedCommentIds;
  final List<dynamic> likedComments;
  final ValueNotifier<DocumentSnapshot?> currentSongDocNotifier;
  final DocumentSnapshot currentUserDoc;
  final MainModel mainModel;

  @override  
  Widget build(BuildContext context) {
    return 
    IconButton(
      onPressed: () { routes.toCommentsPage(context, likedCommentIds, likedComments, currentSongDocNotifier, currentUserDoc,mainModel); }, 
      icon: Icon(Icons.comment)
    );

  }
}