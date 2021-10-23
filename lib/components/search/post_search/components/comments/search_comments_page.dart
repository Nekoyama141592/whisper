// material
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// components
import 'package:whisper/details/nothing.dart';
import 'package:whisper/details/comments_or_replys_header.dart';
import 'package:whisper/components/search/post_search/components/replys/search_replys_page.dart';
import 'package:whisper/components/search/post_search/components/comments/components/comment_card.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/components/search/post_search/components/replys/search_replys_model.dart';
import 'package:whisper/components/search/post_search/components/comments/search_comments_model.dart';

class SearchCommentsPage extends ConsumerWidget {
  
  const SearchCommentsPage({
    Key? key,
    required this.currentSongMap,
    required this.currentUserDoc,
    required this.mainModel
  }) : super(key: key);
  
  final Map<String,dynamic> currentSongMap;
  final DocumentSnapshot currentUserDoc;
  final MainModel mainModel;
  @override  
  Widget build(BuildContext context, ScopedReader watch) {
    
    final searchCommentsModel = watch(searchCommentsProvider);
    final searchReplysModel = watch(searchReplysProvider);
    final commentEditingController = TextEditingController();

    searchCommentsModel.sortCommentsByLikesUidsCount(currentSongMap['comments']);

    return searchReplysModel.isReplysMode ?
    SearchReplysPage(searchReplysModel: searchReplysModel, currentSongMap: currentSongMap, currentUserDoc: currentUserDoc, thisComment: searchReplysModel.giveComment, mainModel: mainModel)
    : Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.new_label,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).highlightColor,
        onPressed: ()  { 
          searchCommentsModel.onFloatingActionButtonPressed(context, currentSongMap,commentEditingController,currentUserDoc); 
        },
      ),

      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommentsOrReplysHeader(onMenuPressed: () { searchCommentsModel.showSortDialogue(context, currentSongMap['comments']); }),
            currentSongMap['comments'].isNotEmpty  || searchCommentsModel.comments.isNotEmpty ?
            Expanded(
              child: ListView.builder(
                itemCount: searchCommentsModel.didCommented ? searchCommentsModel.comments.length :  currentSongMap['comments'].length,
                itemBuilder: (BuildContext context, int i) =>
                InkWell(
                  child: CommentCard(
                    comment: searchCommentsModel.didCommented ? searchCommentsModel.comments[i] : currentSongMap['comments'][i],
                    searchCommentsModel: searchCommentsModel, 
                    searchReplysModel: searchReplysModel,
                    currentSongMap: currentSongMap, 
                    mainModel: mainModel
                  ),
                  onTap: () {
                    print(searchCommentsModel.comments.length);
                  },
                )
              ),
            )
            : Nothing(),
          ],
        ),
      ),
    );
  }
}