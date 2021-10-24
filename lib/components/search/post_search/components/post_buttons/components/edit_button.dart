// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
// model
import 'package:whisper/components/search/post_search/components/other_pages/post_show/components/edit_post_info/search_edit_post_info_model.dart';

class EditButton extends StatelessWidget {
  
  const EditButton({
    Key? key,
    required this.currentUserDoc,
    required this.currentSongMapNotifier,
    required this.searchEditPostInfoModel,
  }) : super(key: key);
  
  final DocumentSnapshot currentUserDoc;
  final ValueNotifier<Map<String,dynamic>> currentSongMapNotifier;
  final SearchEditPostInfoModel searchEditPostInfoModel;
  @override 
  
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Map<String,dynamic>>(
      valueListenable: currentSongMapNotifier, 
      builder: (_, currentSongMap, __) {
        return currentUserDoc['uid'] != currentSongMap['uid'] ? SizedBox.shrink()
        : InkWell(
          onTap: () {
            searchEditPostInfoModel.isEditing = true;
            searchEditPostInfoModel.reload();
          }, 
          child: Icon(Icons.edit)
        );
      }
    );
  }
}