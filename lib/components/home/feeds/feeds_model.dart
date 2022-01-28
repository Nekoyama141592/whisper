// dart
import 'dart:async';
// material
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
// constants
import 'package:whisper/constants/enums.dart';
import 'package:whisper/constants/ints.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/voids.dart' as voids;
// domain
import 'package:whisper/domain/following/following.dart';
import 'package:whisper/domain/mute_post/mute_post.dart';
import 'package:whisper/domain/mute_user/mute_user.dart';
import 'package:whisper/domain/block_user/block_user.dart';
// notifiers
import 'package:whisper/posts/notifiers/play_button_notifier.dart';
import 'package:whisper/posts/notifiers/progress_notifier.dart';
import 'package:whisper/posts/notifiers/repeat_button_notifier.dart';

final feedsProvider = ChangeNotifierProvider(
  (ref) => FeedsModel()
);
class FeedsModel extends ChangeNotifier {

  bool isLoading = false;
  User? currentUser;
  Query<Map<String,dynamic>> getQuery({ required List<String> followingUids }) {
    final x = postColRef.where(uidFieldKey,whereIn: followingUids).orderBy(createdAtFieldKey,descending: true).limit(oneTimeReadCount);
    return x;
  }
  // notifiers
  final currentSongMapNotifier = ValueNotifier<Map<String,dynamic>>({});
  final progressNotifier = ProgressNotifier();
  final repeatButtonNotifier = RepeatButtonNotifier();
  final isFirstSongNotifier = ValueNotifier<bool>(true);
  final playButtonNotifier = PlayButtonNotifier();
  final isLastSongNotifier = ValueNotifier<bool>(true);
  final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);
  // just_audio
  late AudioPlayer audioPlayer;
  List<AudioSource> afterUris = [];
  // cloudFirestore
  List<String> followingUids = [];
  List<DocumentSnapshot<Map<String,dynamic>>> posts = [];
  // block and mutes
  late SharedPreferences prefs;
  // mute
  List<MuteUser> muteUsers = [];
  List<String> muteUids = [];
  List<String> muteIpv6s = [];
  List<String> mutePostIds = [];
  // block
  List<BlockUser> blockUsers = [];
  List<String> blockUids = [];
  List<String> blockIpv6s = [];
  // refresh
  RefreshController refreshController = RefreshController(initialRefresh: false);
  // speed
  final speedNotifier = ValueNotifier<double>(1.0);
  // enum
  final PostType postType = PostType.feeds;

  FeedsModel() {
    init();
  }

  Future<void> init() async {
    startLoading();
    audioPlayer = AudioPlayer();
    // await
    prefs = await SharedPreferences.getInstance();
    await distributeTokens();
    await getFeeds(followingUids: followingUids);
    await voids.setSpeed(audioPlayer: audioPlayer,prefs: prefs,speedNotifier: speedNotifier);
    voids.listenForStates(audioPlayer: audioPlayer, playButtonNotifier: playButtonNotifier, progressNotifier: progressNotifier, currentSongMapNotifier: currentSongMapNotifier, isShuffleModeEnabledNotifier: isShuffleModeEnabledNotifier, isFirstSongNotifier: isFirstSongNotifier, isLastSongNotifier: isLastSongNotifier);
    endLoading();
  }

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void seek(Duration position) {
    audioPlayer.seek(position);
  }

  
  Future<void> onRefresh({ required List<String> followingUids }) async {
    await getNewFeeds(followingUids: followingUids);
    refreshController.refreshCompleted();
    notifyListeners();
  }

  Future<void> onReload({ required List<String> followingUids }) async {
    startLoading();
    await getFeeds(followingUids: followingUids);
    endLoading();
  }

  Future<void> onLoading({ required List<String> followingUids }) async {
    await getOldFeeds(followingUids: followingUids);
    refreshController.loadComplete();
    notifyListeners();
  }

  Future<void> distributeTokens() async {
    final List<TokenType> userTokenTypes = [TokenType.following,TokenType.blockUser,TokenType.muteUser,TokenType.mutePost];
    final List<String> tokenTypeStrings = userTokenTypes.map((e) => returnTokenTypeString(tokenType: e) ).toList();
    final qshot = await tokensParentRef(uid: firebaseAuthCurrentUser!.uid).where(tokenTypeFieldKey,whereIn: tokenTypeStrings).get();
    qshot.docs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) {
      final Map<String,dynamic> tokenMap = doc.data()!;
      final TokenType tokenType = jsonToTokenType(tokenMap: tokenMap );
      if (tokenType == TokenType.following) {
        final Following following = Following.fromJson(tokenMap);
        followingUids.add(following.passiveUid);
      } else if (tokenType == TokenType.blockUser) {
        final BlockUser blockUser = BlockUser.fromJson(tokenMap);
        blockUsers.add(blockUser);
        blockUids.add(blockUser.uid);
        blockIpv6s.add(blockUser.ipv6);
      } else if (tokenType == TokenType.muteUser) {
        final MuteUser muteUser = MuteUser.fromJson(tokenMap);
        muteUsers.add(muteUser);
        muteUids.add(muteUser.uid);
        muteIpv6s.add(muteUser.uid);
      } else if (tokenType == TokenType.mutePost) {
        final MutePost mutePost = MutePost.fromJson(tokenMap);
        mutePostIds.add(mutePost.postId);
      }
    });
  }

  Future<void> getNewFeeds({ required List<String> followingUids }) async {
    if (followingUids.isNotEmpty) {
      await voids.processNewPosts(query: getQuery(followingUids: followingUids), posts: posts, afterUris: afterUris, audioPlayer: audioPlayer, postType: postType, mutesUids: muteUids, blocksUids: blockUids, mutesIpv6s: muteIpv6s, blocksIpv6s: blockIpv6s, mutesPostIds: mutePostIds);
    }
  }

  // getFeeds
  Future<void> getFeeds({ required List<String> followingUids }) async {
    try{
      if (followingUids.isNotEmpty) {
        await voids.processBasicPosts(query: getQuery(followingUids: followingUids), posts: posts, afterUris: afterUris, audioPlayer: audioPlayer, postType: postType, mutesUids: muteUids, blocksUids: blockUids, mutesIpv6s: muteIpv6s, blocksIpv6s: blockIpv6s, mutesPostIds: mutePostIds);
      }
    } catch(e) { print(e.toString()); }
  }

  Future<void> getOldFeeds({ required List<String> followingUids }) async {
    try {
      if (followingUids.isNotEmpty) {
        voids.processOldPosts(query: getQuery(followingUids: followingUids), posts: posts, afterUris: afterUris, audioPlayer: audioPlayer, postType: postType, mutesUids: muteUids, blocksUids: blockUids, mutesIpv6s: muteIpv6s, blocksIpv6s: blockIpv6s, mutesPostIds: mutePostIds);
      }
    } catch(e) { print(e.toString()); }
  }

}