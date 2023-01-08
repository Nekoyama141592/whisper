// material
import 'package:flutter/material.dart';
// packages
import 'package:flash/flash.dart';
import 'package:just_audio/just_audio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/abstract_models/posts_model.dart';
// constants
import 'package:whisper/constants/enums.dart';
import 'package:whisper/constants/ints.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/domain/bookmark_post/bookmark_post.dart';
// domain
import 'package:whisper/domain/bookmark_post_category/bookmark_post_category.dart';
import 'package:whisper/l10n/l10n.dart';
// model
import 'package:whisper/main_model.dart';

final bookmarksProvider = ChangeNotifierProvider(
  (ref) => BookmarksModel()
);

class BookmarksModel extends PostsModel {
  BookmarksModel() : super(postType: PostType.bookmarks);
  // cloudFirestore
  List<String> bookmarkPostIds = [];
  // init
  bool isInitFinished = false;
  String indexBookmarkPostLabelId = '';
  bool isBookmarkMode = false;
  // editLabel
  String editLabel = '';
  // new
  String newLabel = '';
  Future<void> init({required BuildContext context ,required MainModel mainModel,required BookmarkPostCategory bookmarkLabel }) async {
    isBookmarkMode = true;
    notifyListeners();
    if (indexBookmarkPostLabelId != bookmarkLabel.tokenId) {
      indexBookmarkPostLabelId = bookmarkLabel.tokenId;
      bookmarkPostIds = [];
      posts = [];
      startLoading();
      audioPlayer = AudioPlayer();
      setBookmarksPostIds(mainModel: mainModel, );
      await processBookmark();
      prefs = mainModel.prefs;
      await setSpeed();
      if (isInitFinished == false) {
        listenForStates();
        isInitFinished = true;
      }
      endLoading();
    }
  }

  void back() {
    isBookmarkMode = false;
    notifyListeners();
  }

  Future<void> onReload({ required MainModel mainModel }) async {
    startLoading();
    setBookmarksPostIds(mainModel: mainModel);
    await processBookmark();
    endLoading();
  }

  Future<void> onLoading() async {
    await processOldBookmark();
    refreshController.loadComplete();
    notifyListeners();
  }

  void setBookmarksPostIds({ required MainModel mainModel, }){
    List<BookmarkPost> x = mainModel.bookmarkPosts.where((element) => element.bookmarkPostCategoryId == indexBookmarkPostLabelId ).toList();
    x.sort((a,b)=> (b.createdAt as Timestamp ).compareTo(a.createdAt) );
    bookmarkPostIds = x.map((e) => e.postId ).toList();
    notifyListeners();
  }

  Future<void> processBookmark() async {
    if (bookmarkPostIds.length > posts.length) {
      final bool = (bookmarkPostIds.length - posts.length) > 10;
      final int postsLength = posts.length;
      List<String> max10BookmarkPostIds = bool ? bookmarkPostIds.sublist(postsLength,postsLength + tenCount ) : bookmarkPostIds.sublist(postsLength,bookmarkPostIds.length);
      if (max10BookmarkPostIds.isNotEmpty) {
        final query = returnPostsColGroupQuery().where(postIdFieldKey,whereIn: max10BookmarkPostIds).limit(tenCount);
        await processBasicPosts(query: query, muteUids: [], blockUids: [], mutePostIds: []);
      }
    }
  }
  Future<void> processOldBookmark() async {
    if (bookmarkPostIds.length > posts.length) {
      final bool = (bookmarkPostIds.length - posts.length) > 10;
      final int postsLength = posts.length;
      List<String> max10BookmarkPostIds = bool ? bookmarkPostIds.sublist(postsLength,postsLength + tenCount ) : bookmarkPostIds.sublist(postsLength,bookmarkPostIds.length);
      if (max10BookmarkPostIds.isNotEmpty) {
        final query = returnPostsColGroupQuery().where(postIdFieldKey,whereIn: max10BookmarkPostIds).limit(tenCount);
        await processOldPosts(query: query, muteUids: [], blockUids: [], mutePostIds: []);
      }
    }
  }

  Future<void> onUpdateLabelButtonPressed({ required BuildContext context  ,required FlashController flashController,required MainModel mainModel,required int i}) async {
    final userMeta = mainModel.userMeta;
    if (editLabel.isEmpty) {
      final L10n l10n = returnL10n(context: context)!;
      voids.showBasicFlutterToast(context: context, msg: l10n.emptyIsInvalid);
    } else if (editLabel.length > maxSearchLength) {
      voids.maxSearchLengthAlert(context: context, isUserName: false );
    } else {
      // process set
      final bookmarkPostCategory = mainModel.bookmarkPostCategories[i];
      mainModel.bookmarkPostCategories[i] = bookmarkPostCategory.copyWith(categoryName: editLabel);
      // process UI
      flashController.dismiss();
      notifyListeners();
      // process backend
      await returnTokenDocRef(uid: userMeta.uid, tokenId: bookmarkPostCategory.tokenId ).update(bookmarkPostCategory.toJson());
      editLabel = '';
    }
  }

  Future<void> addBookmarkPostLabel({ required MainModel mainModel, required BuildContext context,required FlashController flashController, }) async {
    if (newLabel.isEmpty) {
      final L10n l10n = returnL10n(context: context)!;
      voids.showBasicFlutterToast(context: context, msg: l10n.emptyIsInvalid);
    } else if (newLabel.length > maxSearchLength) {
      voids.maxSearchLengthAlert(context: context, isUserName: false );
    } else {
      // process set
      final now = Timestamp.now();
      final String tokenId = returnTokenId(userMeta: mainModel.userMeta, tokenType: TokenType.bookmarkPostCategory );
      BookmarkPostCategory bookmarkPostCategory = BookmarkPostCategory(createdAt: now,updatedAt: now,tokenType: bookmarkPostCategoryTokenType,imageURL: '',uid: mainModel.userMeta.uid,tokenId: tokenId,categoryName: newLabel);
      bookmarkPostCategory = bookmarkPostCategory.copyWith(categoryName: newLabel);
      // process Ui
      mainModel.bookmarkPostCategories.add(bookmarkPostCategory);
      flashController.dismiss();
      notifyListeners();
      // process backend
      await returnTokenDocRef(uid: mainModel.userMeta.uid, tokenId: bookmarkPostCategory.tokenId ).set(bookmarkPostCategory.toJson());
      newLabel = '';
    }
  }

}

