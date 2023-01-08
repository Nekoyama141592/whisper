// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whisper/abstract_models/posts_model.dart';
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
class RecommendersModel extends PostsModel {
  // user
  User? currentUser;
  Query<Map<String, dynamic>> getQuery() {
    // five days ago
    final range = DateTime.now().subtract(Duration(days: 5));
    final x = returnPostsColGroupQuery()
    .where(createdAtFieldKey,isGreaterThanOrEqualTo: range)
    .orderBy(createdAtFieldKey,descending: true)
    .orderBy(scoreFieldKey, descending: true)
    .limit(oneTimeReadCount);
    return x;
  }  
  // mute
  List<MuteUser> muteUsers = [];
  List<String> muteUids = [];
  List<String> mutePostIds = [];
  List<BlockUser> blockUsers = [];
  List<String> blockUids = [];
  List<String> readPostIds = [];
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
    await super.setSpeed();
    super.listenForStates();
    endLoading();
  }

  void setCurrentUser() {
    currentUser = FirebaseAuth.instance.currentUser;
  }

  Future<void> distributeTokens() async {
    final List<TokenType> userTokenTypes = [TokenType.readPost,TokenType.blockUser,TokenType.muteUser,TokenType.mutePost];
    final List<String> tokenTypeStrings = userTokenTypes.map((e) => returnTokenTypeString(tokenType: e) ).toList();
    final qshot = await returnTokensColRef(uid: firebaseAuthCurrentUser()!.uid).where(tokenTypeFieldKey,whereIn: tokenTypeStrings).get();
    for (final doc in qshot.docs) {
      final Map<String,dynamic> tokenMap = doc.data();
      final TokenType tokenType = jsonToTokenType(tokenMap: tokenMap );
      if (tokenType == TokenType.readPost) {
        final ReadPost readPost = ReadPost.fromJson(tokenMap);
        readPostIds.add(readPost.postId);
      } else if (tokenType == TokenType.blockUser) {
        final BlockUser blockUser = BlockUser.fromJson(tokenMap);
        blockUsers.add(blockUser);
        blockUids.add(blockUser.activeUid);
      } else if (tokenType == TokenType.muteUser) {
        final MuteUser muteUser = MuteUser.fromJson(tokenMap);
        muteUsers.add(muteUser);
        muteUids.add(muteUser.passiveUid);
      } else if (tokenType == TokenType.mutePost) {
        final MutePost mutePost = MutePost.fromJson(tokenMap);
        mutePostIds.add(mutePost.postId);
      }
    }
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
    await voids.processNewPosts(query: getQuery(), posts: posts, afterUris: afterUris, audioPlayer: audioPlayer, postType: postType, muteUids: muteUids, blockUids: blockUids, mutesPostIds: mutePostIds);
    postDocDescending();
  }

  Future<void> getRecommenders() async {
    await voids.processBasicPosts(query: getQuery(), posts: posts, afterUris: afterUris, audioPlayer: audioPlayer, postType: postType, muteUids: muteUids, blockUids: blockUids, mutePostIds: mutePostIds);
    postDocDescending();
  }

  Future<void> getOldRecommenders() async {
    await voids.processOldPosts(query: getQuery(), posts: posts, afterUris: afterUris, audioPlayer: audioPlayer, postType: postType, muteUids: muteUids, blockUids: blockUids, mutePostIds: mutePostIds);
    postDocDescending();
  }

  void postDocDescending() {
    posts.sort((a,b) {
      final Timestamp aCreatedAt = Post.fromJson(a.data()!).createdAt as Timestamp;
      final Timestamp bCreatedAt = Post.fromJson(b.data()!).createdAt as Timestamp;
      return bCreatedAt.compareTo(aCreatedAt);
    });
  }

}