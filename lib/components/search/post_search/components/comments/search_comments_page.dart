// material
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// packages
import 'package:just_audio/just_audio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// components
import 'package:whisper/details/nothing.dart';
import 'package:whisper/details/rounded_button.dart';
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
    
    final searchCommentsModel = watch(searchCommentsProvider);
    final searchReplysModel = watch(searchReplysProvider);
    final commentEditingController = TextEditingController();

    return searchReplysModel.isReplysMode ?
    SearchReplysPage(searchReplysModel: searchReplysModel, currentSongMap: currentSongMap, currentUserDoc: mainModel.currentUserDoc, thisComment: searchReplysModel.giveComment, mainModel: mainModel)
    : Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.new_label,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).highlightColor,
        onPressed: ()  { 
          searchCommentsModel.onFloatingActionButtonPressed(context, currentSongMap,commentEditingController,mainModel.currentUserDoc); 
        },
      ),

      body: ValueListenableBuilder<List<dynamic>>(
        valueListenable: currentSongMapCommentsNotifier,
        builder: (_,currentSongMapComments,__) {
          return currentSongMapComments.isNotEmpty ?
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommentsOrReplysHeader(onBackButtonPressed: () { Navigator.pop(context); } ,onMenuPressed: showSortDialogue,),
                
                Expanded(
                  child: ListView.builder(
                    itemCount: currentSongMapComments.length,
                    itemBuilder: (BuildContext context, int i) {
                      
                      return CommentCard(
                        comment: searchCommentsModel.didCommented ? searchCommentsModel.comments[i] : currentSongMap['comments'][i],
                        searchCommentsModel: searchCommentsModel, 
                        searchReplysModel: searchReplysModel,
                        currentSongMap: currentSongMap, 
                        mainModel: mainModel
                      );
                    }
                    
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: InkWell(
                      child: Icon(
                        Icons.sort,
                        size: 32.0,
                      ),
                      onTap: () { searchCommentsModel.reload(); },
                    ),
                  ),
                )
              ],
            ),
          ) : Nothing();
        }
      ),
    );
  }
}