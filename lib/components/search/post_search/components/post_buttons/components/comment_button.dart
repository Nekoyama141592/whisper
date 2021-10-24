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
    required this.currentSongMapNotifier,
    required this.postSearchModel,
    required this.mainModel
  }) : super(key: key);

  final ValueNotifier<Map<String,dynamic>> currentSongMapNotifier;
  final PostSearchModel postSearchModel;
  final MainModel mainModel;

  @override  
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Map<String,dynamic>>(
      valueListenable: currentSongMapNotifier,
      builder: (_,currentSongDoc,__) {
        final int commentsCount = currentSongDoc['comments'].length;
        return Row(
          children: [
            InkWell(
              child: Icon(Icons.comment),
              onTap: () { Navigator.push(context, MaterialPageRoute(builder: (context) => SearchCommentsPage(showSortDialogue: () { postSearchModel.showSortDialogue(context); }, audioPlayer: postSearchModel.audioPlayer, currentSongMapCommentsNotifier: postSearchModel.currentSongMapCommentsNotifier, currentSongMap: postSearchModel.currentSongMapNotifier.value, mainModel: mainModel) )); },
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