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
import 'package:whisper/domain/whisper_user/whisper_user.dart';
import 'package:whisper/domain/user_meta/user_meta.dart';
import 'package:whisper/domain/bookmark/bookmark.dart';
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
  List<dynamic> followingUids = [];
  List<dynamic> likeCommentIds = [];
  // bookmark
  List<Bookmark> bookmarks = [];
  List<BookmarkLabel> bookmarkLabels = [];
  List<dynamic> readPostIds = [];
  List<dynamic> likeReplyIds = [];
  // mutes 
  List<dynamic> mutesUids = [];
  List<dynamic> mutesIpv6s = [];
  List<dynamic> mutesIpv6AndUids = [];
  List<String> mutesReplyIds = [];
  List<String> mutesCommentIds = [];
  List<String> mutesPostIds = [];
  // block
  List<dynamic> blocksUids = [];
  List<dynamic> blocksIpv6s = [];
  List<dynamic> blocksIpv6AndUids = [];
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
    // bookmarks
    // bookmarks = (userMeta.bookmarks).map((bookmark) => fromMapToBookmark(map: bookmark)).toList();
    bookmarkLabels.forEach((bookmarkLabel) {
      (bookmarkLabel.bookmarks as List<dynamic> ).forEach((bookmark) {
        final x = fromMapToBookmark(map: bookmark as Map<String,dynamic>);
        bookmarks.add(x);
      });
    });
    bookmarksPostIds = bookmarks.map((e) => e.postId ).toList();
    // followingUids
    followingUids = userMeta.followingUids;
    followingUids.add(currentUser!.uid);
    // likeComments
    likeCommentIds = prefs.getStringList(likeCommentIdsPrefsKey) ?? [];
    // readPosts
    readPostIds = prefs.getStringList(readPostIdsPrefsKey) ?? [];
    // likeReplys
    likeReplyIds = prefs.getStringList(likeReplyIdsPrefsKey) ?? [];
    // mutesAndBlocks
    voids.setMutesAndBlocks(prefs: prefs,currentWhisperUser: currentWhisperUser,mutesIpv6AndUids: mutesIpv6AndUids, mutesIpv6s: mutesIpv6s, mutesUids: mutesUids, mutesPostIds: mutesPostIds, blocksIpv6AndUids: blocksIpv6AndUids, blocksIpv6s: blocksIpv6s, blocksUids: blocksUids);
    mutesReplyIds = prefs.getStringList(mutesReplyIdsKey) ?? [];
    mutesCommentIds = prefs.getStringList(mutesCommentIdsKey) ?? [];
  }
  
  void reload() {
    notifyListeners();
  }
}