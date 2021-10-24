// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
// models
import 'package:whisper/main_model.dart';


class CommentButton extends StatelessWidget {

  CommentButton({
    Key? key,
    required this.currentSongDocNotifier,
    required this.toCommentsPage,
    required this.mainModel
  }) : super(key: key);

  final ValueNotifier<DocumentSnapshot?> currentSongDocNotifier;
  final void Function()? toCommentsPage;
  final MainModel mainModel;

  @override  
  Widget build(BuildContext context) {
   
    return ValueListenableBuilder<DocumentSnapshot?>(
      valueListenable: currentSongDocNotifier,
      builder: (_,currentSongDoc,__) {
        final int commentsCount = currentSongDoc!['comments'].length;
        return Row(
          children: [
            InkWell(
              child: Icon(Icons.comment),
              onTap: toCommentsPage,
            ),
            SizedBox(width: 5.0),
            Text(
              commentsCount >= 10000 ? (commentsCount/1000.floor()/10).toString() + '万' :  commentsCount.toString(),
            )
          ],
        );
      }
    );

  }
}