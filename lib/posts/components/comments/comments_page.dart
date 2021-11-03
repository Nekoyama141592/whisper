// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
// components
import 'package:whisper/details/comments_or_replys_header.dart';
import 'package:whisper/posts/components/replys/replys_page.dart';
import 'package:whisper/posts/components/comments/components/comment_card.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/posts/components/comments/comments_model.dart';
import 'package:whisper/posts/components/replys/replys_model.dart';

class CommentsPage extends ConsumerWidget {
  
  const CommentsPage({
    Key? key,
    required this.showSortDialogue,
    required this.audioPlayer,
    required this.currentSongMapCommentsNotifier,
    required this.currentSongMap,
    required this.mainModel
  }) : super(key: key);

  final void Function()? showSortDialogue;
  final AudioPlayer audioPlayer;
  final ValueNotifier<List<dynamic>> currentSongMapCommentsNotifier;
  final Map<String,dynamic> currentSongMap;
  final MainModel mainModel;

  @override  
  Widget build(BuildContext context, ScopedReader watch) {
    final commentsModel = watch(commentsProvider);
    final replysModel = watch(replysProvider);
    final commentEditingController = TextEditingController();

    return replysModel.isReplysMode ?
    ReplysPage(replysModel: replysModel, currentSongMap: currentSongMap, currentUserDoc: mainModel.currentUserDoc, thisComment: replysModel.giveComment, mainModel: mainModel)
    : Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.new_label,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).highlightColor,
        onPressed: ()  {
          commentsModel.onFloatingActionButtonPressed(context, currentSongMap,commentEditingController, mainModel.currentUserDoc,audioPlayer ,currentSongMapCommentsNotifier); 
        },
      ),

      body: ValueListenableBuilder<List<dynamic>>(
        valueListenable: currentSongMapCommentsNotifier,
        builder: (_,currentSongMapComments,__) {
          return
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommentsOrReplysHeader(onBackButtonPressed: () { Navigator.pop(context); } ,onMenuPressed: showSortDialogue,),
                currentSongMapComments.isNotEmpty ?
                Expanded(
                  child: ListView.builder(
                    itemCount: currentSongMapComments.length,
                    itemBuilder: (BuildContext context, int i) {
                      
                      return CommentCard(
                        commentsModel: commentsModel,
                        replysModel: replysModel,
                        comment: currentSongMapComments[i],
                        currentSongMap: currentSongMap,
                        mainModel: mainModel,
                      );
                    }
                    
                  ),
                ) : SizedBox.shrink(),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: InkWell(
                      child: Icon(
                        Icons.sort,
                        size: 32.0,
                      ),
                      onTap: () { commentsModel.reload(); },
                    ),
                  ),
                )
              ],
            ),
          );
        }
      ),
    );
  }
}