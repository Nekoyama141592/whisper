// material
import 'package:flutter/material.dart';
// components
import 'package:whisper/components/search/post_search/components/comments/search_comments_page.dart';
// model
import 'package:whisper/main_model.dart';


class CommentButton extends StatelessWidget {

  CommentButton({
    Key? key,
    required this.currentSongMapNotifier,
    required this.mainModel
  }) : super(key: key);


  final ValueNotifier<Map<String,dynamic>> currentSongMapNotifier;
  final MainModel mainModel;

  @override  
  Widget build(BuildContext context) {
    return 
    IconButton(
      onPressed: () { 
        Navigator.push(context, MaterialPageRoute(builder: (context) => SearchCommentsPage(currentSongMap: currentSongMapNotifier.value, currentUserDoc: mainModel.currentUserDoc, mainModel: mainModel) ) );
      }, 
      icon: Icon(Icons.comment)
    );

  }
}