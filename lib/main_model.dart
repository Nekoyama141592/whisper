// material
import 'package:flutter/material.dart';
// packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
// constants
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/voids.dart' as voids;
// domain
import 'package:whisper/domain/bookmark/bookmark.dart';
import 'package:whisper/domain/user_meta/user_meta.dart';
import 'package:whisper/domain/mute_user/mute_user.dart';
import 'package:whisper/domain/block_user/block_user.dart';
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

  List<String> likePostIds = [];
  List<String> bookmarksPostIds = [];
  List<String> followingUids = [];
  List<String> likeCommentIds = [];
  // bookmark
  List<Bookmark> bookmarks = [];
  List<BookmarkLabel> bookmarkLabels = [];
  List<String> readPostIds = [];
  List<String> likeReplyIds = [];
  // mutes 
  List<String> mutesUids = [];
  List<String> mutesIpv6s = [];
  // List<MuteUser> muteUsers = [];
  List<String> muteReplyIds = [];
  List<String> muteCommentIds = [];
  List<String> mutePostIds = [];
  // block
  List<String> blockUids = [];
  List<String> blockIpv6s = [];
  // List<BlockUser> blockUsers = [];
  // bookmarkLabel
  String bookmarkLabelId = '';

  MainModel() {
    init();
  }
  
  void init() async {
    startLoading();
    prefs = await SharedPreferences.getInstance();
    await setCurrentUser();
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

  void setList() {
    // likes
    likePostIds = prefs.getStringList(likePostIdsPrefsKey) ?? [];
    bookmarkLabels.forEach((bookmarkLabel) {
      (bookmarkLabel.bookmarks as List<String> ).forEach((bookmark) {
        final Bookmark x = fromMapToBookmark(map: bookmark as Map<String,dynamic>);
        bookmarks.add(x);
        bookmarksPostIds.add(x.postId);
      });
    });
    // followingUids
    followingUids = userMeta.followingUids.map((e) => e as String).toList();
    followingUids.add(currentUser!.uid);
    // likeComments
    likeCommentIds = prefs.getStringList(likeCommentIdsPrefsKey) ?? [];
    // readPosts
    readPostIds = prefs.getStringList(readPostIdsPrefsKey) ?? [];
    // likeReplys
    likeReplyIds = prefs.getStringList(likeReplyIdsPrefsKey) ?? [];
    // mutesAndBlocks
    voids.setMutesAndBlocks(prefs: prefs, muteUsers: muteUsers, mutesIpv6s: mutesIpv6s, mutesUids: mutesUids, mutesPostIds: mutePostIds, blockUsers: blockUsers, blocksIpv6s: blockIpv6s, blocksUids: blockUids);
    muteReplyIds = prefs.getStringList(muteReplyIdsPrefsKey) ?? [];
    muteCommentIds = prefs.getStringList(muteCommentIdsPrefsKey) ?? [];
  }
  
  void reload() {
    notifyListeners();
  }
}