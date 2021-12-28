// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
// components
import 'package:whisper/details/back_arrow_button.dart';
import 'package:whisper/posts/components/comments/components/comment_card.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/posts/components/replys/replys_model.dart';
import 'package:whisper/posts/components/comments/comments_model.dart';
import 'package:whisper/one_post/one_comment/one_comment_model.dart';

class OneCommentPage extends ConsumerWidget {
  
  OneCommentPage({
    Key? key,
    required this.mainModel,
  }) : super(key: key);

  final MainModel mainModel;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    
    final OneCommentModel oneCommentModel = watch(oneCommentProvider);
    final CommentsModel commentsModel = watch(commentsProvider);
    final ReplysModel replysModel = watch(replysProvider);

    return Scaffold(
      body: oneCommentModel.isLoading ?
      SizedBox.shrink()
      : Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BackArrowButton(),
              CommentCard(comment: oneCommentModel.oneCommentMap, commentsModel: commentsModel, replysModel: replysModel, mainModel: mainModel),
              Text('サンプル'),
              SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}