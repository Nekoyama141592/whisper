// material
import 'package:flutter/material.dart';
// packages
import 'package:just_audio/just_audio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whisper/abstract_models/posts_model.dart';
// constants
import 'package:whisper/constants/enums.dart';
import 'package:whisper/constants/ints.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/others.dart';
// domain
import 'package:whisper/domain/bookmark_post/bookmark_post.dart';
import 'package:whisper/domain/following/following.dart';
import 'package:whisper/domain/likeComment/like_comment.dart';
import 'package:whisper/domain/likeReply/like_reply.dart';
import 'package:whisper/domain/like_post/like_post.dart';
import 'package:whisper/domain/mute_comment/mute_comment.dart';
import 'package:whisper/domain/mute_post/mute_post.dart';
import 'package:whisper/domain/mute_reply/mute_reply.dart';
import 'package:whisper/domain/read_post/read_post.dart';
import 'package:whisper/domain/search_history/search_history.dart';
import 'package:whisper/domain/user_meta/user_meta.dart';
import 'package:whisper/domain/mute_user/mute_user.dart';
import 'package:whisper/domain/block_user/block_user.dart';
import 'package:whisper/domain/watchlist/watchlist.dart';
import 'package:whisper/domain/whisper_user/whisper_user.dart';
import 'package:whisper/domain/bookmark_post_category/bookmark_post_category.dart';
import 'package:whisper/domain/timeline/timeline.dart';

final mainProvider = ChangeNotifierProvider(
  (ref) => MainModel()
);

class MainModel extends PostsModel {
  // user
  User? currentUser;
  late DocumentSnapshot<Map<String,dynamic>> currentUserDoc;
  late UserMeta userMeta;
  late WhisperUser currentWhisperUser;
  // tokens
  List<LikePost> likePosts = [];
  List<String> likePostIds = [];
  List<String> bookmarksPostIds = [];
  List<String> followingUids = [];
  List<LikeComment> likePostComments = [];
  List<String> likePostCommentIds = [];
  List<LikeReply> likePostCommentReplies = [];
  List<String> likePostCommentReplyIds = [];
  // bookmark
  List<BookmarkPost> bookmarkPosts = [];
  List<BookmarkPostCategory> bookmarkPostCategories = [];
  List<ReadPost> readPosts = [];
  List<String> readPostIds = [];
  // mutes 
  List<MuteUser> muteUsers = [];
  List<String> muteUids = [];
  List<MuteReply> mutePostCommentReplys = [];
  List<String> mutePostCommentReplyIds = [];
  List<MuteComment> mutePostComments = [];
  List<String> mutePostCommentIds = [];
  List<MutePost> mutePosts = [];
  List<String> mutePostIds = [];
  // block(使用されていない)
  List<BlockUser> blockUsers = [];
  List<String> blockUids = [];
  // searchHistory
  List<SearchHistory> searchHistory = [];
  // watchlist 
  List<Watchlist> watchlists = [];
  // following
  List<Following> following = [];
  // distributeTokenに関与しない
  List<MuteUser> newMuteUserTokens = [];
  // bookmarkLabel
  final bookmarkPostCategoryTokenIdNotifier = ValueNotifier<String>('');
  // feeds
  bool isFeedLoading = false;
  Query<Map<String,dynamic>> getQuery({ required QuerySnapshot<Map<String,dynamic>> timelinesQshot })  {
    final List<String> max10TimelinePostIds = timelinesQshot.docs.map((e) => Timeline.fromJson(e.data()).postId ).toList();
    if (max10TimelinePostIds.isEmpty) {
      max10TimelinePostIds.add('');
    }
    return returnPostsColGroupQuery().where(postIdFieldKey,whereIn: max10TimelinePostIds).limit(tenCount);
  }
  List<DocumentSnapshot<Map<String,dynamic>>> timelineDocs = [];

  MainModel() : super(postType: PostType.feeds){
    init();
  }
  
  Future<void> init() async {
    startLoading();
    prefs = await SharedPreferences.getInstance();
    await setCurrentUser();
    audioPlayer = AudioPlayer();
    followingUids.add(userMeta.uid);
    await distributeTokens();
    await getFeeds();
    await super.setSpeed();
    super.listenForStates();
    endLoading();
  }

  Future<void> setCurrentUser() async {
    currentUser = FirebaseAuth.instance.currentUser;
    currentUserDoc = await FirebaseFirestore.instance.collection(usersFieldKey).doc(currentUser!.uid).get();
    currentWhisperUser = WhisperUser.fromJson(currentUserDoc.data()!);
    final userMetaDoc = await FirebaseFirestore.instance.collection(userMetaFieldKey).doc(currentUser!.uid).get();
    userMeta = UserMeta.fromJson(userMetaDoc.data()!);
  }

  Future<void> distributeTokens() async {
    final tokensQshot = await returnTokensColRef(uid: userMeta.uid).get();
    final tokenDocs = tokensQshot.docs;
    // 新しい順に並び替えている
    // 古い順に並び替えたければ、aとbを逆にする
    tokenDocs.sort((a,b) => (b[createdAtFieldKey] as Timestamp).compareTo(a[createdAtFieldKey]));
    for (final tokenDoc in tokenDocs) {
      final Map<String,dynamic> tokenMap = tokenDoc.data();
      final TokenType tokenType = jsonToTokenType(tokenMap: tokenMap);
      switch(tokenType) {
        case TokenType.blockUser:
          final BlockUser blockUser = BlockUser.fromJson(tokenMap);
          blockUsers.add(blockUser);
          blockUids.add(blockUser.passiveUid);
        break;
        case TokenType.bookmarkPostCategory:
          final BookmarkPostCategory bookmarkLabel = BookmarkPostCategory.fromJson(tokenMap);
          bookmarkPostCategories.add(bookmarkLabel);
        break;
        case TokenType.bookmarkPost:
          final BookmarkPost bookmarkPost = BookmarkPost.fromJson(tokenMap);
          bookmarkPosts.add(bookmarkPost);
          bookmarksPostIds.add(bookmarkPost.postId);
        break;
        case TokenType.following:
          final Following followingInstantce = Following.fromJson(tokenMap);
          following.add(followingInstantce);
          followingUids.add(followingInstantce.passiveUid);
        break;
        case TokenType.likePostComment:
          final LikeComment likeComment = LikeComment.fromJson(tokenMap);
          likePostComments.add(likeComment);
          likePostCommentIds.add(likeComment.postCommentId);
        break;
        case TokenType.likePost:
          final LikePost likePost = LikePost.fromJson(tokenMap);
          likePosts.add(likePost);
          likePostIds.add(likePost.postId);
        break;
        case TokenType.likePostCommentReply:
          final LikeReply likeReply = LikeReply.fromJson(tokenMap);
          likePostCommentReplies.add(likeReply);
          likePostCommentReplyIds.add(likeReply.postCommentReplyId);
        break;
        case TokenType.mutePostComment:
          final MuteComment muteComment = MuteComment.fromJson(tokenMap);
          mutePostComments.add(muteComment);
          mutePostCommentIds.add(muteComment.postCommentId);
        break;
        case TokenType.mutePost:
          final MutePost mutePost = MutePost.fromJson(tokenMap);
          mutePosts.add(mutePost);
          mutePostIds.add(mutePost.postId);
        break;
        case TokenType.mutePostCommentReply:
          final MuteReply muteReply = MuteReply.fromJson(tokenMap);
          mutePostCommentReplys.add(muteReply);
          mutePostCommentReplyIds.add(muteReply.postCommentReplyId);
        break;
        case TokenType.muteUser:
          final MuteUser muteUser = MuteUser.fromJson(tokenMap);
          muteUsers.add(muteUser);
          muteUids.add(muteUser.passiveUid);
        break;
        case TokenType.readPost:
          final ReadPost readPost = ReadPost.fromJson(tokenMap);
          readPosts.add(readPost);
          readPostIds.add(readPost.postId);
        break;
        case TokenType.searchHistory:
          final SearchHistory searchHistoryInstance = SearchHistory.fromJson(tokenMap);
          searchHistory.add(searchHistoryInstance);
        break;
        case TokenType.watchlist:
          final Watchlist watchlist = Watchlist.fromJson(tokenMap);
          watchlists.add(watchlist);
        break;
      }
    }
  }
  // feeds

  void startFeedLoading() {
    isFeedLoading = true;
    notifyListeners();
  }

  void endFeedLoading() {
    isFeedLoading = false;
    notifyListeners();
  }

  Future<void> onRefresh() async {
    await getNewFeeds();
    refreshController.refreshCompleted();
    notifyListeners();
  }

  Future<void> onReload() async {
    startFeedLoading();
    await getFeeds();
    endFeedLoading();
  }

  Future<void> onLoading() async {
    await getOldFeeds();
    refreshController.loadComplete();
    notifyListeners();
  }

  Future<void> getNewFeeds() async {
    final timelinesQshot = await returnTimelinesColRef(uid: userMeta.uid).orderBy(createdAtFieldKey,descending: true).endBeforeDocument(timelineDocs.first).limit(tenCount).get();
    for (final doc in timelinesQshot.docs) timelineDocs.insert(0, doc);
    if (followingUids.isNotEmpty && timelineDocs.isNotEmpty) {
      await processNewPosts(query: getQuery(timelinesQshot: timelinesQshot), muteUids: muteUids, blockUids: blockUids,mutesPostIds: mutePostIds);
    }
  }

  // getFeeds
  Future<void> getFeeds() async {
    final timelinesQshot = await returnTimelinesColRef(uid: userMeta.uid).orderBy(createdAtFieldKey,descending: true).limit(tenCount).get();
    timelineDocs = timelinesQshot.docs;
    if (followingUids.isNotEmpty && timelineDocs.isNotEmpty) {
      await processBasicPosts(query: getQuery(timelinesQshot: timelinesQshot), muteUids: muteUids, blockUids: blockUids, mutePostIds: mutePostIds);
    }
  }

  Future<void> getOldFeeds() async {
    final timelinesQshot = await returnTimelinesColRef(uid: userMeta.uid).orderBy(createdAtFieldKey,descending: true).startAfterDocument(timelineDocs.last).limit(tenCount).get();
    for (final doc in timelinesQshot.docs) timelineDocs.add(doc);
    if (followingUids.isNotEmpty && timelineDocs.isNotEmpty) {
      await processOldPosts(query: getQuery(timelinesQshot: timelinesQshot), muteUids: muteUids, blockUids: blockUids,mutePostIds: mutePostIds);
    }
  }

}