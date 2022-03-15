// dart
import 'dart:io';
// material
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
// packages
import 'package:flash/flash.dart';
import 'package:clipboard/clipboard.dart';
import 'package:just_audio/just_audio.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
// constants
import 'package:whisper/constants/enums.dart';
import 'package:whisper/constants/bools.dart';
import 'package:whisper/constants/lists.dart';
import 'package:whisper/constants/maps.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/ints.dart';
import 'package:whisper/constants/routes.dart' as routes;
import 'package:whisper/constants/strings.dart';
// domain
import 'package:whisper/domain/post/post.dart';
import 'package:whisper/domain/user_update_log/user_update_log.dart';
import 'package:whisper/domain/whisper_user/whisper_user.dart';
import 'package:whisper/domain/whisper_link/whisper_link.dart';
// notifiers
import 'package:whisper/posts/notifiers/play_button_notifier.dart';
import 'package:whisper/posts/notifiers/progress_notifier.dart';
import 'package:whisper/posts/notifiers/repeat_button_notifier.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/official_advertisements/official_advertisement_model.dart';
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

Future<void> play({ required BuildContext context ,required AudioPlayer audioPlayer, required MainModel mainModel ,required String postId ,required OfficialAdvertisementsModel officialAdsensesModel })  async {
    audioPlayer.play();
    await officialAdsensesModel.onPlayButtonPressed(context);
  }

void pause({ required AudioPlayer audioPlayer}) {
  audioPlayer.pause();
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

Future<void> processNewPosts({ required Query<Map<String, dynamic>> query, required List<DocumentSnapshot<Map<String,dynamic>>> posts , required List<AudioSource> afterUris , required AudioPlayer audioPlayer, required PostType postType , required List<String> muteUids, required  List<String> blockUids , required List<String> mutesPostIds }) async {
  await query.endBeforeDocument(posts.first).get().then((qshot) async {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = qshot.docs;
    if (docs.isNotEmpty) {
      // Sort by oldest first
      docs.reversed;
      // Insert at the top
      docs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) {
        final whisperPost = fromMapToPost(postMap: doc.data()!);
        final String uid = whisperPost.uid;
        bool x = isValidReadPost(postType: postType, muteUids: muteUids, blockUids: blockUids, uid: uid, mutesPostIds: mutesPostIds, doc: doc);
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

Future<void> processBasicPosts({ required Query<Map<String, dynamic>> query, required List<DocumentSnapshot<Map<String,dynamic>>> posts , required List<AudioSource> afterUris , required AudioPlayer audioPlayer, required PostType postType ,required List<String> muteUids, required List<String> blockUids, required List<String> mutePostIds }) async {
  await query.get().then((qshot) async {
    await basicProcessContent(docs: qshot.docs, posts: posts, afterUris: afterUris, audioPlayer: audioPlayer, postType: postType, muteUids: muteUids, blockUids: blockUids, mutesPostIds: mutePostIds);
  });
}

Future<void> basicProcessContent({ required List<DocumentSnapshot<Map<String, dynamic>>> docs ,required List<DocumentSnapshot<Map<String,dynamic>>> posts , required List<AudioSource> afterUris , required AudioPlayer audioPlayer, required PostType postType , required List<String> muteUids, required  List<String> blockUids ,required List<String> mutesPostIds }) async {
  
  if (docs.isNotEmpty) {
    docs.sort((a,b) => (fromMapToPost(postMap: b.data()!).createdAt as Timestamp).compareTo( fromMapToPost(postMap: a.data()!).createdAt ));
    docs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) {
      final whisperPost = fromMapToPost(postMap: doc.data()! );
      final String uid = whisperPost.uid;
      bool x = isValidReadPost(postType: postType, muteUids: muteUids, blockUids: blockUids, uid: uid, mutesPostIds: mutesPostIds, doc: doc);
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

Future<void> processOldPosts({ required Query<Map<String, dynamic>> query, required List<DocumentSnapshot<Map<String,dynamic>>> posts , required List<AudioSource> afterUris , required AudioPlayer audioPlayer, required PostType postType , required List<String> muteUids, required  List<String> blockUids , required List<String> mutesPostIds }) async {
  await query.startAfterDocument(posts.last).get().then((qshot) async {
    final int lastIndex = posts.lastIndexOf(posts.last);
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = qshot.docs;
    if (docs.isNotEmpty) {
      docs.sort((a,b) => (fromMapToPost(postMap: b.data()).createdAt as Timestamp).compareTo( fromMapToPost(postMap: a.data()).createdAt ));
      docs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) {
        final whisperPost = fromMapToPost(postMap: doc.data()! );
        final String uid = whisperPost.uid;
  
        bool x = isValidReadPost(postType: postType, muteUids: muteUids, blockUids: blockUids, uid: uid, mutesPostIds: mutesPostIds, doc: doc);
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
    queryDocs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) { docs.insert(0, doc ); });
  });
}

Future<String> uploadUserImageAndGetURL({ required String uid, required File? croppedFile, required String storageImageName }) async {
  // can`t be given mainModel because of lib/auth/signup/signup_model.dart
  String getDownloadURL = '';
  try {
    final Reference storageRef = returnUserImageChildRef(uid: uid, storageImageName: storageImageName);
    await putImage(imageRef: storageRef, file: croppedFile! );
    getDownloadURL = await storageRef.getDownloadURL();
  } catch(e) { print(e.toString()); }
  return getDownloadURL;
}

Future<void> updateUserInfo({ required BuildContext context , required WhisperUser updateWhisperUser, required String userName ,required File? croppedFile,required MainModel mainModel }) async {
  // if delete, can`t load old posts. My all post should be updated too.
  // if (croppedFile != null) {
  //   await userImageRef(uid: mainModel.currentUser!.uid, storageImageName: mainModel.currentWhisperUser.storageImageName).delete();
  // }
  if (userName.isNotEmpty) {
    updateWhisperUser.userName = userName;
    updateWhisperUser.searchToken = returnSearchToken(searchWords: returnSearchWords(searchTerm: userName) );
  }
  
  if (croppedFile != null) {
    final String storageImageName = returnStorageUserImageName();
    final String downloadURL = await uploadUserImageAndGetURL(uid: updateWhisperUser.uid, croppedFile: croppedFile, storageImageName: storageImageName );
    updateWhisperUser.userImageURL = downloadURL;
  }
  final Timestamp now = Timestamp.now();
  final UserUpdateLog userUpdateLog = UserUpdateLog(accountName: updateWhisperUser.accountName,imageURL: updateWhisperUser.userImageURL, mainWalletAddress: updateWhisperUser.mainWalletAddress, recommendState: updateWhisperUser.recommendState, searchToken: updateWhisperUser.searchToken, uid: updateWhisperUser.uid, userName: userName, updatedAt: now );
  await returnUserUpdateLogDocRef(uid: updateWhisperUser.uid, userUpdateLogId: generateUserUpdateLogId() ).set(userUpdateLog.toJson());
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

void showFlashDialogue({ required BuildContext context,required Widget content, required String titleText ,required Widget Function(BuildContext, FlashController<Object?>, void Function(void Function()))? positiveActionBuilder }) {
  context.showFlashDialog(
    persistent: true,
    title: Text(titleText),
    content: content,
    negativeActionBuilder: (context, controller, _) {
      return TextButton(
        onPressed: () {
          controller.dismiss();
        },
        child: Text('Cancel',style: cancelStyle(context: context)),
      );
    },
    positiveActionBuilder: positiveActionBuilder,
  );
}
Future<void> putImage({ required Reference imageRef,required File file }) async {
  await imageRef.putFile(file,imageMetadata);
}
Future<void> putPost({ required Reference postRef,required File postFile }) async {
  await postRef.putFile(postFile,postMetadata);
}

Future<void> showLinkDialogue({ required BuildContext context, required String link }) async {
  if ( await canLaunch(link)) {
    showCupertinoDialog(
      context: context, 
      builder: (innerContext) {
        return CupertinoAlertDialog(
          title: Text('ページ遷移'),
          content: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: link,
                  style: TextStyle(
                    color: Theme.of(context).highlightColor,
                    fontWeight: FontWeight.bold
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () async {
                    await FlutterClipboard.copy(link).then((_) {
                      showSnackBar(context: context, text: '固有のユーザー名をコピーしました');
                    });
                  },
                ),
                TextSpan(
                  text: 'に移動します。',
                  style: TextStyle(
                    color: Theme.of(context).focusColor,
                    fontWeight: FontWeight.bold,
                  )
                )
              ]
            )
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(innerContext);
              },
            ),
            CupertinoDialogAction(
              child: const Text('Ok'),
              isDestructiveAction: true,
              onPressed: () async {
                Navigator.pop(innerContext);
                await Future.delayed(Duration(seconds: 1));
                await launch(link);
              },
            )
          ],
        );
      }
    );
  } else {
    showSnackBar(context: context, text: 'このURLは無効です' );
  }
}

void showLinkCupertinoModalPopup({ required BuildContext context,required List<WhisperLink> whisperLinks }) {
  showCupertinoModalPopup(
      context: context, 
      builder: (innerContext) {
        final List<Widget> actions = 
        whisperLinks.map((whisperLink) => CupertinoActionSheetAction(
          child: Text(whisperLink.label,style: textStyle(context: context),),
          onPressed: () {
            showLinkDialogue(context: context, link: whisperLink.link );
          }, 
        ) ).toList();
        actions.add(CupertinoActionSheetAction(
          child: Text('Cancel',style: textStyle(context: context),),
          onPressed: () { Navigator.pop(innerContext); },
        ));
        return CupertinoActionSheet(
          actions: actions
        );
      }
    );  
}

void onAddLinkButtonPressed({ required ValueNotifier<List<WhisperLink>> whisperLinksNotifier }) async {
  final WhisperLink whisperLink = WhisperLink(description: '',imageURL: '',label: '',link: '');
  List<WhisperLink> x = whisperLinksNotifier.value;
  x.add(whisperLink);
  whisperLinksNotifier.value = x.map((e) => e).toList();
}

void onDeleteLinkButtonPressed({ required ValueNotifier<List<WhisperLink>> whisperLinksNotifier,required int i }) {
  List<WhisperLink> x = whisperLinksNotifier.value;
  x.removeAt(i);
  whisperLinksNotifier.value = x.map((e) => e).toList();
}

void maxSearchLengthAlert ({ required BuildContext context,required bool isUserName }) {
  if (isUserName == true) {
    showSnackBar(context: context, text: 'ユーザー名は' + maxSearchLength.toString() + '文字以内にしてください' );
  } else {
    showSnackBar(context: context, text: maxSearchLength.toString() + '文字以内にしてください' );
  }
} 
void showSnackBar({ required BuildContext context,required String text}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

void alertMaxLinksLength({ required BuildContext context, }) {
  showSnackBar(context: context, text: 'リンクは' + maxLinksLength.toString() + '個以内にしてください' );
}
void alertMaxBioLength({ required BuildContext context, }) {
  showSnackBar(context: context, text: '自己紹介は' + maxBioOrDescriptionLength.toString() + '文字以内にしてください' );
}

Future<void> defaultLaungh({ required BuildContext context,required String url }) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    showSnackBar(context: context, text: '無効なURLです' );
  }
}