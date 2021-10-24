// material
import 'package:flutter/material.dart';
// components
import 'package:whisper/components/search/post_search/components/comments/search_comments_page.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/components/search/post_search/post_search_model.dart';

class CommentButton extends StatelessWidget {

  CommentButton({
    Key? key,
    required this.postSearchModel,
    required this.mainModel
  }) : super(key: key);

  final PostSearchModel postSearchModel;
  final MainModel mainModel;

  @override  
  Widget build(BuildContext context) {
    return 
    IconButton(
      onPressed: () { 
        Navigator.push(context, MaterialPageRoute(builder: (context) => SearchCommentsPage(showSortDialogue: () { postSearchModel.showSortDialogue(context); }, audioPlayer: postSearchModel.audioPlayer, currentSongMapCommentsNotifier: postSearchModel.currentSongMapCommentsNotifier, currentSongMap: postSearchModel.currentSongMapNotifier.value, mainModel: mainModel) ));
      }, 
      icon: Icon(Icons.comment)
    );

  }
}