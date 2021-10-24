// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';

class EditButton extends StatelessWidget {
  
  const EditButton({
    Key? key,
    required this.currentUserDoc,
    required this.currentSongDoc,
    required this.toEditingMode,
  }) : super(key: key);
  
  final DocumentSnapshot currentUserDoc;
  final DocumentSnapshot currentSongDoc;
  final void Function()? toEditingMode;
  @override 
  
  Widget build(BuildContext context) {
    
        return currentUserDoc['uid'] != currentSongDoc['uid'] ? SizedBox.shrink()
        : IconButton(
          onPressed: toEditingMode,
          icon: Icon(Icons.edit)
        );
     
  }
}