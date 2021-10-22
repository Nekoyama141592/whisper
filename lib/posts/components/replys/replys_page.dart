// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whisper/details/loading.dart';
// components
import 'package:whisper/posts/components/replys/components/reply_cards/reply_cards.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/posts/components/replys/replys_model.dart';

class ReplysPage extends StatelessWidget {

  const ReplysPage({
    Key? key,
    required this.replysModel,
    required this.currentSongDoc,
    required this.currentUserDoc,
    required this.thisComment,
    required this.mainModel
  }) : super(key: key);

  final ReplysModel replysModel;
  final DocumentSnapshot currentSongDoc;
  final DocumentSnapshot currentUserDoc;
  final Map<String,dynamic> thisComment;
  final MainModel mainModel;

  Widget build(BuildContext context) {

    final replyEditingController = TextEditingController();
    final size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_comment),
        onPressed: () {
          replysModel.onAddReplyButtonPressed(context, currentSongDoc, replyEditingController, currentUserDoc, thisComment);
        },
      ),
      body: SafeArea(
        child: replysModel.isLoading ?
        Loading()
        : Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    color: Theme.of(context).focusColor,
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      replysModel.isReplysMode = false;
                      replysModel.reload();
                    }, 
                  ),
                ),
              ],
            ),
            ReplyCards(mainModel: mainModel, replysModel: replysModel)
          ]
        )
      ),
    );
  }
}