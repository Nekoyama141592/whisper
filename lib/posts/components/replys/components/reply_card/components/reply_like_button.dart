// material
import 'package:flutter/material.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/posts/components/replys/replys_model.dart';

class ReplyLikeButton extends StatelessWidget {

  const ReplyLikeButton({
    Key? key,
    required this.thisReply,
    required this.mainModel,
    required this.replysModel
  }) : super(key: key);

  final Map<String,dynamic> thisReply;
  final MainModel mainModel;
  final ReplysModel replysModel;
  @override 
  Widget build(BuildContext context) {

    final List<dynamic> likesUids = thisReply['likesUids'];
    final likesUidsCount = likesUids.length;

    return mainModel.likedReplyIds.contains(thisReply['replyId']) ?
    Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 5.0
      ),
      child: Row(
        children: [
          InkWell(
            child: Icon(
              Icons.favorite,
              color: Colors.red
            ),
            onTap: () async {
              replysModel.unlike(mainModel.likedReplyIds, thisReply, mainModel.currentUserDoc, mainModel.likedReplys);
            },
          ),
          SizedBox(width: 5.0),
          Text(
            likesUidsCount >= 10000 ? (likesUidsCount/1000.floor()/10).toString() + '万' :  likesUidsCount.toString(),
            style: TextStyle(color: Colors.red)
          )
        ],
      ),
    ) : Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 5.0
      ),
      child: Row(
        children: [
          InkWell(
            child: Icon(Icons.favorite),
            onTap: () async {
              await replysModel.like(mainModel.likedReplyIds, thisReply, mainModel.currentUserDoc);
            }
          ),
          SizedBox(width: 5.0),
          Text(
            likesUidsCount >= 10000 ? (likesUidsCount/1000.floor()/10).toString() + '万' :  likesUidsCount.toString(),
          )
        ],
      ),
    );
  }
}