// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/routes.dart' as routes;
// components
import 'package:whisper/posts/components/details/post_card.dart';
import 'package:whisper/posts/components/audio_window/audio_window.dart';
import 'package:whisper/components/search/post_search/components/search_input_field.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/posts/components/comments/comments_model.dart';
import 'package:whisper/components/search/post_search/post_search_model.dart';
import 'package:whisper/posts/components/other_pages/post_show/components/edit_post_info/edit_post_info_model.dart';

class PostCards extends ConsumerWidget {

  const PostCards({
    Key? key,
    required this.results,
    required this.mainModel,
    required this.postSearchModel,
  }) : super(key: key);

  final List<Map<String,dynamic>> results;
  final MainModel mainModel;
  final PostSearchModel postSearchModel;
  
  @override 
  Widget build(BuildContext context, ScopedReader watch) {
    
    final editPostInfoModel = watch(editPostInfoProvider);
    final commentsModel = watch(commentsProvider);
    final searchController = TextEditingController.fromValue(
      TextEditingValue(
        text: postSearchModel.searchTerm,
        selection: TextSelection.collapsed(
          offset: postSearchModel.searchTerm.length
        )
      )
    );

    return
    Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SearchInputField(
          searchModel: postSearchModel, 
          controller: searchController, 
          press: () async {
            await postSearchModel.operation(mainModel.mutesUids,mainModel.mutesPostIds,mainModel.blockingUids);
          }
        ),
        results.isNotEmpty ?
        Flexible(
          flex: 10,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (BuildContext context, int i) {
                    final Map<String,dynamic> post = results[i];
                    return 
                    PostCard(
                      post: post,
                      onDeleteButtonPressed: () { postSearchModel.onDeleteButtonPressed(context, results[i], mainModel.currentUserDoc, i); },
                      initAudioPlayer: () async {
                        await postSearchModel.initAudioPlayer(i);
                      },
                      muteUser: () async {
                        await postSearchModel.muteUser(mainModel.mutesUids, post['uid'], mainModel.prefs, i, mainModel.currentUserDoc);
                      },
                      mutePost: () async {
                        await postSearchModel.mutePost(mainModel.mutesPostIds, post['postId'], mainModel.prefs, i);
                      },
                      blockUser: () async {
                        await postSearchModel.blockUser(mainModel.currentUserDoc, mainModel.blockingUids, post['uid'], i);
                      },
                      mainModel: mainModel,
                    );
                  }
                )
              ),
              AudioWindow(
                route: () {
                  routes.toPostShowPage(
                    context,
                    postSearchModel.speedNotifier,
                    () async { await postSearchModel.speedControll(); },
                    postSearchModel.currentSongMapNotifier, 
                    postSearchModel.progressNotifier, 
                    postSearchModel.seek, 
                    postSearchModel.repeatButtonNotifier, 
                    () { postSearchModel.onRepeatButtonPressed(); }, 
                    postSearchModel.isFirstSongNotifier, 
                    () { postSearchModel.onPreviousSongButtonPressed(); }, 
                    postSearchModel.playButtonNotifier, 
                    () { postSearchModel.play(mainModel.readPostIds, mainModel.readPosts, mainModel.currentUserDoc); }, 
                    () { postSearchModel.pause(); }, 
                    postSearchModel.isLastSongNotifier, 
                    () { postSearchModel.onNextSongButtonPressed(); },
                    () {
                      commentsModel.setCommentsStream(postSearchModel.currentSongMapNotifier.value['postId']);
                      routes.toCommentsPage(context, postSearchModel.audioPlayer, postSearchModel.currentSongMapNotifier, mainModel);
                    },
                    () {
                      postSearchModel.pause();
                      editPostInfoModel.isEditing = true;
                      editPostInfoModel.reload();
                    },
                    mainModel
                  );
                }, 
                progressNotifier: postSearchModel.progressNotifier, 
                seek: postSearchModel.seek, 
                currentSongMapNotifier: postSearchModel.currentSongMapNotifier ,
                playButtonNotifier: postSearchModel.playButtonNotifier, 
                play: () { postSearchModel.play(mainModel.readPostIds, mainModel.readPosts, mainModel.currentUserDoc); }, 
                pause: () { postSearchModel.pause(); }, 
                currentUserDoc: mainModel.currentUserDoc,
                isFirstSongNotifier: postSearchModel.isFirstSongNotifier,
                onPreviousSongButtonPressed: () { postSearchModel.onPreviousSongButtonPressed(); },
                isLastSongNotifier: postSearchModel.isLastSongNotifier,
                onNextSongButtonPressed: () { postSearchModel.onNextSongButtonPressed(); },
                mainModel: mainModel,
              )
            ],
          ),
        ) : SizedBox.shrink(),
      ],
    );
  }
}