// material
import 'package:flutter/material.dart';
// packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
// constants
import 'package:whisper/constants/enums.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/voids.dart' as voids;
// domain
import 'package:whisper/domain/bookmark/bookmark.dart';
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
import 'package:whisper/domain/bookmark_label/bookmark_label.dart';

final mainProvider = ChangeNotifierProvider(
  (ref) => MainModel()
);

class MainModel extends ChangeNotifier {

  // base
  bool isLoading = false;
  // user
  User? currentUser;
  late DocumentSnapshot<Map<String,dynamic>> currentUserDoc;
  late UserMeta userMeta;
  late WhisperUser currentWhisperUser;
  late SharedPreferences prefs;
  // tokens
  List<LikePost> likePosts = [];
  List<String> likePostIds = [];
  List<String> bookmarksPostIds = [];
  List<String> followingUids = [];
  List<LikeComment> likeComments = [];
  List<String> likeCommentIds = [];
  List<LikeReply> likeReplys = [];
  List<String> likeReplyIds = [];
  // bookmark
  List<Bookmark> bookmarks = [];
  List<BookmarkLabel> bookmarkLabels = [];
  List<ReadPost> readPosts = [];
  List<String> readPostIds = [];
  // mutes 
  List<MuteUser> muteUsers = [];
  List<String> muteUids = [];
  List<String> muteIpv6s = [];
  List<MuteReply> muteReplys = [];
  List<String> muteReplyIds = [];
  List<MuteComment> muteComments = [];
  List<String> muteCommentIds = [];
  List<MutePost> mutePosts = [];
  List<String> mutePostIds = [];
  // block
  List<BlockUser> blockUsers = [];
  List<String> blockUids = [];
  List<String> blockIpv6s = [];
  // searchHistory
  List<SearchHistory> searchHistory = [];
  // watchlist 
  List<Watchlist> watchlists = [];
  // bookmarkLabel
  String bookmarkLabelId = '';

  MainModel() {
    init();
  }
  
  void init() async {
    startLoading();
    prefs = await SharedPreferences.getInstance();
    await setCurrentUser();
    final tokensQshot = await tokensParentRef(uid: userMeta.uid).get();
    distributeTokens(tokensQshot: tokensQshot);
    await setBookmarkLabels();
    setList();
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

  Future<void> setCurrentUser() async {
    currentUser = FirebaseAuth.instance.currentUser;
    final currentUserDoc = await FirebaseFirestore.instance.collection(usersKey).doc(currentUser!.uid).get();
    currentWhisperUser = fromMapToWhisperUser(userMap: currentUserDoc.data()!);
    final userMetaDoc = await FirebaseFirestore.instance.collection(userMetaKey).doc(currentUser!.uid).get();
    userMeta = fromMapToUserMeta(userMetaMap: userMetaDoc.data()!);
  }

  Future<void> setBookmarkLabels() async {
    await FirebaseFirestore.instance.collection(userMetaKey).doc(currentUser!.uid).collection(bookmarkLabelsString).get().then((qshot) {
      bookmarkLabels = qshot.docs.map((doc) => fromMapToBookmarkLabel(map: doc.data()) ).toList();
    });
  }

  void distributeTokens({ required QuerySnapshot<Map<String, dynamic>> tokensQshot }) {
    tokensQshot.docs.forEach((DocumentSnapshot<Map<String, dynamic>> tokenDoc) {
      final Map<String,dynamic> tokenMap = tokenDoc.data()!;
      final TokenType tokenType = jsonToTokenType(tokenMap: tokenMap);
      switch(tokenType) {
        case TokenType.blockUser:
        final BlockUser blockUser = BlockUser.fromJson(tokenMap);
        blockUsers.add(blockUser);
        break;
        case TokenType.bookmarkLabel:
        final BookmarkLabel bookmarkLabel = BookmarkLabel.fromJson(tokenMap);
        bookmarkLabels.add(bookmarkLabel);
        break;
        case TokenType.likeComment:
        final LikeComment likeComment = LikeComment.fromJson(tokenMap);
        likeComments.add(likeComment);
        break;
        case TokenType.likePost:
        final LikePost likePost = LikePost.fromJson(tokenMap);
        likePosts.add(likePost);
        break;
        case TokenType.likeReply:
        final LikeReply likeReply = LikeReply.fromJson(tokenMap);
        likeReplys.add(likeReply);
        break;
        case TokenType.muteComment:
        final MuteComment muteComment = MuteComment.fromJson(tokenMap);
        muteComments.add(muteComment);
        break;
        case TokenType.mutePost:
        final MutePost mutePost = MutePost.fromJson(tokenMap);
        mutePosts.add(mutePost);
        break;
        case TokenType.muteReply:
        final MuteReply muteReply = MuteReply.fromJson(tokenMap);
        muteReplys.add(muteReply);
        break;
        case TokenType.muteUser:
        final MuteUser muteUser = MuteUser.fromJson(tokenMap);
        muteUsers.add(muteUser);
        break;
        case TokenType.readPost:
        final ReadPost readPost = ReadPost.fromJson(tokenMap);
        readPosts.add(readPost);
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
    });
  }

  void setList() {
    // // likes
    // likePostIds = prefs.getStringList(likePostIdsPrefsKey) ?? [];
    // bookmarkLabels.forEach((bookmarkLabel) {
    //   (bookmarkLabel.bookmarks as List<String> ).forEach((bookmark) {
    //     final Bookmark x = fromMapToBookmark(map: bookmark as Map<String,dynamic>);
    //     bookmarks.add(x);
    //     bookmarksPostIds.add(x.postId);
    //   });
    // });
    // // followingUids
    // followingUids = userMeta.followingUids.map((e) => e as String).toList();
    // followingUids.add(currentUser!.uid);
    // // likeComments
    // likeCommentIds = prefs.getStringList(likeCommentIdsPrefsKey) ?? [];
    // // readPosts
    // readPostIds = prefs.getStringList(readPostIdsPrefsKey) ?? [];
    // // likeReplys
    // likeReplyIds = prefs.getStringList(likeReplyIdsPrefsKey) ?? [];
    // // mutesAndBlocks
    // voids.setMutesAndBlocks(prefs: prefs, muteUsers: muteUsers, mutesIpv6s: mutesIpv6s, mutesUids: mutesUids, mutesPostIds: mutePostIds, blockUsers: blockUsers, blocksIpv6s: blockIpv6s, blocksUids: blockUids);
    // muteReplyIds = prefs.getStringList(muteReplyIdsPrefsKey) ?? [];
    // muteCommentIds = prefs.getStringList(muteCommentIdsPrefsKey) ?? [];
  }
  
  void reload() {
    notifyListeners();
  }
}