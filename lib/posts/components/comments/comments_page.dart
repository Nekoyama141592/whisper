// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// components
import 'package:whisper/details/loading.dart';
import 'package:whisper/details/nothing.dart';
import 'package:whisper/posts/components/comments/components/comment_card.dart';
// model
import 'package:whisper/posts/components/comments/comments_model.dart';

class CommentsPage extends ConsumerWidget {
  
  const CommentsPage({
    Key? key,
    required this.currentSongDocNotifier,
    required this.currentUserDoc
  }) : super(key: key);
  
  final ValueNotifier<DocumentSnapshot?> currentSongDocNotifier;
  final DocumentSnapshot currentUserDoc;
  @override  
  Widget build(BuildContext context, ScopedReader watch) {
    final commentsModel = watch(commentsProvider);
    final size = MediaQuery.of(context).size;
    final currentSongDoc = currentSongDocNotifier.value;
    final commentEditingController = TextEditingController();
    commentsModel.comments = currentSongDocNotifier.value!['comments'];
    return Scaffold(
      floatingActionButton: commentsModel.isMaking ?
      SizedBox.shrink()
      : FloatingActionButton(
        child: Icon(Icons.new_label),
        backgroundColor: Theme.of(context).highlightColor,
        onPressed: ()  { 
          commentsModel.onFloatingActionButtonPressed(context, currentSongDoc!,commentEditingController,currentUserDoc); 
        },
      ),
      body: 

      Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
          commentsModel.isLoading ?
          Loading()
          : commentsModel.comments.isNotEmpty ?
          ValueListenableBuilder<DocumentSnapshot?>(
            valueListenable: currentSongDocNotifier, 
            builder: (_, currentSongDoc, __) {
              return
              Expanded(
                child: ListView.builder(
                  itemCount: commentsModel.comments.length,
                  itemBuilder: (BuildContext context, int i) =>
                  CommentCard(comment: commentsModel.comments[i])
                ),
              );
    
            }
          )
          : Nothing(),
        ],
      ),
    );
  }
}