// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
// components
import 'package:whisper/details/nothing.dart';
import 'package:whisper/posts/components/replys/components/reply_card/reply_card.dart';
// model
import 'package:whisper/posts/components/replys/replys_model.dart';

class ReplysPage extends StatelessWidget {

  const ReplysPage({
    Key? key,
    required this.replysModel,
    required this.replyDocs,
    required this.currentSongDoc,
    required this.currentUserDoc,
    required this.thisComment
  }) : super(key: key);

  final ReplysModel replysModel;
  final List<DocumentSnapshot> replyDocs;
  final DocumentSnapshot currentSongDoc;
  final DocumentSnapshot currentUserDoc;
  final Map<String,dynamic> thisComment;

  Widget build(BuildContext context) {

    final replyEditingController = TextEditingController();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_comment),
        onPressed: () {
          replysModel.onAddReplyButtonPressed(context, currentSongDoc, replyEditingController, currentUserDoc, thisComment);
        },
      ),
      body: SafeArea(
        child: Column(
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
                      Navigator.pop(context);
                    }, 
                  ),
                ),
              ],
            ),
            replyDocs.isNotEmpty ?
            Expanded(
              child: ListView.builder(
                itemCount: replyDocs.length,
                itemBuilder: (BuildContext context,int i) {
                  return ReplyCard(reply: replyDocs[i]);
                }
              )
            ) : Nothing()
          ]
        )
      ),
    );
  }
}