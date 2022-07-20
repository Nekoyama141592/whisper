// material
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// model
import 'package:whisper/posts/components/comments_or_replys/comments_or_replys_model.dart';

class ReportCommentButton extends StatelessWidget {

  const ReportCommentButton({
    Key? key,
    required this.builder,
    required this.commentsOrReplysModel
  }) : super(key: key);

  final Widget Function(BuildContext) builder;
  final CommentsOrReplysModel commentsOrReplysModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Icon(Icons.flag_circle),
      onTap: () => showCupertinoModalPopup(
        context: context, 
        builder: builder
      )
    );
  }
}