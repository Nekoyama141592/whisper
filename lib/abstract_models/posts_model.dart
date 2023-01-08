// material
import 'package:flutter/cupertino.dart';
// packages
import 'package:just_audio/just_audio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whisper/constants/bools.dart';
// constants
import 'package:whisper/constants/enums.dart';
import 'package:whisper/constants/ints.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/domain/post/post.dart';
// domain
import 'package:whisper/l10n/l10n.dart';
import 'package:whisper/models/edit_post_info/edit_post_info_model.dart';
// notifiers
import 'package:whisper/posts/notifiers/play_button_notifier.dart';
import 'package:whisper/posts/notifiers/progress_notifier.dart';
import 'package:whisper/posts/notifiers/repeat_button_notifier.dart';
// components
import 'package:whisper/details/positive_text.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:flutter/material.dart';
// packages
import 'package:flash/flash.dart';
import 'package:whisper/constants/doubles.dart';
// domain
import 'package:whisper/domain/like_post/like_post.dart';
import 'package:whisper/domain/post_like/post_like.dart';
import 'package:whisper/domain/mute_user/mute_user.dart';
import 'package:whisper/domain/mute_post/mute_post.dart';
import 'package:whisper/domain/post_mute/post_mute.dart';
import 'package:whisper/domain/post_report/post_report.dart';
import 'package:whisper/domain/bookmark_post/bookmark_post.dart';
import 'package:whisper/domain/post_bookmark/post_bookmark.dart';
import 'package:whisper/domain/bookmark_post_category/bookmark_post_category.dart';
// components
import 'package:whisper/details/report_contents_list_view.dart';
import 'package:whisper/domain/user_meta/user_meta.dart';
import 'package:whisper/domain/user_mute/user_mute.dart';

abstract class PostsModel extends ChangeNotifier {
  PostsModel({
    required this.postType
  });
  final PostType postType;

  bool isLoading = false;
  // notifiers
  final currentWhisperPostNotifier = ValueNotifier<Post?>(null);
  final progressNotifier = ProgressNotifier();
  final repeatButtonNotifier = RepeatButtonNotifier();
  final isFirstSongNotifier = ValueNotifier<bool>(true);
  final playButtonNotifier = PlayButtonNotifier();
  final isLastSongNotifier = ValueNotifier<bool>(true);
  final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);
  AudioPlayer audioPlayer = AudioPlayer();
  List<AudioSource> afterUris = [];
  // cloudFirestore
  List<DocumentSnapshot<Map<String,dynamic>>> posts = [];
  // refresh
  RefreshController refreshController = RefreshController(initialRefresh: false);
  // speed
  late SharedPreferences prefs;
  final speedNotifier = ValueNotifier<double>(1.0);

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }
  Future<void> processNewPosts({required Query<Map<String, dynamic>> query,required List<String> muteUids, required  List<String> blockUids , required List<String> mutesPostIds }) async {
  final qshot = await query.endBeforeDocument(posts.first).get();
  List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = qshot.docs;
  if (postType == PostType.bookmarks || postType == PostType.feeds || postType == PostType.postSearch) {
    docs.sort((a,b) => (Post.fromJson(b.data()).createdAt as Timestamp).compareTo( Post.fromJson(a.data()).createdAt as Timestamp ));
  }
  if (docs.isNotEmpty) {
    // because of insert
    docs.reversed;
    // Insert at the top
    for (final doc in docs) {
      final whisperPost = fromMapToPost(postMap: doc.data());
      final String uid = whisperPost.uid;
      bool x = isValidReadPost(whisperPost: whisperPost ,postType: postType, muteUids: muteUids, blockUids: blockUids, uid: uid, mutePostIds: mutesPostIds, doc: doc) && isNotNegativePost(whisperPost: whisperPost);
      if (x) {
        posts.insert(0, doc);
        Uri song = Uri.parse(whisperPost.audioURL);
        UriAudioSource source = AudioSource.uri(song, tag: whisperPost );
        afterUris.insert(0, source);
      }
    }
    if (afterUris.isNotEmpty) {
      ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: afterUris);
      await audioPlayer.setAudioSource(playlist);
    }
  }
}

Future<void> processBasicPosts({ required Query<Map<String, dynamic>> query,required List<String> muteUids, required List<String> blockUids, required List<String> mutePostIds }) async {
  final qshot = await query.get();
  final docs = qshot.docs;
  if (postType == PostType.bookmarks || postType == PostType.feeds || postType == PostType.postSearch) {
    docs.sort((a,b) => (Post.fromJson(b.data()).createdAt as Timestamp).compareTo( Post.fromJson(a.data()).createdAt as Timestamp ));
  }
  if (docs.isNotEmpty) {
    for (final doc in docs) {
      final whisperPost = fromMapToPost(postMap: doc.data() );
      final String uid = whisperPost.uid;
      bool x = isValidReadPost(whisperPost: whisperPost,postType: postType, muteUids: muteUids, blockUids: blockUids, uid: uid, mutePostIds: mutePostIds, doc: doc) && isNotNegativePost(whisperPost: whisperPost);
      if (x) {
        posts.add(doc);
        Uri song = Uri.parse(whisperPost.audioURL);
        UriAudioSource source = AudioSource.uri(song, tag: whisperPost );
        afterUris.add(source);
      }
    }
    if (afterUris.isNotEmpty) {
      ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: afterUris);
      await audioPlayer.setAudioSource(playlist);
    }
  }
}

Future<void> processOldPosts({ required Query<Map<String, dynamic>> query,required List<String> muteUids, required  List<String> blockUids , required List<String> mutePostIds }) async {
  final bool useWhereIn = (postType == PostType.feeds || postType == PostType.bookmarks);
  final qshot = useWhereIn ? await query.get() : await query.startAfterDocument(posts.last).get();
  final int lastIndex = posts.lastIndexOf(posts.last);
  List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = qshot.docs;
  if (postType == PostType.bookmarks || postType == PostType.feeds || postType == PostType.postSearch) {
    docs.sort((a,b) => (Post.fromJson(b.data()).createdAt as Timestamp).compareTo( Post.fromJson(a.data()).createdAt as Timestamp ));
  }
  if (docs.isNotEmpty) {
    for (final doc in docs) {
      final whisperPost = fromMapToPost(postMap: doc.data() );
      final String uid = whisperPost.uid;
      bool x = isValidReadPost(whisperPost: whisperPost,postType: postType, muteUids: muteUids, blockUids: blockUids, uid: uid, mutePostIds: mutePostIds, doc: doc) && isNotNegativePost(whisperPost: whisperPost);
      if (x) {
        posts.add(doc);
        Uri song = Uri.parse(whisperPost.audioURL);
        UriAudioSource source = AudioSource.uri(song, tag: whisperPost );
        afterUris.add(source);
      }
    }
    if (afterUris.isNotEmpty) {
      ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: afterUris);
      await audioPlayer.setAudioSource(playlist,initialIndex: lastIndex);
    }
  }
}


  Future<void> setSpeed() async {
    speedNotifier.value = prefs.getDouble(speedPrefsKey) ?? 1.0;
    await audioPlayer.setSpeed(speedNotifier.value);
  }

  Future<void> speedControll() async {
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
  Future<void> resetAudioPlayer({ required int i }) async {
    // Abstractions in post_futures.dart cause Range errors.
    AudioSource source = afterUris[i];
    afterUris.remove(source);
    if (afterUris.isNotEmpty) {
      ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: afterUris);
      await audioPlayer.setAudioSource(playlist,initialIndex: i == 0 ? i :  i - 1);
    } 
  }
  void onRepeatButtonPressed() {
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
  void toEditPostInfoMode({required EditPostInfoModel editPostInfoModel}) {
    audioPlayer.pause();
    editPostInfoModel.isEditing = true;
    editPostInfoModel.reload();
  }

  void onPreviousSongButtonPressed() => audioPlayer.seekToPrevious();

  void onNextSongButtonPressed() => audioPlayer.seekToNext();

  void play() => audioPlayer.play();

  void pause() => audioPlayer.pause();

  void seek(Duration position) => audioPlayer.seek(position);

  void listenForStates() {
    listenForChangesInPlayerState();
    listenForChangesInPlayerPosition();
    listenForChangesInBufferedPosition();
    listenForChangesInTotalDuration();
    listenForChangesInSequenceState();
  }
  void listenForStatesForAddPostModel() {
    listenForChangesInPlayerState();
    listenForChangesInPlayerPosition();
    listenForChangesInBufferedPosition();
    listenForChangesInTotalDuration(); 
  }

  void listenForChangesInPlayerState() {
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


  void listenForChangesInPlayerPosition() {
    audioPlayer.positionStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });
  }

  void listenForChangesInBufferedPosition() {
    audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });
  }

  void listenForChangesInTotalDuration() {
    audioPlayer.durationStream.listen((totalDuration) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );
    });
  }

  void listenForChangesInSequenceState() {
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

    Future<void> mutePost({ required BuildContext context ,required MainModel mainModel, required int i, required DocumentSnapshot<Map<String,dynamic>> postDoc, required List<AudioSource> afterUris, required AudioPlayer audioPlayer , required List<DocumentSnapshot<Map<String,dynamic>>> results}) async {
    // process set
    final Post whisperPost = fromMapToPost(postMap: postDoc.data()!);
    final String postId = whisperPost.postId;
    final Timestamp now = Timestamp.now();
    final String tokenId = returnTokenId(userMeta: mainModel.userMeta, tokenType: TokenType.mutePost );
    final MutePost mutePost = MutePost(activeUid: mainModel.userMeta.uid, createdAt: now, postId: postId,tokenId: tokenId,passiveUid: whisperPost.uid,tokenType: mutePostTokenType );
    // process UI
    mainModel.mutePostIds.add(postId);
    mainModel.mutePosts.add(mutePost);
    results.removeWhere((result) => fromMapToPost(postMap: result.data()!).postId == whisperPost.postId );
    await resetAudioPlayer(i: i);
    notifyListeners();
    await voids.showBasicFlutterToast(context: context,msg: mutePostMsg(context: context));
    // process Backend
    await returnTokenDocRef(uid: mainModel.userMeta.uid, tokenId: tokenId).set(mutePost.toJson());
    final PostMute postMute = PostMute(activeUid: mainModel.userMeta.uid, createdAt: now, postCreatorUid: whisperPost.postId, postDocRef: postDoc.reference, postId: postId);
    await returnPostMuteDocRef(postDoc: postDoc, userMeta: mainModel.userMeta).set(postMute.toJson());
  }

  Future<void> muteUser({ required BuildContext context ,required AudioPlayer audioPlayer, required List<AudioSource> afterUris, required List<String> muteUids, required int i, required List<DocumentSnapshot<Map<String,dynamic>>> results,required List<MuteUser> muteUsers, required Post whisperPost, required MainModel mainModel}) async {
    // process set
    final String passiveUid = whisperPost.uid;
    final Timestamp now = Timestamp.now();
    final UserMeta userMeta = mainModel.userMeta;
    final String tokenId = returnTokenId(userMeta: userMeta, tokenType: TokenType.muteUser );
    final MuteUser muteUser = MuteUser(activeUid: firebaseAuthCurrentUser()!.uid,createdAt: now,passiveUid: passiveUid,tokenId: tokenId, tokenType: muteUserTokenType );
    // process Ui
    mainModel.muteUsers.add(muteUser);
    mainModel.muteUids.add(whisperPost.uid);
    await removeTheUsersPost(results: results, passiveUid: passiveUid, afterUris: afterUris, audioPlayer: audioPlayer, i: i);
    notifyListeners();
    await voids.showBasicFlutterToast(context: context,msg: muteUserMsg(context: context));
    // process Backend
    await returnTokenDocRef(uid: mainModel.userMeta.uid, tokenId: tokenId).set(muteUser.toJson());
    final UserMute userMute = UserMute(createdAt: now, muterUid: userMeta.uid, mutedUid: passiveUid );
    await returnUserMuteDocRef(passiveUid: passiveUid, activeUid: mainModel.userMeta.uid ).set(userMute.toJson());
  }

  Future<void> removeTheUsersPost({ required List<DocumentSnapshot<Map<String,dynamic>>> results,required String passiveUid, required List<AudioSource> afterUris, required AudioPlayer audioPlayer,required int i}) async {
    results.removeWhere((result) => fromMapToPost(postMap: result.data()!).uid == passiveUid);
    await resetAudioPlayer(i: i);
  }

  Future<void> deletePost({ required BuildContext innerContext, required AudioPlayer audioPlayer,required Post whisperPost,required List<AudioSource> afterUris, required List<DocumentSnapshot<Map<String,dynamic>>> posts,required MainModel mainModel, required int i}) async {
    Navigator.pop(innerContext);
    final L10n l10n = returnL10n(context: innerContext)!;
    if (mainModel.currentUser!.uid != whisperPost.uid) {
      voids.showBasicFlutterToast(context: innerContext, msg: l10n.noRight);
    } else {
      // process UI
      final x = posts[i];
      posts.remove(x);
      mainModel.currentWhisperUser.postCount += minusOne;
      await resetAudioPlayer(i: i);
      // process backend
      await x.reference.delete();
      await returnRefFromPost(post: whisperPost).delete();
      if (isImageExist(post: whisperPost) == true) {
        await returnPostImagePostRef(mainModel: mainModel, postId: whisperPost.postId).delete();
      }
      notifyListeners();
    }
  }

  void onPostDeleteButtonPressed({ required BuildContext context, required AudioPlayer audioPlayer,required Post whisperPost,required List<AudioSource> afterUris, required List<DocumentSnapshot<Map<String,dynamic>>> posts,required MainModel mainModel, required int i}) {
    final L10n l10n = returnL10n(context: context)!;
    final title = l10n.deletePost;
    final content = l10n.deletePostAlert;
    final builder = (innerContext) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          CupertinoDialogAction(
            child: Text(cancelText(context: context)),
            onPressed: () => Navigator.pop(innerContext),
          ),
          CupertinoDialogAction(
            child: const Text(okText),
            isDestructiveAction: true,
            onPressed: () async => await deletePost(innerContext: innerContext, audioPlayer: audioPlayer, whisperPost: whisperPost, afterUris: afterUris, posts: posts, mainModel: mainModel, i: i)
          ),
        ],
      );
    };
    voids.showCupertinoDialogue(context: context, builder: builder );
  } 
  Future<void> initAudioPlayer({ required AudioPlayer audioPlayer, required List<AudioSource> afterUris ,required int i}) async {
    ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: afterUris);
    await audioPlayer.setAudioSource(playlist,initialIndex: i);
  }

  void reportPost({ required BuildContext context, required MainModel mainModel, required int i, required Post post, required List<AudioSource> afterUris, required AudioPlayer audioPlayer , required List<DocumentSnapshot<Map<String,dynamic>>> results}) {
    final postDoc = results[i];
    final selectedReportContentsNotifier = ValueNotifier<List<String>>([]);
    final String postReportId = generatePostReportId();
    final content = ReportContentsListView(selectedReportContentsNotifier: selectedReportContentsNotifier);
    final positiveActionBuilder = (_, controller, __) {
      return TextButton(
        onPressed: () async {
          final PostReport postReport = PostReport(
            activeUid: mainModel.userMeta.uid,
            createdAt: Timestamp.now(), 
            others: '', 
            postCreatorUid: post.uid,
            passiveUserName: post.userName, 
            postDocRef: postDoc.reference, 
            postId: postDoc.id, 
            postReportId: postReportId,
            postTitle: post.title, 
            postTitleLanguageCode: post.titleLanguageCode,
            postTitleNegativeScore: post.titleNegativeScore, 
            postTitlePositiveScore: post.titlePositiveScore, 
            postTitleSentiment: post.titleSentiment,
            reportContent: returnReportContentString(selectedReportContents: selectedReportContentsNotifier.value),
          );
          await (controller as FlashController).dismiss();
          await voids.showBasicFlutterToast(context: context,msg: reportPostMsg(context: context));
          await mutePost(context: context,mainModel: mainModel, i: i, postDoc: postDoc, afterUris: afterUris, audioPlayer: audioPlayer, results: results);
          await returnPostReportDocRef(postDoc: postDoc,postReportId: postReportId ).set(postReport.toJson());
        }, 
        child: PositiveText(text: sendModalText(context: context))
      );
    };
    voids.showFlashDialogue(context: context, content: content, titleText: reportTitle(context: context), positiveActionBuilder: positiveActionBuilder);
  }
}