// material
import 'package:flutter/material.dart';
import 'package:whisper/constants/doubles.dart';
import 'package:whisper/domain/reply/whipser_reply.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/posts/components/replys/replys_model.dart';

class ReplyLikeButton extends StatelessWidget {

  const ReplyLikeButton({
    Key? key,
    required this.whisperReply,
    required this.mainModel,
    required this.replysModel
  }) : super(key: key);

  final WhisperReply whisperReply;
  final MainModel mainModel;
  final RepliesModel replysModel;
  @override 
  Widget build(BuildContext context) {

    final likeCount = whisperReply.likeCount;

    return mainModel.likePostCommentReplyIds.contains(whisperReply.postCommentReplyId) ?
    Padding(
      padding: EdgeInsets.symmetric(
        horizontal: defaultPadding(context: context)
      ),
      child: Row(
        children: [
          InkWell(
            child: Icon(
              Icons.favorite,
              color: Colors.red
            ),
            onTap: () async {
              replysModel.unlike(whisperReply: whisperReply, mainModel: mainModel);
            },
          ),
          SizedBox(width: defaultPadding(context: context)/2.0),
          Text(
            likeCount >= 10000 ? (likeCount/1000.floor()/10).toString() + '万' :  likeCount.toString(),
            style: TextStyle(color: Colors.red)
          )
        ],
      ),
    ) : Padding(
      padding: EdgeInsets.symmetric(
        horizontal: defaultPadding(context: context)/2.0
      ),
      child: Row(
        children: [
          InkWell(
            child: Icon(Icons.favorite),
            onTap: () async {
              await replysModel.like(whisperReply: whisperReply, mainModel: mainModel);
            }
          ),
          SizedBox(width: defaultPadding(context: context)/2.0),
          Text(
            likeCount >= 10000 ? (likeCount/1000.floor()/10).toString() + '万' :  likeCount.toString(),
          )
        ],
      ),
    );
  }
}