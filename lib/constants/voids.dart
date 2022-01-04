// dart
import 'dart:io';
// material
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// packages
import 'package:flash/flash.dart';
import 'package:just_audio/just_audio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
// constants
import 'package:whisper/constants/enums.dart';
import 'package:whisper/constants/bools.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/ints.dart';
import 'package:whisper/constants/routes.dart' as routes;
import 'package:whisper/constants/strings.dart';
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

void setMutesAndBlocks({ required SharedPreferences prefs ,required DocumentSnapshot currentUserDoc, required List<dynamic> mutesIpv6AndUids, required List<dynamic> mutesIpv6s, required List<dynamic> mutesUids , required List<dynamic>mutesPostIds, required List<dynamic> blocksIpv6AndUids, required List<dynamic> blocksIpv6s, required List<dynamic> blocksUids }) {
  // 代入は使えないが.addは反映される
  currentUserDoc[mutesIpv6AndUidsKey].forEach((mutesIpv6AndUid) { mutesIpv6AndUids.add(mutesIpv6AndUid); });
  mutesIpv6AndUids.forEach((mutesIpv6AndUid) {
    mutesIpv6s.add(mutesIpv6AndUid[ipv6Key]);
    mutesUids.add(mutesIpv6AndUid[uidKey]);
  });
  (prefs.getStringList(mutesPostIdsKey) ?? []).forEach((mutesPostId) { mutesPostIds.add(mutesPostId); }) ;
  currentUserDoc[blocksIpv6AndUidsKey].forEach((blocksIpv6AndUid) { blocksIpv6AndUids.add(blocksIpv6AndUid); });
  blocksIpv6AndUids.forEach((blocksIpv6AndUid) {
    blocksUids.add(blocksIpv6AndUid[uidKey]);
    blocksIpv6s.add(blocksIpv6AndUid[ipv6Key]);
  });
}

void addMutesUidAndMutesIpv6AndUid({ required List<dynamic> mutesUids, required List<dynamic> mutesIpv6AndUids, required Map<String,dynamic> map}) {
  final String uid = map[uidKey];
  final String ipv6 = map[ipv6Key];
  mutesUids.add(uid);
  mutesIpv6AndUids.add({
    ipv6Key: ipv6,
    uidKey: uid,
  });
}

Future<void> updateMutesIpv6AndUids({ required List<dynamic> mutesIpv6AndUids, required DocumentSnapshot currentUserDoc}) async {
  await FirebaseFirestore.instance.collection(usersKey).doc(currentUserDoc.id)
  .update({
    mutesIpv6AndUidsKey: mutesIpv6AndUids,
  }); 
}

void addBlocksUidsAndBlocksIpv6AndUid({ required List<dynamic> blocksUids, required List<dynamic> blocksIpv6AndUids, required Map<String,dynamic> map }) {
  final String uid = map[uidKey];
  final String ipv6 = map[ipv6Key];
  blocksUids.add(uid);
  blocksIpv6AndUids.add({
    ipv6Key: ipv6,
    uidKey: uid,
  });
}

Future<void> updateBlocksIpv6AndUids({ required List<dynamic> blocksIpv6AndUids, required DocumentSnapshot currentUserDoc}) async {
  await FirebaseFirestore.instance.collection(usersKey).doc(currentUserDoc.id)
  .update({
    blocksIpv6AndUidsKey: blocksIpv6AndUids,
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

  await mainModel.addNotificationToReadNotificationIds(notification: notification);
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
  speedNotifier.value = prefs.getDouble(speedKey) ?? 1.0;
  await audioPlayer.setSpeed(speedNotifier.value);
}

Future<void> speedControll({ required ValueNotifier<double> speedNotifier, required SharedPreferences prefs, required AudioPlayer audioPlayer }) async {
  if (speedNotifier.value == 4.0) {
    speedNotifier.value = 1.0;
    await audioPlayer.setSpeed(speedNotifier.value);
    await prefs.setDouble(speedKey, speedNotifier.value);
  } else {
    speedNotifier.value += 0.5;
    await audioPlayer.setSpeed(speedNotifier.value);
    await prefs.setDouble(speedKey, speedNotifier.value);
  }
}

void listenForStates({ required AudioPlayer audioPlayer, required PlayButtonNotifier playButtonNotifier, required ProgressNotifier progressNotifier, required ValueNotifier<Map<String,dynamic>> currentSongMapNotifier, required ValueNotifier<bool> isShuffleModeEnabledNotifier, required ValueNotifier<bool> isFirstSongNotifier, required ValueNotifier<bool> isLastSongNotifier}) {
  listenForChangesInPlayerState(audioPlayer: audioPlayer, playButtonNotifier: playButtonNotifier);
  listenForChangesInPlayerPosition(audioPlayer: audioPlayer, progressNotifier: progressNotifier);
  listenForChangesInBufferedPosition(audioPlayer: audioPlayer, progressNotifier: progressNotifier);
  listenForChangesInTotalDuration(audioPlayer: audioPlayer, progressNotifier: progressNotifier);
  listenForChangesInSequenceState(audioPlayer: audioPlayer, currentSongMapNotifier: currentSongMapNotifier, isShuffleModeEnabledNotifier: isShuffleModeEnabledNotifier, isFirstSongNotifier: isFirstSongNotifier, isLastSongNotifier: isLastSongNotifier);
}
void listenForStatesForAddPostModel({ required AudioPlayer audioPlayer, required PlayButtonNotifier playButtonNotifier, required ProgressNotifier progressNotifier, }) {
  listenForChangesInPlayerState(audioPlayer: audioPlayer, playButtonNotifier: playButtonNotifier);
  listenForChangesInPlayerPosition(audioPlayer: audioPlayer, progressNotifier: progressNotifier);
  listenForChangesInBufferedPosition(audioPlayer: audioPlayer, progressNotifier: progressNotifier);
  listenForChangesInTotalDuration(audioPlayer: audioPlayer, progressNotifier: progressNotifier); 
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
    final Map<String,dynamic> currentSongMap = currentItem?.tag;
    currentSongMapNotifier.value = currentSongMap;
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
        createdAtKey: Timestamp.now(),
        durationIntKey: 0,
        postIdKey: postId,
      };
      
      mainModel.readPosts.add(map);
      await FirebaseFirestore.instance
      .collection(usersKey)
      .doc(mainModel.currentUserDoc.id)
      .update({
        readPostsKey: mainModel.readPosts,
      });
    }
  }

void pause({ required AudioPlayer audioPlayer}) {
  audioPlayer.pause();
}

void onPostDeleteButtonPressed({ required BuildContext context, required AudioPlayer audioPlayer,required Map<String,dynamic> postMap, required List<AudioSource> afterUris, required List<dynamic> posts,required MainModel mainModel, required int i}) {
  showCupertinoDialogue(context: context, title: '投稿削除', content: '一度削除したら、復元はできません。本当に削除しますか？', action: () async { await deletePost(context: context, audioPlayer: audioPlayer, postMap: postMap, afterUris: afterUris, posts: posts, mainModel: mainModel, i: i) ;});
}

Future deletePost({ required BuildContext context, required AudioPlayer audioPlayer,required Map<String,dynamic> postMap, required List<AudioSource> afterUris, required List<dynamic> posts,required MainModel mainModel, required int i}) async {
  Navigator.pop(context);
  if (mainModel.currentUser!.uid != postMap[uidKey]) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('あなたにはその権限がありません')));
  } else {
    try {
      posts.remove(posts[i]);
      await resetAudioPlayer(afterUris: afterUris, audioPlayer: audioPlayer, i: i);
      mainModel.reload();
      await FirebaseFirestore.instance.collection(postsKey).doc(postMap[postIdKey]).delete();
      await postChildRef(mainModel: mainModel, storagePostName: postMap[storagePostNameKey]).delete();
      if (postMap[storageImageNameKey].isNotEmpty) {
        await postImageChildRef(mainModel: mainModel, postImageName: postMap[storageImageNameKey]).delete();
      }
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
  final postId = post[postIdKey];
  mainModel.mutesPostIds.add(postId);
  results.removeWhere((result) => result[postIdKey] == postId);
  await resetAudioPlayer(afterUris: afterUris, audioPlayer: audioPlayer, i: i);
  mainModel.reload();
  await mainModel.prefs.setStringList(mutesPostIdsKey, mainModel.mutesPostIds);
}

Future muteUser({ required AudioPlayer audioPlayer, required List<AudioSource> afterUris, required List<dynamic> mutesUids, required int i, required List<dynamic> results,required List<dynamic> mutesIpv6AndUids, required Map<String,dynamic> post, required MainModel mainModel}) async {
  final String passiveUid = post[uidKey];
  await removeTheUsersPost(results: results, passiveUid: passiveUid, afterUris: afterUris, audioPlayer: audioPlayer, i: i);
  addMutesUidAndMutesIpv6AndUid(mutesIpv6AndUids: mutesIpv6AndUids,mutesUids: mutesUids,map: post);
  mainModel.reload();
  updateMutesIpv6AndUids(mutesIpv6AndUids: mutesIpv6AndUids, currentUserDoc: mainModel.currentUserDoc);
}

Future blockUser({ required AudioPlayer audioPlayer, required List<AudioSource> afterUris, required List<dynamic> blocksUids, required List<dynamic> blocksIpv6AndUids, required int i, required List<dynamic> results, required Map<String,dynamic> post, required MainModel mainModel}) async {
  final String passiveUid = post[uidKey];
  await removeTheUsersPost(results: results, passiveUid: passiveUid, afterUris: afterUris, audioPlayer: audioPlayer, i: i);
  addBlocksUidsAndBlocksIpv6AndUid(blocksIpv6AndUids: blocksIpv6AndUids,blocksUids: blocksUids,map: post);
  mainModel.reload();
  await updateBlocksIpv6AndUids(blocksIpv6AndUids: blocksIpv6AndUids, currentUserDoc: mainModel.currentUserDoc);
}

Future removeTheUsersPost({ required List<dynamic> results,required String passiveUid, required List<AudioSource> afterUris, required AudioPlayer audioPlayer,required int i}) async {
  results.removeWhere((result) => result[uidKey] == passiveUid);
  await resetAudioPlayer(afterUris: afterUris, audioPlayer: audioPlayer, i: i);
}

Future<void> processNewPosts({ required Query<Map<String, dynamic>> query, required List<DocumentSnapshot<Map<String,dynamic>>> posts , required List<AudioSource> afterUris , required AudioPlayer audioPlayer, required PostType postType ,required List<dynamic> mutesUids, required List<dynamic> blocksUids, required List<dynamic> mutesIpv6s, required List<dynamic> blocksIpv6s, required List<dynamic> mutesPostIds }) async {
  await query.endBeforeDocument(posts.first).get().then((qshot) async {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = qshot.docs;
    if (docs.isNotEmpty) {
      // Sort by oldest first
      docs.reversed;
      // Insert at the top
      docs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) {
        final String uid = doc[uidKey];
        final String ipv6 = doc[ipv6Key];
        bool x = isValidReadPost(postType: postType, mutesUids: mutesUids, blocksUids: blocksUids, mutesIpv6s: mutesIpv6s, blocksIpv6s: blocksIpv6s, uid: uid, ipv6: ipv6, mutesPostIds: mutesPostIds,doc: doc);
        if (x) {
          posts.insert(0, doc);
          Uri song = Uri.parse(doc[audioURLKey]);
          UriAudioSource source = AudioSource.uri(song, tag: doc.data());
          afterUris.insert(0, source);
        }
      });
      if (afterUris.isNotEmpty) {
        ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: afterUris);
        await audioPlayer.setAudioSource(playlist);
      }
    }
  });
}

Future<void> processBasicPosts({ required Query<Map<String, dynamic>> query, required List<DocumentSnapshot<Map<String,dynamic>>> posts , required List<AudioSource> afterUris , required AudioPlayer audioPlayer, required PostType postType ,required List<dynamic> mutesUids, required List<dynamic> blocksUids, required List<dynamic> mutesIpv6s, required List<dynamic> blocksIpv6s,required List<dynamic> mutesPostIds }) async {
  // lib/components/search/post_search/post_search_model.dartの一般化は不可能(DBのクエリでDocumentSnapshot<Map<String,dynamic>>を使用するゆえ)
  await query.get().then((qshot) async {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = qshot.docs;
    if (docs.isNotEmpty) {
      docs.sort((a,b) => b[createdAtKey].compareTo(a[createdAtKey]));
      docs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) {
        final String uid = doc[uidKey];
        final String ipv6 = doc[ipv6Key];
        bool x = isValidReadPost(postType: postType, mutesUids: mutesUids, blocksUids: blocksUids, mutesIpv6s: mutesIpv6s, blocksIpv6s: blocksIpv6s, uid: uid, ipv6: ipv6, mutesPostIds: mutesPostIds,doc: doc);
        if (x) {
          posts.add(doc);
          Uri song = Uri.parse(doc[audioURLKey]);
          UriAudioSource source = AudioSource.uri(song, tag: doc.data());
          afterUris.add(source);
        }
      });
      if (afterUris.isNotEmpty) {
        ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: afterUris);
        await audioPlayer.setAudioSource(playlist);
      }
    }
  });
}

Future<void> processOldPosts({ required Query<Map<String, dynamic>> query, required List<DocumentSnapshot<Map<String,dynamic>>> posts , required List<AudioSource> afterUris , required AudioPlayer audioPlayer, required PostType postType ,required List<dynamic> mutesUids, required List<dynamic> blocksUids, required List<dynamic> mutesIpv6s, required List<dynamic> blocksIpv6s, required List<dynamic> mutesPostIds }) async {
  await query.startAfterDocument(posts.last).get().then((qshot) async {
    final int lastIndex = posts.lastIndexOf(posts.last);
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = qshot.docs;
    if (docs.isNotEmpty) {
      docs.sort((a,b) => b[createdAtKey].compareTo(a[createdAtKey]));
      docs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) {
        final String uid = doc[uidKey];
        final String ipv6 = doc[ipv6Key];
        bool x = isValidReadPost(postType: postType, mutesUids: mutesUids, blocksUids: blocksUids, mutesIpv6s: mutesIpv6s, blocksIpv6s: blocksIpv6s, uid: uid, ipv6: ipv6, mutesPostIds: mutesPostIds, doc: doc);
        if (x) {
          posts.add(doc);
          Uri song = Uri.parse(doc[audioURLKey]);
          UriAudioSource source = AudioSource.uri(song, tag: doc.data());
          afterUris.add(source);
        }
      });
      if (afterUris.isNotEmpty) {
        ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: afterUris);
        await audioPlayer.setAudioSource(playlist,initialIndex: lastIndex);
      }
    }
  });
}

Future<void> processNewDocs({ required Query<Map<String,dynamic>> query , required List<DocumentSnapshot<Map<String,dynamic>>> docs }) async {
  await query.limit(oneTimeReadCount).endBeforeDocument(docs.first).get().then((qshot) {
    qshot.docs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) { docs.add(doc); });
  });
}

Future<void> processBasicDocs({ required Query<Map<String,dynamic>> query , required List<DocumentSnapshot<Map<String,dynamic>>> docs }) async {
  await query.limit(oneTimeReadCount).get().then((qshot) {
    qshot.docs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) { docs.add(doc); });
  });
}

Future<void> processOldDocs({ required Query<Map<String,dynamic>> query , required List<DocumentSnapshot<Map<String,dynamic>>> docs }) async {
  await query.limit(oneTimeReadCount).startAfterDocument(docs.last).get().then((qshot) {
    final queryDocs = qshot.docs;
    queryDocs.reversed;
    queryDocs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) { docs.add(doc); });
  });
}

Future<String> uploadUserImageAndGetURL({ required String uid, required File? croppedFile, required String storageImageName }) async {
  // can`t be given mainModel because of lib/auth/signup/signup_model.dart
  String getDownloadURL = '';
  try {
    final Reference storageRef = userImageChildRef(uid: uid, storageImageName: storageImageName);
    await storageRef.putFile(croppedFile!);
    getDownloadURL = await storageRef.getDownloadURL();
  } catch(e) { print(e.toString()); }
  return getDownloadURL;
}

Future updateUserInfo({ required BuildContext context ,required String userName, required String description, required String link, required MainModel mainModel, required File? croppedFile}) async {
  // if delete, can`t load old posts. My all post should be updated too.
  // if (croppedFile != null) {
  //   await userImageRef(uid: mainModel.currentUser!.uid, storageImageName: mainModel.currentUserDoc[storageImageNameKey]).delete();
  // }
  final String storageImageName = (croppedFile == null) ? mainModel.currentUserDoc[storageImageNameKey] :  storageUserImageName;
  final String downloadURL = (croppedFile == null) ? mainModel.currentUserDoc[imageURLKey] : await uploadUserImageAndGetURL(uid: mainModel.currentUser!.uid, croppedFile: croppedFile, storageImageName: storageImageName );
  if (downloadURL.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('エラーが発生。もう一度待ってからお試しください')));
  } else {
    try {
      await FirebaseFirestore.instance.collection(usersKey).doc(mainModel.currentUserDoc.id).update({
        descriptionKey: description,
        imageURLKey: downloadURL,
        linkKey: link,
        storageImageNameKey: storageImageName,
        updatedAtKey: Timestamp.now(),
        userNameKey: userName,
      });
      mainModel.reload();
    } catch(e) { print(e.toString()); }
  }
}

void showCommentOrReplyDialogue({ required BuildContext context, required String title,required TextEditingController textEditingController, required void Function(String)? onChanged,required void Function()? oncloseButtonPressed ,required Widget Function(BuildContext, FlashController<Object?>, void Function(void Function()))? send }) {
  context.showFlashBar(
    persistent: true,
    borderWidth: 3.0,
    behavior: FlashBehavior.fixed,
    forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
    title: Text(title,style: TextStyle(fontWeight: FontWeight.bold),),
    content: Form(
      child: TextFormField(
        controller: textEditingController,
        autofocus: true,
        style: TextStyle(fontWeight: FontWeight.bold),
        onChanged: onChanged,
        maxLines: maxLine,
        decoration: InputDecoration(
          suffixIcon: IconButton(onPressed: oncloseButtonPressed, icon: Icon(Icons.close))
        ),
      )
    ),
    primaryActionBuilder: send,
    negativeActionBuilder: (context,controller,__) {
      return InkWell(
        child: Icon(Icons.close),
        onTap: () {
          controller.dismiss();
        },
      );
    }
  );
}

Future follow(
      BuildContext context,
      MainModel mainModel,
      DocumentSnapshot<Map<String, dynamic>> passiveUserDoc) async {
    final followingUids = mainModel.followingUids;
    final DocumentSnapshot<Map<String,dynamic>> currentUserDoc = mainModel.currentUserDoc;
    if (followingUids.length >= 500) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('フォローできるのは500人までです')));
    } else {
      followingUids.add(passiveUserDoc[uidKey]);
      mainModel.reload();
      await updateFollowingUidsOfCurrentUser(
          followingUids, currentUserDoc, passiveUserDoc);
      await followerChildRef(
              passiveUid: passiveUserDoc.id, followerUid: currentUserDoc.id)
          .set({
        createdAtKey: Timestamp.now(),
        followerUidKey: currentUserDoc.id,
      });
    }
  }

  Future unfollow(
      MainModel mainModel,
      DocumentSnapshot<Map<String, dynamic>> passiveUserDoc) async {
    final followingUids = mainModel.followingUids;
    final DocumentSnapshot<Map<String,dynamic>> currentUserDoc = mainModel.currentUserDoc;
    followingUids.remove(passiveUserDoc[uidKey]);
    mainModel.reload();
    await updateFollowingUidsOfCurrentUser(followingUids, currentUserDoc, passiveUserDoc);
    await followerChildRef(
      passiveUid: passiveUserDoc.id, followerUid: currentUserDoc.id)
    .delete();
  }

  Future updateFollowingUidsOfCurrentUser(
      List<dynamic> followingUids,
      DocumentSnapshot<Map<String, dynamic>> currentUserDoc,
      DocumentSnapshot<Map<String, dynamic>> passiveUserDoc) async {
    await FirebaseFirestore.instance
      .collection(usersKey)
      .doc(currentUserDoc.id)
      .update({
      followingUidsKey: followingUids,
    });
  }