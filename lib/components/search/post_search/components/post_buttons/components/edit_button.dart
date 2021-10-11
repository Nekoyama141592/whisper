// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
// model
import 'package:whisper/posts/components/other_pages/post_show/components/edit_post_info/edit_post_info_model.dart';

class EditButton extends StatelessWidget {
  
  const EditButton({
    Key? key,
    required this.currentUserDoc,
    required this.currentSongDocNotifier,
    required this.editPostInfoModel,
  }) : super(key: key);
  
  final DocumentSnapshot currentUserDoc;
  final ValueNotifier<DocumentSnapshot?> currentSongDocNotifier;
  final EditPostInfoModel editPostInfoModel;
  @override 
  
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DocumentSnapshot?>(
      valueListenable: currentSongDocNotifier, 
      builder: (_, currentSongDoc, __) {
        return currentUserDoc['uid'] != currentSongDoc!['uid'] ? SizedBox.shrink()
        : IconButton(
          onPressed: () {
            editPostInfoModel.isEditing = true;
            editPostInfoModel.reload();
          }, 
          icon: Icon(Icons.edit)
        );
      }
    );
  }
}