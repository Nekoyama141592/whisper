// dart
import 'dart:io';
// material
import 'package:flutter/material.dart';
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
import 'package:whisper/domain/post/post.dart';
// domain
import 'package:whisper/domain/whisper_user/whisper_user.dart';
import 'package:whisper/domain/follower/follower.dart';
import 'package:whisper/domain/following/following.dart';
import 'package:whisper/domain/user_meta/user_meta.dart';
// notifiers
import 'package:whisper/posts/notifiers/play_button_notifier.dart';
import 'package:whisper/posts/notifiers/progress_notifier.dart';
import 'package:whisper/posts/notifiers/repeat_button_notifier.dart';
// model
import 'package:whisper/main_model.dart';

final userShowProvider = ChangeNotifierProvider(
  (ref) => UserShowModel()
);

class UserShowModel extends ChangeNotifier {
  
  late WhisperUser passiveWhisperUser;
  Query<Map<String, dynamic>> getQuery ({ required WhisperUser passiveWhisperUser }) {
    final x = returnPostsColRef(postCreatorUid: passiveWhisperUser.uid).orderBy(createdAtFieldKey,descending: true).limit(oneTimeReadCount);
    return x;
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
  // enums
  final PostType postType = PostType.userShow;
  SortState sortState = SortState.byNewestFirst;

  Future<void> init(DocumentSnapshot<Map<String,dynamic>> passiveUserDoc,SharedPreferences givePrefs) async {
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

  void reload() {
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
    await voids.processNewPosts(query: getQuery( passiveWhisperUser: passiveWhisperUser), posts: posts, afterUris: afterUris, audioPlayer: audioPlayer, postType: postType, muteUids: [], blockUids: [], mutesPostIds: []);
  }

  Future<void> getPosts() async {
    try {
      posts = [];
      await voids.processBasicPosts(query: getQuery( passiveWhisperUser: passiveWhisperUser), posts: posts, afterUris: afterUris, audioPlayer: audioPlayer, postType: postType, muteUids: [], blockUids: [], mutePostIds: []);

    } catch(e) { print(e.toString()); }
    notifyListeners();
  }

  Future<void> getOldUserShowPosts() async {
    try {
      await voids.processOldPosts(query: getQuery( passiveWhisperUser: passiveWhisperUser), posts: posts, afterUris: afterUris, audioPlayer: audioPlayer, postType: postType, muteUids: [], blockUids: [], mutePostIds: []);
    } catch(e) { print(e.toString()); }
  }

  Future<void> showImagePicker() async {
    final ImagePicker _picker = ImagePicker();
    xFile = await _picker.pickImage(source: ImageSource.gallery);
    if (xFile != null) { await cropImage(); }
    notifyListeners();
  }

  Future<void> cropImage() async {
    isCropped = false;
    croppedFile = null;
    croppedFile = await returnCroppedFile(xFile: xFile);
    if (croppedFile != null) { isCropped = true; }
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

    void showSortPostDocsDialogue(BuildContext context,String uid) {
    showCupertinoDialog(
      context: context, 
      builder: (context) {
        return CupertinoActionSheet(
          title: Text('並び替え',style: TextStyle(fontWeight: FontWeight.bold)),
          message: Text('投稿を新たに取得します',style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () async {
                posts = [];
                afterUris = [];
                // getDocsFromFirestore
                // makeQuery
              }, 
              child: Text(
                'いいね順',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).highlightColor,
                ) 
              )
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                posts = [];
                afterUris = [];
                // getDocsFromFirestore
                // makeQuery
              }, 
              child: Text(
                '新しい順',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).highlightColor,
                ) 
              )
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                posts = [];
                afterUris = [];
                // getDocsFromFirestore
                // makeQuery
              }, 
              child: Text(
                '古い順',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).highlightColor,
                ) 
              )
            ),
            CupertinoActionSheetAction(
              onPressed: () { Navigator.pop(context); }, 
              child: Text(
                'キャンセル',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).highlightColor,
                ) 
              )
            ),
          ],
        );
      }
    );
  } 

  Future<void> follow({ required BuildContext context,required MainModel mainModel, required WhisperUser passiveWhisperUser }) async {
  if (mainModel.followingUids.length >= maxFollowCount) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Limit' + maxFollowCount.toString() + 'Following' )));
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
    await createFollower(userMeta: userMeta, now: now, passiveUid: passiveUid);
    await updateFollowingCountOfCurrentWhisperUser(currentWhisperUser: mainModel.currentWhisperUser, now: now);
  }
}

Future<void> updateFollowingCountOfCurrentWhisperUser({ required WhisperUser currentWhisperUser,required Timestamp now }) async {
  await returnUserDocRef(uid: currentWhisperUser.uid).update({
    followingCountFieldKey: currentWhisperUser.followingCount,
    updatedAtFieldKey: now,
  });
}

Future<void> createFollower({ required UserMeta userMeta,required Timestamp now,required String passiveUid }) async {
  final Follower follower = Follower(createdAt: now,followedUid: passiveUid,followerUid: userMeta.uid );
  await returnFollowerDocRef(uid: passiveUid, followerUid: userMeta.uid ).set(follower.toJson());
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
  await updateFollowingCountOfCurrentWhisperUser(currentWhisperUser: mainModel.currentWhisperUser, now: Timestamp.now() );
}

}