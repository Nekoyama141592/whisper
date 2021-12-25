// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// constants
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
  Widget build(BuildContext context,ScopedReader watch) {
    final editPostInfoModel = watch(editPostInfoProvider);
    final commentsModel = watch(commentsProvider);
    final officialAdsensesModel = watch(officialAdsensesProvider); 
    final isLoading = myProfileModel.isLoading;
    final postDocs = myProfileModel.myProfileDocs;
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
              onDeleteButtonPressed: () { myProfileModel.onDeleteButtonPressed(context, postDocs[i], mainModel.currentUserDoc, i); },
              initAudioPlayer: () async {
                await myProfileModel.initAudioPlayer(i);
              },
              muteUser: () async {
                await myProfileModel.muteUser(mainModel.mutesUids,mainModel.prefs, i, mainModel.currentUserDoc,mainModel.mutesIpv6AndUids,post);
              },
              mutePost: () async {
                await myProfileModel.mutePost(mainModel.mutesPostIds, mainModel.prefs, i,post);
              },
              blockUser: () async {
                await myProfileModel.blockUser(mainModel.currentUserDoc, mainModel.blockingUids, i,mainModel.mutesIpv6AndUids,post);
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
        postDocs: myProfileModel.myProfileDocs, 
        route: (){
          routes.toPostShowPage(
          context, 
          myProfileModel.speedNotifier,
          () async { await myProfileModel.speedControll(); },
          myProfileModel.currentSongMapNotifier, 
          myProfileModel.progressNotifier, 
          myProfileModel.seek, 
          myProfileModel.repeatButtonNotifier, 
          () { myProfileModel.onRepeatButtonPressed(); }, 
          myProfileModel.isFirstSongNotifier, 
          () { myProfileModel.onPreviousSongButtonPressed(); }, 
          myProfileModel.playButtonNotifier, 
          () { myProfileModel.play(mainModel.readPostIds, mainModel.readPosts, mainModel.currentUserDoc); }, 
          () { myProfileModel.pause(); }, 
          myProfileModel.isLastSongNotifier, 
          () { myProfileModel.onNextSongButtonPressed(); },
          () async {
            await commentsModel.init(context, myProfileModel.audioPlayer, myProfileModel.currentSongMapNotifier, mainModel, myProfileModel.currentSongMapNotifier.value['postId']);
          },
          () {
            myProfileModel.pause();
            editPostInfoModel.isEditing = true;
            editPostInfoModel.reload();
          },
          mainModel
          );
        },
        progressNotifier: myProfileModel.progressNotifier,
        seek: myProfileModel.seek,
        currentSongMapNotifier: myProfileModel.currentSongMapNotifier,
        playButtonNotifier: myProfileModel.playButtonNotifier,
        play: () async {
          myProfileModel.play(mainModel.readPostIds, mainModel.readPosts, mainModel.currentUserDoc);
          await officialAdsensesModel.onPlayButtonPressed(context);
        },
        pause: () {
          myProfileModel.pause();
        }, 
        currentUserDoc: mainModel.currentUserDoc,
        refreshController: myProfileModel.refreshController,
        onRefresh: (){ myProfileModel.onRefresh(); },
        onLoading: () { myProfileModel.onLoading(); },
        isFirstSongNotifier: myProfileModel.isFirstSongNotifier,
        onPreviousSongButtonPressed: () { myProfileModel.onPreviousSongButtonPressed(); },
        isLastSongNotifier: myProfileModel.isLastSongNotifier,
        onNextSongButtonPressed: () { myProfileModel.onNextSongButtonPressed(); },
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
        myProfileModel.startLoading();
        await myProfileModel.getPosts();
        myProfileModel.endLoading();
      },
    );
  }
}