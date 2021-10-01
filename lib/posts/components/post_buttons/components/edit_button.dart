// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
// constants
import 'package:whisper/constants/routes.dart' as routes;

class EditButton extends StatelessWidget {
  
  const EditButton({
    Key? key,
    required this.currentUserDoc,
    required this.currentSongDocNotifier,
  }) : super(key: key);
  
  final DocumentSnapshot currentUserDoc;
  final ValueNotifier<DocumentSnapshot?> currentSongDocNotifier;

  @override 
  
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DocumentSnapshot?>(
      valueListenable: currentSongDocNotifier, 
      builder: (_, currentSongDoc, __) {
        return currentUserDoc['uid'] != currentSongDoc!['uid'] ? SizedBox.shrink()
        : IconButton(
          onPressed: () {
            routes.toEditPostInfoPage(context, currentSongDoc['title'], currentUserDoc, currentSongDoc.id, currentSongDoc['userImageURL']);
          }, 
          icon: Icon(Icons.edit)
        );
      }
    );
  }
}