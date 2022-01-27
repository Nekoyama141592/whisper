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
// domain
import 'package:whisper/domain/post/post.dart';
import 'package:whisper/domain/whisper_user/whisper_user.dart';
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

void setMutesAndBlocks({ required SharedPreferences prefs ,required WhisperUser currentWhisperUser, required List<dynamic> mutesIpv6AndUids, required List<dynamic> mutesIpv6s, required List<dynamic> mutesUids , required List<dynamic>mutesPostIds, required List<dynamic> blocksIpv6AndUids, required List<dynamic> blocksIpv6s, required List<dynamic> blocksUids }) {
  // 代入は使えないが.addは反映される
  currentWhisperUser.mutesIpv6AndUids.forEach((mutesIpv6AndUid) { mutesIpv6AndUids.add(mutesIpv6AndUid); });
  mutesIpv6AndUids.forEach((mutesIpv6AndUid) {
    mutesIpv6s.add(mutesIpv6AndUid[ipv6Key]);
    mutesUids.add(mutesIpv6AndUid[uidKey]);
  });
  (prefs.getStringList(mutesPostIdsKey) ?? []).forEach((mutesPostId) { mutesPostIds.add(mutesPostId); }) ;
  currentWhisperUser.blocksIpv6AndUids.forEach((blocksIpv6AndUid) { blocksIpv6AndUids.add(blocksIpv6AndUid); });
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

Future<void> updateMutesIpv6AndUids({ required List<dynamic> mutesIpv6AndUids, required WhisperUser currentWhisperUser }) async {
  await FirebaseFirestore.instance.collection(usersKey).doc(currentWhisperUser.uid)
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

Future<void> updateBlocksIpv6AndUids({ required List<dynamic> blocksIpv6AndUids, required WhisperUser currentWhisperUser }) async {
  await FirebaseFirestore.instance.collection(usersKey).doc(currentWhisperUser.uid)
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
  speedNotifier.value = prefs.getDouble(speedPrefsKey) ?? 1.0;
  await audioPlayer.setSpeed(speedNotifier.value);
}

Future<void> speedControll({ required ValueNotifier<double> speedNotifier, required SharedPreferences prefs, required AudioPlayer audioPlayer }) async {
  if (speedNotifier.value == 4.0) {
    speedNotifier.value = 1.0;
    await audioPlayer.setSpeed(speedNotifier.value);
    await prefs.setDouble(speedPrefsKey, speedNotifier.value);
  } else {
    speedNotifier.value += 0.5;
    await audioPlayer.setSpeed(speedNotifier.value);
    await prefs.setDouble(speedPrefsKey, speedNotifier.value);
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
  }

void pause({ required AudioPlayer audioPlayer}) {
  audioPlayer.pause();
}

void onPostDeleteButtonPressed({ required BuildContext context, required AudioPlayer audioPlayer,required Map<String,dynamic> postMap, required List<AudioSource> afterUris, required List<dynamic> posts,required MainModel mainModel, required int i}) {
  showCupertinoDialogue(context: context, title: '投稿削除', content: '一度削除したら、復元はできません。本当に削除しますか？', action: () async { await deletePost(context: context, audioPlayer: audioPlayer, postMap: postMap, afterUris: afterUris, posts: posts, mainModel: mainModel, i: i) ;});
}

Future deletePost({ required BuildContext context, required AudioPlayer audioPlayer,required Map<String,dynamic> postMap, required List<AudioSource> afterUris, required List<dynamic> posts,required MainModel mainModel, required int i}) async {
  Navigator.pop(context);
  final whisperPost = fromMapToPost(postMap: postMap);
  if (mainModel.currentUser!.uid != whisperPost.uid) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('あなたにはその権限がありません')));
  } else {
    try {
      posts.remove(posts[i]);
      await resetAudioPlayer(afterUris: afterUris, audioPlayer: audioPlayer, i: i);
      mainModel.reload();
      await FirebaseFirestore.instance.collection(postsKey).doc(whisperPost.postId).delete();
      await postChildRef(mainModel: mainModel, storagePostName: whisperPost.storagePostName).delete();
      if (whisperPost.storageImageName.isNotEmpty) {
        await postImageChildRef(mainModel: mainModel, postImageName: whisperPost.storageImageName ).delete();
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
  final Post whisperPost = fromMapToPost(postMap: post);
  final String postId = whisperPost.postId;
  mainModel.mutesPostIds.add(postId);
  results.removeWhere((result) => result[postIdKey] == postId);
  await resetAudioPlayer(afterUris: afterUris, audioPlayer: audioPlayer, i: i);
  mainModel.reload();
  await mainModel.prefs.setStringList(mutesPostIdsKey, mainModel.mutesPostIds);
}

Future muteUser({ required AudioPlayer audioPlayer, required List<AudioSource> afterUris, required List<dynamic> mutesUids, required int i, required List<dynamic> results,required List<dynamic> mutesIpv6AndUids, required Map<String,dynamic> post, required MainModel mainModel}) async {
  final whisperPost = fromMapToPost(postMap: post);
  final String passiveUid = whisperPost.uid;
  await removeTheUsersPost(results: results, passiveUid: passiveUid, afterUris: afterUris, audioPlayer: audioPlayer, i: i);
  addMutesUidAndMutesIpv6AndUid(mutesIpv6AndUids: mutesIpv6AndUids,mutesUids: mutesUids,map: post);
  mainModel.reload();
  await updateMutesIpv6AndUids(mutesIpv6AndUids: mutesIpv6AndUids, currentWhisperUser: mainModel.currentWhisperUser);
}

Future blockUser({ required AudioPlayer audioPlayer, required List<AudioSource> afterUris, required List<dynamic> blocksUids, required List<dynamic> blocksIpv6AndUids, required int i, required List<dynamic> results, required Map<String,dynamic> post, required MainModel mainModel}) async {
  final whisperPost = fromMapToPost(postMap: post);
  final String passiveUid = whisperPost.uid;
  await removeTheUsersPost(results: results, passiveUid: passiveUid, afterUris: afterUris, audioPlayer: audioPlayer, i: i);
  addBlocksUidsAndBlocksIpv6AndUid(blocksIpv6AndUids: blocksIpv6AndUids,blocksUids: blocksUids,map: post);
  mainModel.reload();
  await updateBlocksIpv6AndUids(blocksIpv6AndUids: blocksIpv6AndUids, currentWhisperUser: mainModel.currentWhisperUser);
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
        final whisperPost = fromMapToPost(postMap: doc.data()!);
        final String uid = whisperPost.uid;
        final String ipv6 = whisperPost.ipv6;
        bool x = isValidReadPost(postType: postType, mutesUids: mutesUids, blocksUids: blocksUids, mutesIpv6s: mutesIpv6s, blocksIpv6s: blocksIpv6s, uid: uid, ipv6: ipv6, mutesPostIds: mutesPostIds,doc: doc);
        if (x) {
          posts.insert(0, doc);
          Uri song = Uri.parse(whisperPost.audioURL);
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
  await query.get().then((qshot) async {
    await basicProcessContent(docs: qshot.docs, posts: posts, afterUris: afterUris, audioPlayer: audioPlayer, postType: postType, mutesUids: mutesUids, blocksUids: blocksUids, mutesIpv6s: mutesIpv6s, blocksIpv6s: blocksIpv6s, mutesPostIds: mutesPostIds);
  });
}

Future<void> basicProcessContent({ required List<DocumentSnapshot<Map<String, dynamic>>> docs ,required List<DocumentSnapshot<Map<String,dynamic>>> posts , required List<AudioSource> afterUris , required AudioPlayer audioPlayer, required PostType postType ,required List<dynamic> mutesUids, required List<dynamic> blocksUids, required List<dynamic> mutesIpv6s, required List<dynamic> blocksIpv6s,required List<dynamic> mutesPostIds }) async {
  
  if (docs.isNotEmpty) {
    docs.sort((a,b) => (b[createdAtKey] as Timestamp).compareTo(a[createdAtKey]));
    docs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) {
      final whisperPost = fromMapToPost(postMap: doc.data()! );
      final String uid = whisperPost.uid;
      final String ipv6 = whisperPost.ipv6;
      bool x = isValidReadPost(postType: postType, mutesUids: mutesUids, blocksUids: blocksUids, mutesIpv6s: mutesIpv6s, blocksIpv6s: blocksIpv6s, uid: uid, ipv6: ipv6, mutesPostIds: mutesPostIds,doc: doc);
      if (x) {
        posts.add(doc);
        Uri song = Uri.parse(whisperPost.audioURL);
        UriAudioSource source = AudioSource.uri(song, tag: doc.data());
        afterUris.add(source);
      }
    });
    if (afterUris.isNotEmpty) {
      ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: afterUris);
      await audioPlayer.setAudioSource(playlist);
    }
  }
}

Future<void> processOldPosts({ required Query<Map<String, dynamic>> query, required List<DocumentSnapshot<Map<String,dynamic>>> posts , required List<AudioSource> afterUris , required AudioPlayer audioPlayer, required PostType postType ,required List<dynamic> mutesUids, required List<dynamic> blocksUids, required List<dynamic> mutesIpv6s, required List<dynamic> blocksIpv6s, required List<dynamic> mutesPostIds }) async {
  await query.startAfterDocument(posts.last).get().then((qshot) async {
    final int lastIndex = posts.lastIndexOf(posts.last);
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = qshot.docs;
    if (docs.isNotEmpty) {
      docs.sort((a,b) => (b[createdAtKey] as Timestamp ).compareTo(a[createdAtKey]));
      docs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) {
        final whisperPost = fromMapToPost(postMap: doc.data()! );
        final String uid = whisperPost.uid;
        final String ipv6 = whisperPost.ipv6;
        bool x = isValidReadPost(postType: postType, mutesUids: mutesUids, blocksUids: blocksUids, mutesIpv6s: mutesIpv6s, blocksIpv6s: blocksIpv6s, uid: uid, ipv6: ipv6, mutesPostIds: mutesPostIds, doc: doc);
        if (x) {
          posts.add(doc);
          Uri song = Uri.parse(whisperPost.audioURL);
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

Future updateUserInfo({ required BuildContext context ,required String userName, required String description, required List<dynamic> links, required MainModel mainModel, required File? croppedFile}) async {
  // if delete, can`t load old posts. My all post should be updated too.
  // if (croppedFile != null) {
  //   await userImageRef(uid: mainModel.currentUser!.uid, storageImageName: mainModel.currentWhisperUser.storageImageName).delete();
  // }
  final DateTime now = DateTime.now();
  final String storageImageName = (croppedFile == null) ? mainModel.currentWhisperUser.storageImageName :  storageUserImageName(now: now);
  final String downloadURL = (croppedFile == null) ? mainModel.currentWhisperUser.imageURL : await uploadUserImageAndGetURL(uid: mainModel.currentUser!.uid, croppedFile: croppedFile, storageImageName: storageImageName );
  if (downloadURL.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('エラーが発生。もう一度待ってからお試しください')));
  } else {
    try {
      WhisperUser currentWhisperUser = mainModel.currentWhisperUser;
      currentWhisperUser.description = description;
      currentWhisperUser.imageURL = downloadURL;
      currentWhisperUser.links = links;
      currentWhisperUser.storageImageName = storageImageName;
      currentWhisperUser.updatedAt = Timestamp.fromDate(now);
      currentWhisperUser.userName = userName;
      await FirebaseFirestore.instance.collection(usersKey).doc(mainModel.currentWhisperUser.uid).update(
        currentWhisperUser.toJson()
      );
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
    WhisperUser currentWhisperUser) async {
  final followingUids = mainModel.followingUids;
  if (followingUids.length >= 500) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('フォローできるのは500人までです')));
  } else {
    followingUids.add(currentWhisperUser.uid);
    mainModel.reload();
    await updateFollowingUidsOfCurrentUser(
        followingUids, mainModel.currentWhisperUser);
    await followerChildRef(
            passiveUid: currentWhisperUser.uid, followerUid: mainModel.currentWhisperUser.uid)
        .set({
      createdAtKey: Timestamp.now(),
      followerUidKey: mainModel.currentWhisperUser.uid,
    });
  }
}

Future unfollow(
    MainModel mainModel,
    WhisperUser currentWhisperUser) async {
  final followingUids = mainModel.followingUids;
  followingUids.remove(currentWhisperUser.uid);
  mainModel.reload();
  await updateFollowingUidsOfCurrentUser(followingUids, mainModel.currentWhisperUser);
  await followerChildRef(
    passiveUid: currentWhisperUser.uid, followerUid: mainModel.currentWhisperUser.uid)
  .delete();
}

Future<void> updateFollowingUidsOfCurrentUser(
    List<dynamic> followingUids,
    WhisperUser currentWhisperUser,) async {
  await FirebaseFirestore.instance
    .collection(usersKey)
    .doc(currentWhisperUser.uid)
    .update({
    followingUidsKey: followingUids,
  });
}
void showFlashDialogue({ required BuildContext context,required Widget content, required Widget Function(BuildContext, FlashController<Object?>, void Function(void Function()))? positiveActionBuilder }) {
    context.showFlashDialog(
      persistent: true,
      title: Text('Flash Dialog'),
      content: content,
      negativeActionBuilder: (context, controller, _) {
        return TextButton(
          onPressed: () {
            controller.dismiss();
          },
          child: Text('NO',style: textStyle(context: context),),
        );
      },
      positiveActionBuilder: positiveActionBuilder,
    );
  }