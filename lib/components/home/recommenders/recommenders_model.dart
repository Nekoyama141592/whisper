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
import 'package:whisper/domain/post/post.dart';
// domain
import 'package:whisper/domain/read_post/read_post.dart';
import 'package:whisper/domain/mute_post/mute_post.dart';
import 'package:whisper/domain/mute_user/mute_user.dart';
import 'package:whisper/domain/block_user/block_user.dart';
// notifiers
import 'package:whisper/posts/notifiers/play_button_notifier.dart';
import 'package:whisper/posts/notifiers/progress_notifier.dart';
import 'package:whisper/posts/notifiers/repeat_button_notifier.dart';

final recommendersProvider = ChangeNotifierProvider(
  (ref) => RecommendersModel()
);
class RecommendersModel extends ChangeNotifier {

  // basic
  bool isLoading = false;
  // user
  User? currentUser;
  Query<Map<String, dynamic>> getQuery() {
    final x = returnPostsColGroupQuery.orderBy(scoreFieldKey, descending: true).limit(oneTimeReadCount);
    return x;
  }
  // notifiers
  final currentWhisperPostNotifier = ValueNotifier<Post?>(null);
  final progressNotifier = ProgressNotifier();
  final repeatButtonNotifier = RepeatButtonNotifier();
  final isFirstSongNotifier = ValueNotifier<bool>(true);
  final playButtonNotifier = PlayButtonNotifier();
  final isLastSongNotifier = ValueNotifier<bool>(true);
  final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);
  
  late AudioPlayer audioPlayer;
  List<AudioSource> afterUris = [];
  // cloudFirestore
  List<DocumentSnapshot<Map<String,dynamic>>> posts = [];
  // block and mutes
  late SharedPreferences prefs;
  // mute
  List<MuteUser> muteUsers = [];
  List<String> muteUids = [];
  List<String> muteIpv6s = [];
  List<String> mutePostIds = [];
  List<BlockUser> blockUsers = [];
  List<String> blockUids = [];
  List<String> blockIpv6s = [];
  List<String> readPostIds = [];
  // refresh
  RefreshController refreshController = RefreshController(initialRefresh: false);
  // speed
  final speedNotifier = ValueNotifier<double>(1.0);
  // enum
  final PostType postType = PostType.recommenders;
  
  RecommendersModel() {
    init();
  }

  void init() async {
    startLoading();
    audioPlayer = AudioPlayer();
    setCurrentUser();
    prefs = await SharedPreferences.getInstance();
    await getRecommenders();
    await voids.setSpeed(audioPlayer: audioPlayer,prefs: prefs,speedNotifier: speedNotifier);
    voids.listenForStates(audioPlayer: audioPlayer, playButtonNotifier: playButtonNotifier, progressNotifier: progressNotifier, currentWhisperPostNotifier: currentWhisperPostNotifier, isShuffleModeEnabledNotifier: isShuffleModeEnabledNotifier, isFirstSongNotifier: isFirstSongNotifier, isLastSongNotifier: isLastSongNotifier);
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

  void setCurrentUser() {
    currentUser = FirebaseAuth.instance.currentUser;
  }

  void seek(Duration position) {
    audioPlayer.seek(position);
  }

  Future<void> distributeTokens() async {
    final List<TokenType> userTokenTypes = [TokenType.readPost,TokenType.blockUser,TokenType.muteUser,TokenType.mutePost];
    final List<String> tokenTypeStrings = userTokenTypes.map((e) => returnTokenTypeString(tokenType: e) ).toList();
    final qshot = await returnTokensColRef(uid: firebaseAuthCurrentUser!.uid).where(tokenTypeFieldKey,whereIn: tokenTypeStrings).get();
    qshot.docs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) {
      final Map<String,dynamic> tokenMap = doc.data()!;
      final TokenType tokenType = jsonToTokenType(tokenMap: tokenMap );
      if (tokenType == TokenType.readPost) {
        final ReadPost readPost = ReadPost.fromJson(tokenMap);
        readPostIds.add(readPost.postId);
      } else if (tokenType == TokenType.blockUser) {
        final BlockUser blockUser = BlockUser.fromJson(tokenMap);
        blockUsers.add(blockUser);
        blockUids.add(blockUser.activeUid);
        blockIpv6s.add(blockUser.ipv6);
      } else if (tokenType == TokenType.muteUser) {
        final MuteUser muteUser = MuteUser.fromJson(tokenMap);
        muteUsers.add(muteUser);
        muteUids.add(muteUser.passiveUid);
        muteIpv6s.add(muteUser.passiveUid);
      } else if (tokenType == TokenType.mutePost) {
        final MutePost mutePost = MutePost.fromJson(tokenMap);
        mutePostIds.add(mutePost.postId);
      }
    });
  }
  
  Future<void> onRefresh() async {
    await getNewRecommenders();
    refreshController.refreshCompleted();
    notifyListeners();
  }

  Future<void> onReload() async {
    startLoading();
    await getRecommenders();
    endLoading();
  }

  Future<void> onLoading() async {
    await getOldRecommenders();
    refreshController.loadComplete();
    notifyListeners();
  }

  Future<void> getNewRecommenders() async {
    await voids.processNewPosts(query: getQuery(), posts: posts, afterUris: afterUris, audioPlayer: audioPlayer, postType: postType, mutesUids: muteUids, blocksUids: blockUids, mutesIpv6s: muteIpv6s, blocksIpv6s: blockIpv6s, mutesPostIds: mutePostIds);
  }

  Future<void> getRecommenders() async {
    try {
      await voids.processBasicPosts(query: getQuery(), posts: posts, afterUris: afterUris, audioPlayer: audioPlayer, postType: postType, muteUids: muteUids, blockUids: blockUids, muteIpv6s: muteIpv6s, blockIpv6s: blockIpv6s, mutePostIds: mutePostIds);
    } catch(e) { print(e.toString() ); }
  }

  Future<void> getOldRecommenders() async {
    try {
      await voids.processOldPosts(query: getQuery(), posts: posts, afterUris: afterUris, audioPlayer: audioPlayer, postType: postType, mutesUids: muteUids, blocksUids: blockUids, mutesIpv6s: muteIpv6s, blocksIpv6s: blockIpv6s, mutesPostIds: mutePostIds);
    } catch(e) { print(e.toString()); }
  }

}