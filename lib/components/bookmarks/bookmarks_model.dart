// material
import 'package:flutter/material.dart';
// packages
import 'package:flash/flash.dart';
import 'package:just_audio/just_audio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
// constants
import 'package:whisper/constants/enums.dart';
import 'package:whisper/constants/ints.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/domain/bookmark_post/bookmark_post.dart';
// domain
import 'package:whisper/domain/bookmark_post_label/bookmark_post_label.dart';
import 'package:whisper/domain/post/post.dart';
import 'package:whisper/domain/user_meta/user_meta.dart';
// notifiers
import 'package:whisper/posts/notifiers/play_button_notifier.dart';
import 'package:whisper/posts/notifiers/progress_notifier.dart';
import 'package:whisper/posts/notifiers/repeat_button_notifier.dart';
// model
import 'package:whisper/main_model.dart';

final bookmarksProvider = ChangeNotifierProvider(
  (ref) => BookmarksModel()
);

class BookmarksModel extends ChangeNotifier {
  
  bool isLoading = false;
  // notifiers
  final currentWhisperPostNotifier = ValueNotifier<Post?>(null);
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
  int lastIndex = 0;
  List<String> bookmarkPostIds = [];
  List<DocumentSnapshot<Map<String,dynamic>>> posts = [];
  // refresh
  RefreshController refreshController = RefreshController(initialRefresh: false);
  // speed
  late SharedPreferences prefs;
  final speedNotifier = ValueNotifier<double>(1.0);
  // enums
  final PostType postType = PostType.bookmarks;
  // init
  bool isInitFinished = false;
  String indexBookmarkPostLabelId = '';
  bool isBookmarkMode = false;
  // editLabel
  String editLabel = '';
  // new
  String newLabel = '';
  
  Future<void> init({required BuildContext context ,required MainModel mainModel,required BookmarkPostLabel bookmarkLabel }) async {
    isBookmarkMode = true;
    notifyListeners();
    if (indexBookmarkPostLabelId != bookmarkLabel.tokenId) {
      indexBookmarkPostLabelId = bookmarkLabel.tokenId;
      bookmarkPostIds = [];
      posts = [];
      startLoading();
      audioPlayer = AudioPlayer();
      setBookmarksPostIds(mainModel: mainModel, );
      await getBookmarks();
      prefs = mainModel.prefs;
      await voids.setSpeed(audioPlayer: audioPlayer,prefs: prefs,speedNotifier: speedNotifier);
      if (isInitFinished == false) {
        voids.listenForStates(audioPlayer: audioPlayer, playButtonNotifier: playButtonNotifier, progressNotifier: progressNotifier, currentWhisperPostNotifier: currentWhisperPostNotifier, isShuffleModeEnabledNotifier: isShuffleModeEnabledNotifier, isFirstSongNotifier: isFirstSongNotifier, isLastSongNotifier: isLastSongNotifier);
        isInitFinished = true;
      }
      endLoading();
    }
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

  void back() {
    isBookmarkMode = false;
    notifyListeners();
  }

  // Future<void> onRefresh() async {
  //   await getNewBookmarks(bookmarkPostIds: bookmarkPostIds);
  //   refreshController.refreshCompleted();
  //   notifyListeners();
  // }

  Future<void> onReload({ required MainModel mainModel }) async {
    startLoading();
    setBookmarksPostIds(mainModel: mainModel);
    await getBookmarks();
    endLoading();
  }

  Future<void> onLoading() async {
    await getOldBookmarks();
    refreshController.loadComplete();
    notifyListeners();
  }

  void setBookmarksPostIds({ required MainModel mainModel, }){
    final x = mainModel.bookmarkPosts.where((element) => element.bookmarkLabelId == indexBookmarkPostLabelId ).toList();
    x.sort((a,b)=> (b.createdAt as Timestamp ).compareTo(a.createdAt) );
    bookmarkPostIds = x.map((e) => e.postId ).toList();
    notifyListeners();
  }

  Future<void> getBookmarks() async {
    await processBookmark();
  }

  Future<void> processBookmark() async {
    if (bookmarkPostIds.isNotEmpty) {
      List<String> max10 = bookmarkPostIds.length > (lastIndex + tenCount) ? bookmarkPostIds.sublist(lastIndex,tenCount) : bookmarkPostIds.sublist( lastIndex,bookmarkPostIds.length );
      List<DocumentSnapshot<Map<String,dynamic>>> docs = [];
      docs.sort((a,b)=> (BookmarkPost.fromJson(b.data()!).createdAt as Timestamp ).compareTo((BookmarkPost.fromJson(a.data()!).createdAt) ));
      await returnPostsColGroupQuery.where(postIdFieldKey,whereIn: max10).get().then((qshot) {
        docs = qshot.docs;
      });
      await voids.basicProcessContent(docs: docs, posts: posts, afterUris: afterUris, audioPlayer: audioPlayer, postType: postType, muteUids: [], blockUids: [], mutesPostIds: []);
      lastIndex = posts.length;
    }
  }

  Future<void> getOldBookmarks() async {
    if (bookmarkPostIds.length > (lastIndex + tenCount)) {
      await processBookmark();
    }
  }

  Future<void> onUpdateLabelButtonPressed({ required BuildContext context  ,required FlashController flashController,required BookmarkPostLabel bookmarkPostLabel,required UserMeta userMeta}) async {
    if (editLabel.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('空欄は不適です')));
    } else if (editLabel.length > maxSearchLength) {
      voids.maxSearchLengthAlert(context: context, isUserName: false );
    } else {
      // process set
      bookmarkPostLabel.label = editLabel;
      // process UI
      flashController.dismiss();
      notifyListeners();
      // process backend
      await returnTokenDocRef(uid: userMeta.uid, tokenId: bookmarkPostLabel.tokenId ).update(bookmarkPostLabel.toJson());
      editLabel = '';
    }
  }

  Future<void> addBookmarkPostLabel({ required MainModel mainModel, required BuildContext context,required FlashController flashController, }) async {
    if (newLabel.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('空欄は不適です')));
    } else if (newLabel.length > maxSearchLength) {
      voids.maxSearchLengthAlert(context: context, isUserName: false );
    } else {
      // process set
      final now = Timestamp.now();
      final String tokenId = returnTokenId(userMeta: mainModel.userMeta, tokenType: TokenType.bookmarkPostLabel );
      final BookmarkPostLabel bookmarkPostLabel = BookmarkPostLabel(createdAt: now,updatedAt: now,tokenType: bookmarkPostLabelTokenType,imageURL: '',uid: mainModel.userMeta.uid,tokenId: tokenId,label: newLabel);
      bookmarkPostLabel.label = newLabel;
      // process Ui
      mainModel.bookmarkPostLabels.add(bookmarkPostLabel);
      flashController.dismiss();
      notifyListeners();
      // process backend
      await returnTokenDocRef(uid: mainModel.userMeta.uid, tokenId: bookmarkPostLabel.tokenId ).set(bookmarkPostLabel.toJson());
      newLabel = '';
    }
  }

}

