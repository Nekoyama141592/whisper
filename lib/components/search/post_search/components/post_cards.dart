// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/constants/routes.dart' as routes;
// components
import 'package:whisper/posts/components/details/post_card.dart';
import 'package:whisper/posts/components/audio_window/audio_window.dart';
import 'package:whisper/components/search/post_search/components/search_input_field.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/posts/components/comments/comments_model.dart';
import 'package:whisper/official_adsenses/official_adsenses_model.dart';
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
    final officialAdsensesModel = watch(officialAdsensesProvider); 
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
            await postSearchModel.operation(mutesUids: mainModel.mutesUids, mutesPostIds: mainModel.mutesPostIds, blocksUids: mainModel.blocksUids, mutesIpv6s: mainModel.mutesIpv6s, blocksIpv6s: mainModel.blocksIpv6s);
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
                        await postSearchModel.muteUser(mutesUids: mainModel.mutesUids, i: i, currentUserDoc: mainModel.currentUserDoc, mutesIpv6AndUids: mainModel.mutesIpv6AndUids, post: post);
                      },
                      mutePost: () async {
                        await postSearchModel.mutePost(mainModel.mutesPostIds, mainModel.prefs, i,post);
                      },
                      blockUser: () async {
                        await postSearchModel.blockUser(blocksUids: mainModel.blocksUids, currentUserDoc: mainModel.currentUserDoc, blocksIpv6AndUids: mainModel.blocksIpv6AndUids, i: i, post: post);
                      },
                      mainModel: mainModel,
                    );
                  }
                )
              ),
              AudioWindow(
                route: () {
                  routes.toPostShowPage(
                    context: context,
                    speedNotifier: postSearchModel.speedNotifier,
                    speedControll:  () async { await voids.speedControll(audioPlayer: postSearchModel.audioPlayer, prefs: mainModel.prefs,speedNotifier: postSearchModel.speedNotifier); },
                    currentSongMapNotifier: postSearchModel.currentSongMapNotifier, 
                    progressNotifier: postSearchModel.progressNotifier, 
                    seek: postSearchModel.seek, 
                    repeatButtonNotifier: postSearchModel.repeatButtonNotifier, 
                    onRepeatButtonPressed:  () { voids.onRepeatButtonPressed(audioPlayer: postSearchModel.audioPlayer, repeatButtonNotifier: postSearchModel.repeatButtonNotifier); }, 
                    isFirstSongNotifier: postSearchModel.isFirstSongNotifier, 
                    onPreviousSongButtonPressed:  () { voids.onPreviousSongButtonPressed(audioPlayer: postSearchModel.audioPlayer); }, 
                    playButtonNotifier: postSearchModel.playButtonNotifier, 
                    play: () async { 
                      await voids.play(context: context, audioPlayer: postSearchModel.audioPlayer, mainModel: mainModel, postId: postSearchModel.currentSongMapNotifier.value['postId'], officialAdsensesModel: officialAdsensesModel);
                    }, 
                    pause: () { voids.pause(audioPlayer: postSearchModel.audioPlayer); }, 
                    isLastSongNotifier: postSearchModel.isLastSongNotifier, 
                    onNextSongButtonPressed:  () { voids.onNextSongButtonPressed(audioPlayer: postSearchModel.audioPlayer); },
                    toCommentsPage:  () async {
                      await commentsModel.init(context, postSearchModel.audioPlayer, postSearchModel.currentSongMapNotifier, mainModel, postSearchModel.currentSongMapNotifier.value['postId']);
                    },
                    toEditingMode:  () {
                      voids.toEditPostInfoMode(audioPlayer: postSearchModel.audioPlayer, editPostInfoModel: editPostInfoModel);
                    },
                    mainModel: mainModel
                  ); 
                }, 
                progressNotifier: postSearchModel.progressNotifier,
                seek: postSearchModel.seek,
                currentSongMapNotifier: postSearchModel.currentSongMapNotifier,
                playButtonNotifier: postSearchModel.playButtonNotifier,
                play: () async {
                  await voids.play(context: context, audioPlayer: postSearchModel.audioPlayer, mainModel: mainModel, postId: postSearchModel.currentSongMapNotifier.value['postId'], officialAdsensesModel: officialAdsensesModel);
                },
                pause: () {
                  voids.pause(audioPlayer: postSearchModel.audioPlayer);
                }, 
                currentUserDoc: mainModel.currentUserDoc,
                isFirstSongNotifier: postSearchModel.isFirstSongNotifier,
                onPreviousSongButtonPressed: () { voids.onPreviousSongButtonPressed(audioPlayer: postSearchModel.audioPlayer); },
                isLastSongNotifier: postSearchModel.isLastSongNotifier,
                onNextSongButtonPressed: () { voids.onNextSongButtonPressed(audioPlayer: postSearchModel.audioPlayer); },
                mainModel: mainModel,
              )
            ],
          ),
        ) : SizedBox.shrink(),
      ],
    );
  }
}