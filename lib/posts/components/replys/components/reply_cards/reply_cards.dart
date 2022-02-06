// material
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// components
import 'package:whisper/details/loading.dart';
import 'package:whisper/domain/whisper_post_comment/whisper_post_comment.dart';
import 'package:whisper/domain/reply/whipser_reply.dart';
import 'package:whisper/posts/components/replys/components/reply_card/reply_card.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/posts/components/replys/replys_model.dart';

class ReplyCards extends StatelessWidget {

  const ReplyCards({
    Key? key,
    required this.whisperComment,
    required this.mainModel,
    required this.replysModel
  }) : super(key: key);

  final WhisperPostComment whisperComment;
  final MainModel mainModel;
  final ReplysModel replysModel;

  @override 
  
  Widget build(BuildContext context) {

    return replysModel.isLoading ?
    Loading()
    : StreamBuilder(
      stream: replysModel.replysStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) Text('something went wrong');
        if (snapshot.connectionState == ConnectionState.waiting) Loading();
        return !snapshot.hasData || snapshot.data == null  ?
        SizedBox.shrink()
        : 
        SmartRefresher(
          enablePullUp: true,
          enablePullDown: false,
          header: WaterDropHeader(),
          controller: replysModel.refreshController,
          onLoading: () {
            replysModel.onLoading(whisperComment: whisperComment);
          },
          child: ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot doc) {
              final Map<String, dynamic> reply = doc.data()! as Map<String, dynamic>;
              final WhisperReply whisperReply = WhisperReply.fromJson(reply);
              return ReplyCard(whisperReply: whisperReply, replysModel: replysModel, mainModel: mainModel);
            }).toList(),
          ),
        );
      }
    );
  }

}