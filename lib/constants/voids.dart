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
import 'package:whisper/domain/following/following.dart';
import 'package:whisper/domain/mute_post/mute_post.dart';
// domain
import 'package:whisper/domain/post/post.dart';
import 'package:whisper/domain/mute_user/mute_user.dart';
import 'package:whisper/domain/block_user/block_user.dart';
import 'package:whisper/domain/user_meta/user_meta.dart';
import 'package:whisper/domain/whisper_user/whisper_user.dart';
import 'package:whisper/domain/whisper_link/whisper_link.dart';
import 'package:whisper/domain/reply_notification/reply_notification.dart';
import 'package:whisper/domain/comment_notification/comment_notification.dart';
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

 
Future<void> signOut(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.pop(context);
  routes.toIsFinishedPage(context: context, title: 'ログアウトしました', text: 'お疲れ様でした');
}

void showCupertinoDialogue({required BuildContext context, required String title, required String content, required void Function()? action}) {
  showCupertinoDialog(
    context: context, 
    builder: (innerContext) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        CupertinoDialogAction(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(innerContext);
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

Future<void> onCommentNotificationPressed({ required BuildContext context ,required MainModel mainModel , required OnePostModel onePostModel ,required OneCommentModel oneCommentModel, required  CommentNotification commentNotification }) async {
  commentNotification.isRead = true;
  bool postExists = await onePostModel.init(postId: commentNotification.postId, postDocRef: commentNotification.postDocRef as DocumentReference<Map<String,dynamic>> );
  if (postExists) {
    bool commentExists = await oneCommentModel.init(postCommentId: commentNotification.postCommentId, postCommentDocRef: commentNotification.postCommentDocRef as DocumentReference<Map<String,dynamic>> );
    if (commentExists) {
      routes.toOneCommentPage(context: context, mainModel: mainModel);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('そのコメントは削除されています')));
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('元の投稿が削除されています')));
  }
  mainModel.reload();
}

Future<void> onReplyNotificationPressed({ required BuildContext context ,required MainModel mainModel , required OnePostModel onePostModel ,required OneCommentModel oneCommentModel, required  ReplyNotification replyNotification }) async {
  replyNotification.isRead = true;
  bool postExists = await onePostModel.init(postId: replyNotification.postId, postDocRef: replyNotification.postDocRef as DocumentReference<Map<String,dynamic>> );
  if (postExists) {
    bool commentExists = await oneCommentModel.init(postCommentId: replyNotification.postCommentId, postCommentDocRef: replyNotification.postCommentDocRef as DocumentReference<Map<String,dynamic>> );
    if (commentExists) {
      routes.toOneCommentPage(context: context, mainModel: mainModel);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('そのコメントは削除されています')));
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('元の投稿が削除されています')));
  }
  mainModel.reload();
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

void listenForStates({ required AudioPlayer audioPlayer, required PlayButtonNotifier playButtonNotifier, required ProgressNotifier progressNotifier, required ValueNotifier<Post?> currentWhisperPostNotifier, required ValueNotifier<bool> isShuffleModeEnabledNotifier, required ValueNotifier<bool> isFirstSongNotifier, required ValueNotifier<bool> isLastSongNotifier}) {
  listenForChangesInPlayerState(audioPlayer: audioPlayer, playButtonNotifier: playButtonNotifier);
  listenForChangesInPlayerPosition(audioPlayer: audioPlayer, progressNotifier: progressNotifier);
  listenForChangesInBufferedPosition(audioPlayer: audioPlayer, progressNotifier: progressNotifier);
  listenForChangesInTotalDuration(audioPlayer: audioPlayer, progressNotifier: progressNotifier);
  listenForChangesInSequenceState(audioPlayer: audioPlayer, currentWhisperPostNotifier: currentWhisperPostNotifier, isShuffleModeEnabledNotifier: isShuffleModeEnabledNotifier, isFirstSongNotifier: isFirstSongNotifier, isLastSongNotifier: isLastSongNotifier);
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

void listenForChangesInSequenceState({ required AudioPlayer audioPlayer, required ValueNotifier<Post?> currentWhisperPostNotifier, required ValueNotifier<bool> isShuffleModeEnabledNotifier, required ValueNotifier<bool> isFirstSongNotifier, required ValueNotifier<bool> isLastSongNotifier }) {
  audioPlayer.sequenceStateStream.listen((sequenceState) {
    if (sequenceState == null) return;
    // update current song doc
    final currentItem = sequenceState.currentSource;
    final Post currentWhisperPost = currentItem?.tag;
    currentWhisperPostNotifier.value = currentWhisperPost;
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

Future<void> deletePost({ required BuildContext context, required AudioPlayer audioPlayer,required Map<String,dynamic> postMap, required List<AudioSource> afterUris, required List<dynamic> posts,required MainModel mainModel, required int i}) async {
  Navigator.pop(context);
  final whisperPost = fromMapToPost(postMap: postMap);
  if (mainModel.currentUser!.uid != whisperPost.uid) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('あなたにはその権限がありません')));
  } else {
    try {
      posts.remove(posts[i]);
      await resetAudioPlayer(afterUris: afterUris, audioPlayer: audioPlayer, i: i);
      mainModel.reload();
      await returnPostDocRef(postCreatorUid: whisperPost.uid, postId: whisperPost.postId ).delete();
      await returnRefFromPost(post: whisperPost).delete();
      if (isImageExist(post: whisperPost) == true) {
        await returnPostImagePostRef(mainModel: mainModel, postId: whisperPost.postId).delete();
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

Future<void> initAudioPlayer({ required AudioPlayer audioPlayer, required List<AudioSource> afterUris ,required int i}) async {
  ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: afterUris);
  await audioPlayer.setAudioSource(playlist,initialIndex: i);
}

Future<void> mutePost({ required MainModel mainModel, required int i, required Map<String,dynamic> post, required List<AudioSource> afterUris, required AudioPlayer audioPlayer , required List<dynamic> results}) async {
  final Post whisperPost = fromMapToPost(postMap: post);
  final String postId = whisperPost.postId;
  mainModel.mutePostIds.add(postId);
  results.removeWhere((result) => fromMapToPost(postMap: result).postId == whisperPost.postId );
  await resetAudioPlayer(afterUris: afterUris, audioPlayer: audioPlayer, i: i);
  mainModel.reload();
  final Timestamp now = Timestamp.now();
  final String tokenId = returnTokenId(userMeta: mainModel.userMeta, tokenType: TokenType.mutePost );
  final MutePost mutePost = MutePost(activeUid: mainModel.userMeta.uid, createdAt: now, postId: postId,tokenId: tokenId,passiveUid: whisperPost.uid,tokenType: mutePostTokenType );
  await returnTokenDocRef(uid: mainModel.userMeta.uid, tokenId: tokenId).set(mutePost.toJson());
}

Future<void> muteUser({ required AudioPlayer audioPlayer, required List<AudioSource> afterUris, required List<String> mutesUids, required int i, required List<dynamic> results,required List<MuteUser> muteUsers, required Map<String,dynamic> post, required MainModel mainModel}) async {
  final whisperPost = fromMapToPost(postMap: post);
  final String passiveUid = whisperPost.uid;
  await removeTheUsersPost(results: results, passiveUid: passiveUid, afterUris: afterUris, audioPlayer: audioPlayer, i: i);
  mainModel.muteUids.add(passiveUid);
  final Timestamp now = Timestamp.now();
  final String tokenId = returnTokenId(userMeta: mainModel.userMeta, tokenType: TokenType.muteUser );
  final MuteUser muteUser = MuteUser(activeUid: firebaseAuthCurrentUser!.uid,createdAt: now,ipv6: whisperPost.ipv6,passiveUid: passiveUid,tokenId: tokenId, tokenType: muteUserTokenType );
  mainModel.muteUsers.add(muteUser);
  mainModel.reload();
  await returnTokenDocRef(uid: mainModel.userMeta.uid, tokenId: tokenId).set(muteUser.toJson());
}

Future<void> blockUser({ required AudioPlayer audioPlayer, required List<AudioSource> afterUris, required List<String> blocksUids, required List<BlockUser> blockUsers, required int i, required List<dynamic> results, required Map<String,dynamic> post, required MainModel mainModel}) async {
  final whisperPost = fromMapToPost(postMap: post);
  final String passiveUid = whisperPost.uid;
  await removeTheUsersPost(results: results, passiveUid: passiveUid, afterUris: afterUris, audioPlayer: audioPlayer, i: i);
  blocksUids.add(passiveUid);
  final Timestamp now = Timestamp.now();
  final String tokenId = returnTokenId(userMeta: mainModel.userMeta, tokenType: TokenType.blockUser );
  final BlockUser blockUser = BlockUser(createdAt: now,ipv6: whisperPost.ipv6,activeUid: mainModel.userMeta.uid,passiveUid: passiveUid,tokenId: tokenId, tokenType: blockUserTokenType );
  blockUsers.add(blockUser);
  mainModel.reload();
  await returnTokenDocRef(uid: mainModel.userMeta.uid, tokenId: tokenId).set(blockUser.toJson());
}

Future<void> removeTheUsersPost({ required List<dynamic> results,required String passiveUid, required List<AudioSource> afterUris, required AudioPlayer audioPlayer,required int i}) async {
  results.removeWhere((result) => fromMapToPost(postMap: result).uid == passiveUid);
  await resetAudioPlayer(afterUris: afterUris, audioPlayer: audioPlayer, i: i);
}

Future<void> processNewPosts({ required Query<Map<String, dynamic>> query, required List<DocumentSnapshot<Map<String,dynamic>>> posts , required List<AudioSource> afterUris , required AudioPlayer audioPlayer, required PostType postType ,required List<String> mutesUids, required List<String> blocksUids, required List<String> mutesIpv6s, required List<String> blocksIpv6s, required List<String> mutesPostIds }) async {
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
          UriAudioSource source = AudioSource.uri(song, tag: whisperPost );
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

Future<void> processBasicPosts({ required Query<Map<String, dynamic>> query, required List<DocumentSnapshot<Map<String,dynamic>>> posts , required List<AudioSource> afterUris , required AudioPlayer audioPlayer, required PostType postType ,required List<String> muteUids, required List<String> blockUids, required List<String> muteIpv6s, required List<String> blockIpv6s,required List<String> mutePostIds }) async {
  await query.get().then((qshot) async {
    await basicProcessContent(docs: qshot.docs, posts: posts, afterUris: afterUris, audioPlayer: audioPlayer, postType: postType, mutesUids: muteUids, blocksUids: blockUids, mutesIpv6s: muteIpv6s, blocksIpv6s: blockIpv6s, mutesPostIds: mutePostIds);
  });
}

Future<void> basicProcessContent({ required List<DocumentSnapshot<Map<String, dynamic>>> docs ,required List<DocumentSnapshot<Map<String,dynamic>>> posts , required List<AudioSource> afterUris , required AudioPlayer audioPlayer, required PostType postType ,required List<String> mutesUids, required List<String> blocksUids, required List<String> mutesIpv6s, required List<String> blocksIpv6s,required List<String> mutesPostIds }) async {
  
  if (docs.isNotEmpty) {
    docs.sort((a,b) => (fromMapToPost(postMap: b.data()!).createdAt as Timestamp).compareTo( fromMapToPost(postMap: a.data()!).createdAt ));
    docs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) {
      final whisperPost = fromMapToPost(postMap: doc.data()! );
      final String uid = whisperPost.uid;
      final String ipv6 = whisperPost.ipv6;
      bool x = isValidReadPost(postType: postType, mutesUids: mutesUids, blocksUids: blocksUids, mutesIpv6s: mutesIpv6s, blocksIpv6s: blocksIpv6s, uid: uid, ipv6: ipv6, mutesPostIds: mutesPostIds,doc: doc);
      if (x) {
        posts.add(doc);
        Uri song = Uri.parse(whisperPost.audioURL);
        UriAudioSource source = AudioSource.uri(song, tag: whisperPost );
        afterUris.add(source);
      }
    });
    if (afterUris.isNotEmpty) {
      ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: afterUris);
      await audioPlayer.setAudioSource(playlist);
    }
  }
}

Future<void> processOldPosts({ required Query<Map<String, dynamic>> query, required List<DocumentSnapshot<Map<String,dynamic>>> posts , required List<AudioSource> afterUris , required AudioPlayer audioPlayer, required PostType postType ,required List<String> mutesUids, required List<String> blocksUids, required List<String> mutesIpv6s, required List<String> blocksIpv6s, required List<String> mutesPostIds }) async {
  await query.startAfterDocument(posts.last).get().then((qshot) async {
    final int lastIndex = posts.lastIndexOf(posts.last);
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = qshot.docs;
    if (docs.isNotEmpty) {
      docs.sort((a,b) => (fromMapToPost(postMap: b.data()).createdAt as Timestamp).compareTo( fromMapToPost(postMap: a.data()).createdAt ));
      docs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) {
        final whisperPost = fromMapToPost(postMap: doc.data()! );
        final String uid = whisperPost.uid;
        final String ipv6 = whisperPost.ipv6;
        bool x = isValidReadPost(postType: postType, mutesUids: mutesUids, blocksUids: blocksUids, mutesIpv6s: mutesIpv6s, blocksIpv6s: blocksIpv6s, uid: uid, ipv6: ipv6, mutesPostIds: mutesPostIds, doc: doc);
        if (x) {
          posts.add(doc);
          Uri song = Uri.parse(whisperPost.audioURL);
          UriAudioSource source = AudioSource.uri(song, tag: whisperPost );
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
    final Reference storageRef = returnUserImageChildRef(uid: uid, storageImageName: storageImageName);
    await storageRef.putFile(croppedFile!);
    getDownloadURL = await storageRef.getDownloadURL();
  } catch(e) { print(e.toString()); }
  return getDownloadURL;
}

Future<void> updateUserInfo({ required BuildContext context ,required List<WhisperLink> links, required WhisperUser updateWhisperUser, required File? croppedFile,required MainModel mainModel }) async {
  // if delete, can`t load old posts. My all post should be updated too.
  // if (croppedFile != null) {
  //   await userImageRef(uid: mainModel.currentUser!.uid, storageImageName: mainModel.currentWhisperUser.storageImageName).delete();
  // }
  final DateTime now = DateTime.now();
  updateWhisperUser.links = links.map((e) => e.toJson()).toList();
  updateWhisperUser.updatedAt = Timestamp.fromDate(now);
  if (croppedFile != null) {
    final String storageImageName = returnStorageUserImageName();
    final String downloadURL = await uploadUserImageAndGetURL(uid: updateWhisperUser.uid, croppedFile: croppedFile, storageImageName: storageImageName );
    updateWhisperUser.imageURL = downloadURL;
  }
  await FirebaseFirestore.instance.collection(usersFieldKey).doc(updateWhisperUser.uid).update( updateWhisperUser.toJson() );
  mainModel.reload();
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

Future<void> follow({ required BuildContext context,required MainModel mainModel, required String passiveUid }) async {
  
  if (mainModel.followingUids.length >= maxFollowCount) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Limit' + maxFollowCount.toString() + 'Following' )));
  } else {
    mainModel.followingUids.add(passiveUid);
    mainModel.reload();
    await createFollowingToken(userMeta: mainModel.userMeta, passiveUid: passiveUid);
  }
}

Future<void> unfollow({ required MainModel mainModel,required String passiveUid }) async {
  mainModel.followingUids.remove(passiveUid);
  mainModel.reload();
  await deleteFollowingToken(mainModel: mainModel, passiveUid: passiveUid);
}

Future<void> createFollowingToken({ required UserMeta userMeta,required String passiveUid }) async {
  final Timestamp now = Timestamp.now();
  final String activeUid = userMeta.uid;
  final String tokenId = returnTokenId(userMeta: userMeta, tokenType: TokenType.following );
  final Following following = Following(myUid: activeUid, createdAt: now, passiveUid: passiveUid,tokenId: tokenId, tokenType: followingTokenType );
  await returnTokenDocRef(uid: activeUid, tokenId: tokenId).set(following.toJson());
}

Future<void> deleteFollowingToken({ required MainModel mainModel, required String passiveUid }) async {
  final deleteFollowingToken = mainModel.following.where((element) => element.passiveUid == passiveUid).first;
  await returnTokenDocRef(uid: mainModel.userMeta.uid, tokenId: deleteFollowingToken.tokenId ).delete();
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
