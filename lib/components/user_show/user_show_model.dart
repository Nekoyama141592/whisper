// dart
import 'dart:io';
// material
import 'package:flutter/cupertino.dart';
// packages
import 'package:just_audio/just_audio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
// constants
import 'package:whisper/constants/enums.dart';
import 'package:whisper/constants/ints.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/constants/routes.dart' as routes;
import 'package:whisper/constants/widgets.dart';
import 'package:whisper/domain/post/post.dart';
// domain
import 'package:whisper/domain/follower/follower.dart';
import 'package:whisper/domain/following/following.dart';
import 'package:whisper/domain/whisper_user/whisper_user.dart';
// notifiers
import 'package:whisper/posts/notifiers/play_button_notifier.dart';
import 'package:whisper/posts/notifiers/progress_notifier.dart';
import 'package:whisper/posts/notifiers/repeat_button_notifier.dart';
// components
import 'package:whisper/details/positive_text.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/components/user_show/components/other_pages/post_search/post_search_model.dart';

final userShowProvider = ChangeNotifierProvider(
  (ref) => UserShowModel()
);

class UserShowModel extends ChangeNotifier {
  
  late WhisperUser passiveWhisperUser;
  // enums
  final PostType postType = PostType.userShow;
  SortState sortState = SortState.byNewestFirst;
  Query<Map<String, dynamic>> getQuery ({ required WhisperUser passiveWhisperUser }) {
    final basicQuery = returnPostsColRef(postCreatorUid: passiveWhisperUser.uid).limit(oneTimeReadCount);
    switch(sortState) {
      case SortState.byLikeUidCount:
        final x = basicQuery.orderBy(likeCountFieldKey,descending: true);
      return x;
      case SortState.byNewestFirst:
        final x = basicQuery.orderBy(createdAtFieldKey,descending: true);
      return x;
      case SortState.byOldestFirst:
        final x = basicQuery.orderBy(createdAtFieldKey,descending: false);
      return x;
    }
  }
  String passiveUid = '';
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
  List<DocumentSnapshot<Map<String,dynamic>>> posts = [];
  // refresh
  RefreshController refreshController = RefreshController(initialRefresh: false);
  // Edit profile
  bool isEditing = false;
  String userName = '';
  // post
  bool isCropped = false;
  XFile? xFile;
  File? croppedFile;
  // block
  bool isBlocked = false;
  // speed
  late SharedPreferences prefs;
  final speedNotifier = ValueNotifier<double>(1.0);

  Future<void> init({ required DocumentSnapshot<Map<String,dynamic>> passiveUserDoc, required SharedPreferences givePrefs}) async {
    startLoading();
    if (isBlocked == false) {
      audioPlayer = AudioPlayer();
      refreshController = RefreshController(initialRefresh: false);
      passiveWhisperUser = fromMapToWhisperUser(userMap: passiveUserDoc.data()! );
      passiveUid = passiveUserDoc.id;
      prefs = givePrefs;
      await getPosts();
      await voids.setSpeed(audioPlayer: audioPlayer,prefs: prefs,speedNotifier: speedNotifier);
      voids.listenForStates(audioPlayer: audioPlayer, playButtonNotifier: playButtonNotifier, progressNotifier: progressNotifier, currentWhisperPostNotifier: currentWhisperPostNotifier, isShuffleModeEnabledNotifier: isShuffleModeEnabledNotifier, isFirstSongNotifier: isFirstSongNotifier, isLastSongNotifier: isLastSongNotifier);
    }
    endLoading();
  }

  void theSameUser({ required BuildContext context, required MainModel mainModel }) {
    audioPlayer = AudioPlayer();
    refreshController = RefreshController(initialRefresh: false);
    routes.toUserShowPage(context: context, mainModel: mainModel);
  }

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future<void> onRefresh() async {
    await getNewUserShowPosts();
    refreshController.refreshCompleted();
    notifyListeners();
  }

  Future<void> onReload() async {
    startLoading();
    await getPosts();
    endLoading();
  }

  Future<void> onLoading() async {
    await getOldUserShowPosts();
    refreshController.loadComplete();
    notifyListeners();
  }

  Future<void> getNewUserShowPosts() async {
    switch(sortState) {
      case SortState.byLikeUidCount:
      break;
      case SortState.byNewestFirst:
      await voids.processNewPosts(query: getQuery( passiveWhisperUser: passiveWhisperUser,), posts: posts, afterUris: afterUris, audioPlayer: audioPlayer, postType: postType, muteUids: [], blockUids: [], mutesPostIds: []);
      break;
      case SortState.byOldestFirst:
      break;
    }
    
  }

  Future<void> getPosts() async {
    posts = [];
    afterUris = [];
    await voids.processBasicPosts(query: getQuery( passiveWhisperUser: passiveWhisperUser,), posts: posts, afterUris: afterUris, audioPlayer: audioPlayer, postType: postType, muteUids: [], blockUids: [], mutePostIds: []);
  }

  Future<void> getOldUserShowPosts() async => await voids.processOldPosts(query: getQuery( passiveWhisperUser: passiveWhisperUser,), posts: posts, afterUris: afterUris, audioPlayer: audioPlayer, postType: postType, muteUids: [], blockUids: [], mutePostIds: []);

  Future<void> showImagePicker() async {
    final ImagePicker _picker = ImagePicker();
    xFile = await _picker.pickImage(source: ImageSource.gallery);
    if (xFile != null) await cropImage(); 
    notifyListeners();
  }

  Future<void> cropImage() async {
    isCropped = false;
    croppedFile = null;
    croppedFile = await returnCroppedFile(xFile: xFile);
    if (croppedFile != null) isCropped = true;
  }

  void seek(Duration position) {
    audioPlayer.seek(position);
  }

  void onEditButtonPressed() {
    isEditing = true;
    notifyListeners();
  }

  Future<void> onSaveButtonPressed({ required BuildContext context, required WhisperUser updateWhisperUser,required MainModel mainModel,}) async {
    if (userName.length > maxSearchLength) {
      voids.maxSearchLengthAlert(context: context,isUserName: true);
    } else {
      startLoading();
      await voids.updateUserInfo(context: context, updateWhisperUser: updateWhisperUser, userName: userName,croppedFile: croppedFile, mainModel: mainModel);
      isEditing = false;
      userName = '';
      endLoading();
    }
  }

  void onCancelButtonPressed() {
    isEditing = false;
    notifyListeners();
  }

  void onMenuPressed({ required BuildContext context,required MainModel mainModel,required PostSearchModel postSearchModel }) {
    showCupertinoModalPopup(
      context: context, 
      builder: (innerContext) {
        return CupertinoActionSheet(
          message: boldText(text: selectOperationJaText),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(innerContext);
                routes.toPostSearchPage(context: context, passiveWhisperUser: passiveWhisperUser, mainModel: mainModel, postSearchModel: postSearchModel);
              }, 
              child: PositiveText(text: searchJaText),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(innerContext);
                if (sortState != SortState.byLikeUidCount) {
                  sortState = SortState.byLikeUidCount;
                  await onReload();
                }
              }, 
              child: PositiveText(text: sortByLikeUidCountText),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(innerContext);
                if (sortState != SortState.byNewestFirst) {
                  sortState = SortState.byNewestFirst;
                  await onReload();
                }
              }, 
              child: PositiveText(text: sortByNewestFirstText),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(innerContext);
                if (sortState != SortState.byOldestFirst) {
                  sortState = SortState.byOldestFirst;
                  await onReload();
                }
              }, 
              child: PositiveText(text: sortByOldestFirstText),
            ),
            CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(innerContext),
              child: PositiveText(text: cancelText),
            ),
          ],
        );
      }
    );
  } 

  Future<void> follow({ required BuildContext context,required MainModel mainModel, required WhisperUser passiveWhisperUser }) async {
  if (mainModel.followingUids.length >= maxFollowCount) {
    voids.showBasicFlutterToast(context: context, msg: limitFollowingJaMsg );
  } else {
    // process set
    final Timestamp now = Timestamp.now();
    final userMeta = mainModel.userMeta;
    final String activeUid = userMeta.uid;
    final String passiveUid = passiveWhisperUser.uid;
    final String tokenId = returnTokenId(userMeta: userMeta, tokenType: TokenType.following );
    final Following following = Following(myUid: activeUid, createdAt: now, passiveUid: passiveUid,tokenId: tokenId, tokenType: followingTokenType );
    // processUI
    mainModel.following.add(following);
    mainModel.followingUids.add(passiveUid);
    mainModel.currentWhisperUser.followingCount += plusOne;
    passiveWhisperUser.followerCount += plusOne;
    notifyListeners();
    // process backend
    await returnTokenDocRef(uid: activeUid, tokenId: tokenId).set(following.toJson());
    final Follower follower = Follower(createdAt: now,followedUid: passiveUid,followerUid: userMeta.uid );
    await returnFollowerDocRef(uid: passiveUid, followerUid: userMeta.uid ).set(follower.toJson());
  }
}

  Future<void> unfollow({ required MainModel mainModel,required WhisperUser passiveWhisperUser }) async {
    // process set
    final userMeta = mainModel.userMeta;
    final activeUid = userMeta.uid;
    final passiveUid = passiveWhisperUser.uid;
    final deleteFollowingToken = mainModel.following.where((element) => element.passiveUid == passiveUid).first;
    // processUI
    mainModel.following.remove(deleteFollowingToken);
    mainModel.followingUids.remove(passiveUid);
    mainModel.currentWhisperUser.followingCount += minusOne;
    passiveWhisperUser.followerCount += minusOne;
    notifyListeners();
    // process backend
    await returnTokenDocRef(uid: activeUid, tokenId: deleteFollowingToken.tokenId ).delete();
    await returnFollowerDocRef(uid: passiveUid, followerUid: activeUid ).delete();
  }

}