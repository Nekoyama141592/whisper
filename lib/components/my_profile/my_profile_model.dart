// dart
import 'dart:io';
// material
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
// constants
import 'package:whisper/constants/enums.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/ints.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/domain/post/post.dart';
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/constants/routes.dart' as routes;
import 'package:whisper/domain/whisper_user/whisper_user.dart';
// notifiers
import 'package:whisper/posts/notifiers/play_button_notifier.dart';
import 'package:whisper/posts/notifiers/progress_notifier.dart';
import 'package:whisper/posts/notifiers/repeat_button_notifier.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/components/user_show/components/other_pages/post_search/post_search_model.dart';

final myProfileProvider = ChangeNotifierProvider(
  (ref) => MyProfileModel()
);

class MyProfileModel extends ChangeNotifier {

  bool isLoading = false;
  late DocumentSnapshot<Map<String,dynamic>> currentUserDoc;
  // enums
  final PostType postType = PostType.myProfile;
  SortState sortState = SortState.byNewestFirst;
  Query<Map<String, dynamic>> getQuery () {
    final basicQuery = returnPostsColRef(postCreatorUid: firebaseAuthCurrentUser()!.uid).limit(oneTimeReadCount);
    switch(sortState) {
      case SortState.byLikedUidCount:
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
  late RefreshController refreshController;
  // Edit profile
  bool isEditing = false;
  String userName = '';
  // post
  bool isCropped = false;
  XFile? xFile;
  File? croppedFile;
  // speed
  late SharedPreferences prefs;
  final speedNotifier = ValueNotifier<double>(1.0);

  MyProfileModel() {
    init();
  }

  Future<void> init() async {
    startLoading();
    audioPlayer = AudioPlayer();
    refreshController = RefreshController(initialRefresh: false);
    prefs = await SharedPreferences.getInstance();
    await setCurrentUserDoc();
    await getPosts();
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

  void seek(Duration position) {
    audioPlayer.seek(position);
  }

  Future<void> setCurrentUserDoc() async {
    currentUserDoc = await FirebaseFirestore.instance.collection(usersFieldKey).doc(FirebaseAuth.instance.currentUser!.uid).get();
  }

  void reload() {
    notifyListeners();
  }

  Future onRefresh() async {
    await getNewMyProfilePosts();
    refreshController.refreshCompleted();
    notifyListeners();
  }

  Future<void> onReload() async {
    startLoading();
    await getPosts();
    endLoading();
  }

  Future onLoading() async {
    await getOldMyProfilePosts();
    refreshController.loadComplete();
    notifyListeners();
  }
  Future<void> getNewMyProfilePosts() async {
    switch(sortState) {
      case SortState.byLikedUidCount:
      break;
      case SortState.byNewestFirst:
      await voids.processNewPosts(query: getQuery(), posts: posts, afterUris: afterUris, audioPlayer: audioPlayer, postType: postType, muteUids: [], blockUids: [], mutesPostIds: []);
      break;
      case SortState.byOldestFirst:
      break;
    }
    
  }

  Future<void> getPosts() async {
    posts = [];
    afterUris = [];
    await voids.processBasicPosts(query: getQuery(), posts: posts, afterUris: afterUris, audioPlayer: audioPlayer, postType: postType, muteUids: [], blockUids: [], mutePostIds: []);
  }

  Future<void> getOldMyProfilePosts() async {
    await voids.processOldPosts(query: getQuery(), posts: posts, afterUris: afterUris, audioPlayer: audioPlayer, postType: postType, muteUids: [], blockUids: [], mutePostIds: []);
  }

  void onEditButtonPressed() {
    isEditing = true;
    notifyListeners();
  }
  
  Future<void> onSaveButtonPressed({ required BuildContext context, required WhisperUser updateWhisperUser ,required MainModel mainModel,}) async {
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

  void onCancelButtonPressed() {
    isEditing = false;
    notifyListeners();
  }
  void onMenuPressed({ required BuildContext context,required MainModel mainModel,required PostSearchModel postSearchModel }) {
    showCupertinoModalPopup(
      context: context, 
      builder: (innerContext) {
        return CupertinoActionSheet(
          message: Text('行う操作を選択',style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(innerContext);
                routes.toPostSearchPage(context: context, passiveWhisperUser: mainModel.currentWhisperUser, mainModel: mainModel, postSearchModel: postSearchModel);
              }, 
              child: Text(
                '検索',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).highlightColor,
                ) 
              )
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(innerContext);
                if (sortState != SortState.byLikedUidCount) {
                  sortState = SortState.byLikedUidCount;
                  print(sortState.toString());
                  await onReload();
                }
              }, 
              child: Text(
                'いいね順に並び替え',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).highlightColor,
                ) 
              )
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(innerContext);
                if (sortState != SortState.byNewestFirst) {
                  sortState = SortState.byNewestFirst;
                  print(sortState.toString());
                  await onReload();
                }
              }, 
              child: Text(
                '新しい順に並び替え',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).highlightColor,
                ) 
              )
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(innerContext);
                if (sortState != SortState.byOldestFirst) {
                  sortState = SortState.byOldestFirst;
                  print(sortState.toString());
                  await onReload();
                }
              }, 
              child: Text(
                '古い順に並び替え',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).highlightColor,
                ) 
              )
            ),
            CupertinoActionSheetAction(
              onPressed: () { Navigator.pop(innerContext); }, 
              child: Text(
                'Cancel',
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

}