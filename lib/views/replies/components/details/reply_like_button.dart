// material
import 'package:flutter/material.dart';
// constants
import 'package:whisper/constants/ints.dart';
import 'package:whisper/constants/doubles.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/widgets.dart';
// domain
import 'package:whisper/domain/reply/whipser_reply.dart';
// l10n
import 'package:whisper/l10n/l10n.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/models/replies/replies_model.dart';

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
    final plusOneCount = likeCount + plusOne;
    final L10n l10n = returnL10n(context: context)!;

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
            onTap: () async => await replysModel.unlike(whisperReply: whisperReply, mainModel: mainModel)
          ),
          SizedBox(width: defaultPadding(context: context)/2.0),
          likeText(text: l10n.count(plusOneCount))
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
            onTap: () async => await replysModel.like(whisperReply: whisperReply, mainModel: mainModel),
          ),
          SizedBox(width: defaultPadding(context: context)/2.0),
          Text(l10n.count(likeCount))
        ],
      ),
    );
  }
}