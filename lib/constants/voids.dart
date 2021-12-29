// material
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// packages
import 'package:just_audio/just_audio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
// constants
import 'package:whisper/constants/routes.dart' as routes;
// notifiers
import 'package:whisper/posts/notifiers/play_button_notifier.dart';
import 'package:whisper/posts/notifiers/progress_notifier.dart';
import 'package:whisper/posts/notifiers/repeat_button_notifier.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/one_post/one_post_model.dart';
import 'package:whisper/one_post/one_comment/one_comment_model.dart';
import 'package:whisper/official_adsenses/official_adsenses_model.dart';
import 'package:whisper/posts/components/other_pages/post_show/components/edit_post_info/edit_post_info_model.dart';

void addMutesUidAndMutesIpv6AndUid({ required List<dynamic> mutesUids, required List<dynamic> mutesIpv6AndUids, required Map<String,dynamic> map}) {
  final String uid = map['uid'];
  final String ipv6 = map['ipv6'];
  mutesUids.add(uid);
  mutesIpv6AndUids.add({
    'ipv6': ipv6,
    'uid': uid,
  });
}

Future<void> updateMutesIpv6AndUids({ required List<dynamic> mutesIpv6AndUids, required DocumentSnapshot currentUserDoc}) async {
  await FirebaseFirestore.instance.collection('users').doc(currentUserDoc.id)
  .update({
    'mutesIpv6AndUids': mutesIpv6AndUids,
  }); 
}

void addBlocksUidsAndBlocksIpv6AndUid({ required List<dynamic> blocksUids, required List<dynamic> blocksIpv6AndUids, required Map<String,dynamic> map }) {
  final String uid = map['uid'];
  final String ipv6 = map['ipv6'];
  blocksUids.add(uid);
  blocksIpv6AndUids.add({
    'ipv6': ipv6,
    'uid': uid,
  });
}

Future<void> updateBlocksIpv6AndUids({ required List<dynamic> blocksIpv6AndUids, required DocumentSnapshot currentUserDoc}) async {
  await FirebaseFirestore.instance.collection('users').doc(currentUserDoc.id)
  .update({
    'blocksIpv6AndUids': blocksIpv6AndUids,
  });
}

Future signOut(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.pop(context);
  routes.toIsFinishedPage(context: context, title: 'ログアウトしました', text: 'お疲れ様でした');
}

void showCupertinoDialogue({required BuildContext context, required String title, required String content, required void Function()? action}) {
  showCupertinoDialog(context: context, builder: (context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        CupertinoDialogAction(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        CupertinoDialogAction(
          child: const Text('OK'),
          isDestructiveAction: true,
          onPressed: action,
        )
      ],
    );
  });
}

void toEditPostInfoMode({ required AudioPlayer audioPlayer,required EditPostInfoModel editPostInfoModel}) {
  audioPlayer.pause();
  editPostInfoModel.isEditing = true;
  editPostInfoModel.reload();
}

Future<void> onNotificationPressed({ required BuildContext context ,required MainModel mainModel , required Map<String,dynamic> notification, required OneCommentModel oneCommentModel, required OnePostModel onePostModel,required String giveCommentId, required String givePostId}) async {

  await mainModel.addNotificationIdToReadNotificationIds(notification: notification);
  // Plaase don`t notification['commentId'].
  // Please use commentNotification['commentId'], replyNotification['elementId']
  bool postExists = await onePostModel.init(givePostId: givePostId);
  if (postExists) {
    bool commentExists = await oneCommentModel.init(giveCommentId: giveCommentId);
    if (commentExists) {
      routes.toOneCommentPage(context: context, mainModel: mainModel);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('そのコメントは削除されています')));
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('元の投稿が削除されています')));
  }
}

// just_audio

Future<void> setSpeed({ required ValueNotifier<double> speedNotifier,required SharedPreferences prefs, required AudioPlayer audioPlayer }) async {
  speedNotifier.value = prefs.getDouble('speed') ?? 1.0;
  await audioPlayer.setSpeed(speedNotifier.value);
}

Future<void> speedControll({ required ValueNotifier<double> speedNotifier, required SharedPreferences prefs, required AudioPlayer audioPlayer }) async {
  if (speedNotifier.value == 4.0) {
    speedNotifier.value = 1.0;
    await audioPlayer.setSpeed(speedNotifier.value);
    await prefs.setDouble('speed', speedNotifier.value);
  } else {
    speedNotifier.value += 0.5;
    await audioPlayer.setSpeed(speedNotifier.value);
    await prefs.setDouble('speed', speedNotifier.value);
  }
}

void listenForStates({ required AudioPlayer audioPlayer, required PlayButtonNotifier playButtonNotifier, required ProgressNotifier progressNotifier, required ValueNotifier<Map<String,dynamic>> currentSongMapNotifier, required ValueNotifier<bool> isShuffleModeEnabledNotifier, required ValueNotifier<bool> isFirstSongNotifier, required ValueNotifier<bool> isLastSongNotifier}) {
  listenForChangesInPlayerState(audioPlayer: audioPlayer, playButtonNotifier: playButtonNotifier);
  listenForChangesInPlayerPosition(audioPlayer: audioPlayer, progressNotifier: progressNotifier);
  listenForChangesInBufferedPosition(audioPlayer: audioPlayer, progressNotifier: progressNotifier);
  listenForChangesInTotalDuration(audioPlayer: audioPlayer, progressNotifier: progressNotifier);
  listenForChangesInSequenceState(audioPlayer: audioPlayer, currentSongMapNotifier: currentSongMapNotifier, isShuffleModeEnabledNotifier: isShuffleModeEnabledNotifier, isFirstSongNotifier: isFirstSongNotifier, isLastSongNotifier: isLastSongNotifier);
}

void listenForChangesInPlayerState({ required AudioPlayer audioPlayer, required PlayButtonNotifier playButtonNotifier }) {
  audioPlayer.playerStateStream.listen((playerState) {
    final isPlaying = playerState.playing;
    final processingState = playerState.processingState;
    if (processingState == ProcessingState.loading ||
        processingState == ProcessingState.buffering) {
      playButtonNotifier.value = ButtonState.loading;
    } else if (!isPlaying) {
      playButtonNotifier.value = ButtonState.paused;
    } else if (processingState != ProcessingState.completed) {
      playButtonNotifier.value = ButtonState.playing;
    } else {
      audioPlayer.seek(Duration.zero);
      audioPlayer.pause();
    }
  });
}

void listenForChangesInPlayerPosition({ required AudioPlayer audioPlayer, required ProgressNotifier progressNotifier}) {
  audioPlayer.positionStream.listen((position) {
    final oldState = progressNotifier.value;
    progressNotifier.value = ProgressBarState(
      current: position,
      buffered: oldState.buffered,
      total: oldState.total,
    );
  });
}

void listenForChangesInBufferedPosition({ required AudioPlayer audioPlayer, required ProgressNotifier progressNotifier }) {
  audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
    final oldState = progressNotifier.value;
    progressNotifier.value = ProgressBarState(
      current: oldState.current,
      buffered: bufferedPosition,
      total: oldState.total,
    );
  });
}

void listenForChangesInTotalDuration({ required AudioPlayer audioPlayer, required ProgressNotifier progressNotifier }) {
  audioPlayer.durationStream.listen((totalDuration) {
    final oldState = progressNotifier.value;
    progressNotifier.value = ProgressBarState(
      current: oldState.current,
      buffered: oldState.buffered,
      total: totalDuration ?? Duration.zero,
    );
  });
}

void listenForChangesInSequenceState({ required AudioPlayer audioPlayer, required ValueNotifier<Map<String,dynamic>> currentSongMapNotifier, required ValueNotifier<bool> isShuffleModeEnabledNotifier, required ValueNotifier<bool> isFirstSongNotifier, required ValueNotifier<bool> isLastSongNotifier }) {
  audioPlayer.sequenceStateStream.listen((sequenceState) {
    if (sequenceState == null) return;
    // update current song doc
    final currentItem = sequenceState.currentSource;
    final DocumentSnapshot<Map<String,dynamic>>? currentSongDoc = currentItem?.tag;
    currentSongMapNotifier.value = currentSongDoc!.data() as Map<String,dynamic>;
    // update playlist
    final playlist = sequenceState.effectiveSequence;
    isShuffleModeEnabledNotifier.value = 
    sequenceState.shuffleModeEnabled;
    // update previous and next buttons
    if (playlist.isEmpty || currentItem == null) {
      isFirstSongNotifier.value = true;
      isLastSongNotifier.value = true; 
    } else {
      isFirstSongNotifier.value = playlist.first == currentItem;
      isLastSongNotifier.value = playlist.last == currentItem;
    }
  });
}

void onRepeatButtonPressed({ required AudioPlayer audioPlayer, required RepeatButtonNotifier repeatButtonNotifier}) {
  repeatButtonNotifier.nextState();
  switch (repeatButtonNotifier.value) {
    case RepeatState.off:
      audioPlayer.setLoopMode(LoopMode.off);
      break;
    case RepeatState.repeatSong:
      audioPlayer.setLoopMode(LoopMode.one);
      break;
    case RepeatState.repeatPlaylist:
      audioPlayer.setLoopMode(LoopMode.all);
  }
}

void onPreviousSongButtonPressed({ required AudioPlayer audioPlayer}) {
  audioPlayer.seekToPrevious();
}

void onNextSongButtonPressed({ required AudioPlayer audioPlayer}) {
  audioPlayer.seekToNext();
}

Future<void> play({ required BuildContext context ,required AudioPlayer audioPlayer, required MainModel mainModel ,required String postId ,required OfficialAdsensesModel officialAdsensesModel })  async {
    audioPlayer.play();
     await officialAdsensesModel.onPlayButtonPressed(context);
    if (!mainModel.readPostIds.contains(postId)) {
      final map = {
        'createdAt': Timestamp.now(),
        'durationInt': 0,
        'postId': postId,
      };
      
      mainModel.readPosts.add(map);
      await FirebaseFirestore.instance
      .collection('users')
      .doc(mainModel.currentUserDoc.id)
      .update({
        'readPosts': mainModel.readPosts,
      });
    }
  }

void pause({ required AudioPlayer audioPlayer}) {
  audioPlayer.pause();
}

void onPostDeleteButtonPressed({ required BuildContext context, required AudioPlayer audioPlayer,required Map<String,dynamic> postMap, required List<AudioSource> afterUris, required List<dynamic> results,required MainModel mainModel, required int i}) {
  showCupertinoDialogue(context: context, title: '投稿削除', content: '一度削除したら、復元はできません。本当に削除しますか？', action: () async { await delete(context: context, audioPlayer: audioPlayer, postMap: postMap, afterUris: afterUris, results: results, mainModel: mainModel, i: i) ;});
}

Future delete({ required BuildContext context, required AudioPlayer audioPlayer,required Map<String,dynamic> postMap, required List<AudioSource> afterUris, required List<dynamic> results,required MainModel mainModel, required int i}) async {
  Navigator.pop(context);
  if (mainModel.currentUserDoc['uid'] != postMap['uid']) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('あなたにはその権限がありません')));
  } else {
    try {
      results.remove(results[i]);
      await resetAudioPlayer(afterUris: afterUris, audioPlayer: audioPlayer, i: i);
      mainModel.reload();
      await FirebaseFirestore.instance.collection('posts').doc(postMap['postId']).delete();
    } catch(e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('何らかのエラーが発生しました')));
    }
  }
}

Future<void> resetAudioPlayer({ required List<AudioSource> afterUris, required AudioPlayer audioPlayer, required int i }) async {
  // Abstractions in post_futures.dart cause Range errors.
  AudioSource source = afterUris[i];
  afterUris.remove(source);
  if (afterUris.isNotEmpty) {
    ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: afterUris);
    await audioPlayer.setAudioSource(playlist,initialIndex: i == 0 ? i :  i - 1);
  } 
}

Future initAudioPlayer({ required AudioPlayer audioPlayer, required List<AudioSource> afterUris ,required int i}) async {
    ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: afterUris);
    await audioPlayer.setAudioSource(playlist,initialIndex: i);
  }

  Future mutePost({ required MainModel mainModel, required int i, required Map<String,dynamic> post, required List<AudioSource> afterUris, required AudioPlayer audioPlayer , required List<dynamic> results}) async {
    final postId = post['postId'];
    mainModel.mutesPostIds.add(postId);
    results.removeWhere((result) => result['postId'] == postId);
    resetAudioPlayer(afterUris: afterUris, audioPlayer: audioPlayer, i: i);
    mainModel.reload();
    await mainModel.prefs.setStringList('mutesPostIds', mainModel.mutesPostIds);
  }

  Future muteUser({ required AudioPlayer audioPlayer, required List<AudioSource> afterUris, required List<dynamic> mutesUids, required int i, required List<dynamic> results,required List<dynamic> mutesIpv6AndUids, required Map<String,dynamic> post, required MainModel mainModel}) async {
    final String passiveUid = post['uid'];
    await removeTheUsersPost(results: results, passiveUid: passiveUid, afterUris: afterUris, audioPlayer: audioPlayer, i: i);
    addMutesUidAndMutesIpv6AndUid(mutesIpv6AndUids: mutesIpv6AndUids,mutesUids: mutesUids,map: post);
    mainModel.reload();
    updateMutesIpv6AndUids(mutesIpv6AndUids: mutesIpv6AndUids, currentUserDoc: mainModel.currentUserDoc);
  }

  Future blockUser({ required AudioPlayer audioPlayer, required List<AudioSource> afterUris, required List<dynamic> blocksUids, required List<dynamic> blocksIpv6AndUids, required int i, required List<dynamic> results, required Map<String,dynamic> post, required MainModel mainModel}) async {
    final String passiveUid = post['uid'];
    await removeTheUsersPost(results: results, passiveUid: passiveUid, afterUris: afterUris, audioPlayer: audioPlayer, i: i);
    addBlocksUidsAndBlocksIpv6AndUid(blocksIpv6AndUids: blocksIpv6AndUids,blocksUids: blocksUids,map: post);
    mainModel.reload();
    await updateBlocksIpv6AndUids(blocksIpv6AndUids: blocksIpv6AndUids, currentUserDoc: mainModel.currentUserDoc);
  }

  Future removeTheUsersPost({ required List<dynamic> results,required String passiveUid, required List<AudioSource> afterUris, required AudioPlayer audioPlayer,required int i}) async {
    results.removeWhere((result) => result['uid'] == passiveUid);
    await resetAudioPlayer(afterUris: afterUris, audioPlayer: audioPlayer, i: i);
  }
