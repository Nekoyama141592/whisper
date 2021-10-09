// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whisper/details/loading.dart';
// components
import 'package:whisper/details/nothing.dart';
import 'package:whisper/posts/components/replys/components/reply_card/reply_card.dart';
// model
import 'package:whisper/posts/components/replys/replys_model.dart';

class ReplysPage extends StatelessWidget {

  const ReplysPage({
    Key? key,
    required this.replysModel,
    required this.replyMaps,
    required this.currentSongDoc,
    required this.currentUserDoc,
    required this.thisComment
  }) : super(key: key);

  final ReplysModel replysModel;
  final List<Map<String,dynamic>> replyMaps;
  final DocumentSnapshot currentSongDoc;
  final DocumentSnapshot currentUserDoc;
  final Map<String,dynamic> thisComment;

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
          crossAxisAlignment: CrossAxisAlignment.center,
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
            replyMaps.isNotEmpty ?
            Expanded(
              child: ListView.builder(
                itemCount: replyMaps.length,
                itemBuilder: (BuildContext context,int i) {
                  return ReplyCard(reply: replyMaps[i],replysModel: replysModel);
                }
              )
            ) : Column(
              children: [
                SizedBox(height: size.height * 0.25,),
                Nothing(),
              ],
            )
          ]
        )
      ),
    );
  }
}