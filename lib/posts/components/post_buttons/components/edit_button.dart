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
    required this.currentSongTitleNotifier,
    required this.currentSongUidNotifier,
    required this.currentSongDocIdNotifier,
    required this.currentSongImageURLNotifier,
    required this.currentSongUserImageURLNotifier
  }) : super(key: key);
  
  final DocumentSnapshot currentUserDoc;
  final ValueNotifier<String> currentSongTitleNotifier;
  final ValueNotifier<String> currentSongDocIdNotifier;
  final ValueNotifier<String> currentSongUidNotifier;
  final ValueNotifier<String> currentSongImageURLNotifier;
  final ValueNotifier<String> currentSongUserImageURLNotifier;
  @override 
  
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: currentSongUidNotifier, 
      builder: (_,currentSongUid,__) {
        return currentUserDoc['uid'] != currentSongUid ? SizedBox.shrink()
        : IconButton(
          onPressed: () {
            routes.toEditPostInfoPage(context, currentSongTitleNotifier.value, currentUserDoc, currentSongDocIdNotifier.value, currentSongUserImageURLNotifier.value);
          }, 
          icon: Icon(Icons.edit)
        );
      }
    );
  }
}