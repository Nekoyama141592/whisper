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
    required this.currentSongMap,
    required this.searchEditPostInfoModel,
  }) : super(key: key);
  
  final DocumentSnapshot currentUserDoc;
  final Map<String,dynamic> currentSongMap;
  final SearchEditPostInfoModel searchEditPostInfoModel;
  @override 
  
  Widget build(BuildContext context) {
    
    return InkWell(
      onTap: () {
        searchEditPostInfoModel.isEditing = true;
        searchEditPostInfoModel.reload();
      }, 
      child: Icon(Icons.edit)
    );
     
  }
}