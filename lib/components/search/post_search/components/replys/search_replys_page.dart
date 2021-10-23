// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whisper/details/loading.dart';
// components
import 'package:whisper/details/comments_or_replys_header.dart';
import 'package:whisper/components/search/post_search/components/replys/components/reply_cards/reply_cards.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/components/search/post_search/components/replys/search_replys_model.dart';

class SearchReplysPage extends StatelessWidget {

  const SearchReplysPage({
    Key? key,
    required this.searchReplysModel,
    required this.currentSongMap,
    required this.currentUserDoc,
    required this.thisComment,
    required this.mainModel
  }) : super(key: key);

  final SearchReplysModel searchReplysModel;
  final Map<String,dynamic> currentSongMap;
  final DocumentSnapshot currentUserDoc;
  final Map<String,dynamic> thisComment;
  final MainModel mainModel;

  Widget build(BuildContext context) {

    final replyEditingController = TextEditingController();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_comment),
        onPressed: () {
          searchReplysModel.onAddReplyButtonPressed(context, currentSongMap, replyEditingController, currentUserDoc, thisComment);
        },
      ),
      body: SafeArea(
        child: searchReplysModel.isLoading ?
        Loading()
        : Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CommentsOrReplysHeader(onMenuPressed: onMenuPressed),
            Expanded(child: ReplyCards(mainModel: mainModel, searchReplysModel: searchReplysModel) )
          ]
        )
      ),
    );
  }
}