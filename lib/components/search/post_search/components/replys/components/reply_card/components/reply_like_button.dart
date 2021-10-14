// material
import 'package:flutter/material.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/components/search/post_search/components/replys/search_replys_model.dart';

class ReplyLikeButton extends StatelessWidget {

  const ReplyLikeButton({
    Key? key,
    required this.thisReply,
    required this.mainModel,
    required this.searchReplysModel
  }) : super(key: key);

  final Map<String,dynamic> thisReply;
  final MainModel mainModel;
  final SearchReplysModel searchReplysModel;

  @override 
  Widget build(BuildContext context) {

    final List<dynamic> likesUids = thisReply['likesUids'];
    final likesUidsCount = likesUids.length;
    final plusOneCount = likesUids.length + 1;

    return mainModel.likedReplyIds.contains(thisReply['replyId']) ?
    Row(
      children: [
        InkWell(
          child: Icon(
            Icons.favorite,
            color: Colors.red
          ),
          onTap: () async {
            searchReplysModel.unlike(thisReply, mainModel.currentUserDoc, mainModel.likedReplys);
          },
        ),
        SizedBox(width: 5.0),
        Text(
          plusOneCount >= 10000 ? (plusOneCount/1000.floor()/10).toString() + '万' :  plusOneCount.toString(),
          style: TextStyle(color: Colors.red)
        )
      ],
    ) : Row(
      children: [
        InkWell(
          child: Icon(Icons.favorite),
          onTap: () async {
            searchReplysModel.like(thisReply, mainModel.currentUserDoc);
          },
        ),
        SizedBox(width: 5.0),
        Text(
          likesUidsCount >= 10000 ? (likesUidsCount/1000.floor()/10).toString() + '万' :  likesUidsCount.toString(),
        )
      ],
    );
  }
}