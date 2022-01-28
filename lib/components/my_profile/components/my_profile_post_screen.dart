// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// constants
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/constants/routes.dart' as routes;
// components
import 'package:whisper/details/loading.dart';
import 'package:whisper/details/judge_screen.dart';
import 'package:whisper/posts/components/details/post_card.dart';
import 'package:whisper/components/user_show/components/details/post_cards.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/components/my_profile/my_profile_model.dart';
import 'package:whisper/posts/components/comments/comments_model.dart';
import 'package:whisper/official_adsenses/official_adsenses_model.dart';
import 'package:whisper/posts/components/other_pages/post_show/components/edit_post_info/edit_post_info_model.dart';

class MyProfilePostScreen extends ConsumerWidget {
  
  MyProfilePostScreen({
    Key? key,
    required this.myProfileModel,
    required this.mainModel
  });

  final MyProfileModel myProfileModel;
  final MainModel mainModel;

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final editPostInfoModel = ref.watch(editPostInfoProvider);
    final commentsModel = ref.watch(commentsProvider);
    final officialAdsensesModel = ref.watch(officialAdsensesProvider); 
    final isLoading = myProfileModel.isLoading;
    final postDocs = myProfileModel.posts;

    final Widget posts = Expanded(
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
        controller: myProfileModel.refreshController,
        onRefresh: () async {
          await myProfileModel.onRefresh();
        },
        onLoading: () async {
          await myProfileModel.onLoading();
        },
        child: ListView.builder(
          itemCount: postDocs.length,
          itemBuilder: (BuildContext context, int i) {
            final Map<String,dynamic> post = postDocs[i].data() as Map<String,dynamic>;
            return 
            PostCard(
              post: post,
              onDeleteButtonPressed: () { voids.onPostDeleteButtonPressed(context: context, audioPlayer: myProfileModel.audioPlayer, postMap: postDocs[i].data() as Map<String,dynamic>, afterUris: myProfileModel.afterUris, posts: myProfileModel.posts, mainModel: mainModel, i: i); },
              initAudioPlayer: () async {
                await voids.initAudioPlayer(audioPlayer: myProfileModel.audioPlayer, afterUris: myProfileModel.afterUris, i: i);
              },
              muteUser: () async {
                await voids.muteUser(audioPlayer: myProfileModel.audioPlayer, afterUris: myProfileModel.afterUris, mutesUids: mainModel.mutesUids, i: i, results: myProfileModel.posts, muteUsers: mainModel.muteUsers, post: post, mainModel: mainModel);
              },
              mutePost: () async {
                await voids.mutePost(mainModel: mainModel, i: i, post: post, afterUris: myProfileModel.afterUris, audioPlayer: myProfileModel.audioPlayer, results: myProfileModel.posts );
              },
              blockUser: () async {
                await voids.blockUser(audioPlayer: myProfileModel.audioPlayer, afterUris: myProfileModel.afterUris, blocksUids: mainModel.blockUids, blockUsers: mainModel.blockUsers, i: i, results: myProfileModel.posts, post: post, mainModel: mainModel);
              },
              mainModel: mainModel,
            );
          }
        ),
      ),
    );
    final content =  Padding(
      padding: EdgeInsets.only(top: 20),
      child: PostCards(
        postDocs: myProfileModel.posts, 
        route: () {
          routes.toPostShowPage(
            context: context,
            speedNotifier: myProfileModel.speedNotifier,
            speedControll:  () async { await voids.speedControll(audioPlayer: myProfileModel.audioPlayer, prefs: mainModel.prefs,speedNotifier: myProfileModel.speedNotifier); },
            currentSongMapNotifier: myProfileModel.currentSongMapNotifier, 
            progressNotifier: myProfileModel.progressNotifier, 
            seek: myProfileModel.seek, 
            repeatButtonNotifier: myProfileModel.repeatButtonNotifier, 
            onRepeatButtonPressed:  () { voids.onRepeatButtonPressed(audioPlayer: myProfileModel.audioPlayer, repeatButtonNotifier: myProfileModel.repeatButtonNotifier); }, 
            isFirstSongNotifier: myProfileModel.isFirstSongNotifier, 
            onPreviousSongButtonPressed:  () { voids.onPreviousSongButtonPressed(audioPlayer: myProfileModel.audioPlayer); }, 
            playButtonNotifier: myProfileModel.playButtonNotifier, 
            play: () async { 
              await voids.play(context: context, audioPlayer: myProfileModel.audioPlayer, mainModel: mainModel, postId: fromMapToPost(postMap: myProfileModel.currentSongMapNotifier.value).postId, officialAdsensesModel: officialAdsensesModel);
            }, 
            pause: () { voids.pause(audioPlayer: myProfileModel.audioPlayer); }, 
            isLastSongNotifier: myProfileModel.isLastSongNotifier, 
            onNextSongButtonPressed:  () { voids.onNextSongButtonPressed(audioPlayer: myProfileModel.audioPlayer); },
            toCommentsPage:  () async {
              await commentsModel.init(context, myProfileModel.audioPlayer, myProfileModel.currentSongMapNotifier, mainModel, fromMapToPost(postMap: myProfileModel.currentSongMapNotifier.value).postId);
            },
            toEditingMode:  () {
              voids.toEditPostInfoMode(audioPlayer: myProfileModel.audioPlayer, editPostInfoModel: editPostInfoModel);
            },
            postType: myProfileModel.postType,
            mainModel: mainModel
          ); 
        }, 
        progressNotifier: myProfileModel.progressNotifier,
        seek: myProfileModel.seek,
        currentSongMapNotifier: myProfileModel.currentSongMapNotifier,
        playButtonNotifier: myProfileModel.playButtonNotifier,
        play: () async {
          await voids.play(context: context, audioPlayer: myProfileModel.audioPlayer, mainModel: mainModel, postId: fromMapToPost(postMap: myProfileModel.currentSongMapNotifier.value).postId, officialAdsensesModel: officialAdsensesModel);
        },
        pause: () {
          voids.pause(audioPlayer: myProfileModel.audioPlayer);
        }, 
        refreshController: myProfileModel.refreshController,
        onRefresh: () async { await myProfileModel.onRefresh(); },
        onLoading: () async { await myProfileModel.onLoading(); },
        isFirstSongNotifier: myProfileModel.isFirstSongNotifier,
        onPreviousSongButtonPressed: () { voids.onPreviousSongButtonPressed(audioPlayer: myProfileModel.audioPlayer); },
        isLastSongNotifier: myProfileModel.isLastSongNotifier,
        onNextSongButtonPressed: () { voids.onNextSongButtonPressed(audioPlayer: myProfileModel.audioPlayer); },
        mainModel: mainModel,
        posts: posts,
      ),
    );

    return isLoading ?
    Loading()
    : JudgeScreen(
      list: postDocs, 
      content: content,
      reload: () async {
        await myProfileModel.onReload();
      },
    );
  }
}