// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whisper/details/loading.dart';
// components
import 'package:whisper/details/nothing.dart';
import 'package:whisper/components/search/post_search/components/replys/components/reply_card/reply_card.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/components/search/post_search/components/replys/search_replys_model.dart';

class SearchReplysPage extends StatelessWidget {

  const SearchReplysPage({
    Key? key,
    required this.searchReplysModel,
    required this.replyMaps,
    required this.currentSongMap,
    required this.currentUserDoc,
    required this.thisComment,
    required this.mainModel
  }) : super(key: key);

  final SearchReplysModel searchReplysModel;
  final List<Map<String,dynamic>> replyMaps;
  final Map<String,dynamic> currentSongMap;
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
          searchReplysModel.onAddReplyButtonPressed(context, currentSongMap, replyEditingController, currentUserDoc, thisComment);
        },
      ),
      body: SafeArea(
        child: searchReplysModel.isLoading ?
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
                      searchReplysModel.isReplysMode = false;
                      searchReplysModel.reload();
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
                  // return ReplyCard(reply: replyMaps[i],searchReplysModel: searchReplysModel,mainModel: mainModel,);
                  return ReplyCard(mainModel: mainModel,reply: replyMaps[i],searchReplysModel: searchReplysModel,);
                }
              ),
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