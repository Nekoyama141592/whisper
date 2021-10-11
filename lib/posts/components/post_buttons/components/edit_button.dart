// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';

class EditButton extends StatelessWidget {
  
  const EditButton({
    Key? key,
    required this.currentUserDoc,
    required this.currentSongDocNotifier,
    required this.toEditingMode,
  }) : super(key: key);
  
  final DocumentSnapshot currentUserDoc;
  final ValueNotifier<DocumentSnapshot?> currentSongDocNotifier;
  final void Function()? toEditingMode;
  @override 
  
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DocumentSnapshot?>(
      valueListenable: currentSongDocNotifier, 
      builder: (_, currentSongDoc, __) {
        return currentUserDoc['uid'] != currentSongDoc!['uid'] ? SizedBox.shrink()
        : IconButton(
          // onPressed: () {
          //   editPostInfoModel.isEditing = true;
          //   editPostInfoModel.reload();
          // }, 
          onPressed: toEditingMode,
          icon: Icon(Icons.edit)
        );
      }
    );
  }
}