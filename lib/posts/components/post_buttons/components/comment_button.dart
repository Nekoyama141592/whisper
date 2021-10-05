// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
// constants
import 'package:whisper/constants/routes.dart' as routes;


class CommentButton extends StatelessWidget {

  CommentButton({
    Key? key,
    required this.likedCommentIds,
    required this.currentSongDocNotifier,
    required this.currentUserDoc
  }) : super(key: key);

  final List<dynamic> likedCommentIds;
  final ValueNotifier<DocumentSnapshot?> currentSongDocNotifier;
  final DocumentSnapshot currentUserDoc;
  @override  
  Widget build(BuildContext context) {
    return 
    IconButton(
      onPressed: () { routes.toCommentsPage(context, likedCommentIds,currentSongDocNotifier,currentUserDoc); }, 
      icon: Icon(Icons.comment)
    );

  }
}