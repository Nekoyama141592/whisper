// material
import 'package:flutter/material.dart';
// constants
import 'package:whisper/constants/strings.dart';
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

    final likeCount = thisReply[likeCountKey];

    return mainModel.likeReplyIds.contains(thisReply[replyIdKey]) ?
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
              replysModel.unlike(thisReply: thisReply, mainModel: mainModel);
            },
          ),
          SizedBox(width: 5.0),
          Text(
            likeCount >= 10000 ? (likeCount/1000.floor()/10).toString() + '万' :  likeCount.toString(),
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
              await replysModel.like(thisReply: thisReply, mainModel: mainModel);
            }
          ),
          SizedBox(width: 5.0),
          Text(
            likeCount >= 10000 ? (likeCount/1000.floor()/10).toString() + '万' :  likeCount.toString(),
          )
        ],
      ),
    );
  }
}