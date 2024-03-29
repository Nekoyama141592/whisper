// dart
import 'dart:io';
// material
import 'package:flutter/cupertino.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whisper/abstract_models/posts_model.dart';
// constants
import 'package:whisper/constants/enums.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/ints.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/widgets.dart';
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/constants/routes.dart' as routes;
import 'package:whisper/domain/whisper_user/whisper_user.dart';
// components
import 'package:whisper/details/positive_text.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/models/post_search/post_search_model.dart';

final myProfileProvider = ChangeNotifierProvider(
  (ref) => MyProfileModel()
);

class MyProfileModel extends PostsModel {

  late DocumentSnapshot<Map<String,dynamic>> currentUserDoc;
  SortState sortState = SortState.byNewestFirst;
  Query<Map<String, dynamic>> getQuery () {
    final basicQuery = returnPostsColRef(postCreatorUid: firebaseAuthCurrentUser()!.uid).limit(oneTimeReadCount);
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
  // Edit profile
  bool isEditing = false;
  String userName = '';
  // post
  bool isCropped = false;
  XFile? xFile;
  File? croppedFile;

  MyProfileModel() : super(postType: PostType.myProfile) {
    init();
  }

  Future<void> init() async {
    startLoading();
    audioPlayer = AudioPlayer();
    refreshController = RefreshController(initialRefresh: false);
    prefs = await SharedPreferences.getInstance();
    await setCurrentUserDoc();
    await getPosts();
    await super.setSpeed();
    super.listenForStates();
    endLoading();
  }

  Future<void> setCurrentUserDoc() async => currentUserDoc = await FirebaseFirestore.instance.collection(usersFieldKey).doc(FirebaseAuth.instance.currentUser!.uid).get();

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
      case SortState.byLikeUidCount:
      break;
      case SortState.byNewestFirst:
      await processNewPosts(query: getQuery(), muteUids: [], blockUids: [], mutesPostIds: []);
      break;
      case SortState.byOldestFirst:
      break;
    }
    
  }

  Future<void> getPosts() async {
    posts = [];
    afterUris = [];
    await processBasicPosts(query: getQuery(), muteUids: [], blockUids: [], mutePostIds: []);
  }

  Future<void> getOldMyProfilePosts() async => await processOldPosts(query: getQuery(), muteUids: [], blockUids: [], mutePostIds: []);

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
    if (xFile != null) await cropImage();
    notifyListeners();
  }

  Future<void> cropImage() async {
    isCropped = false;
    croppedFile = null;
    croppedFile = await returnCroppedFile(xFile: xFile);
    if (croppedFile != null) isCropped = true;
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
          message: boldEllipsisText(text: selectOperationText(context: context)),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(innerContext);
                routes.toPostSearchPage(context: context, passiveWhisperUser: mainModel.currentWhisperUser, mainModel: mainModel, postSearchModel: postSearchModel);
              }, 
              child: PositiveText(text: search(context: context)),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(innerContext);
                if (sortState != SortState.byLikeUidCount) {
                  sortState = SortState.byLikeUidCount;
                  await onReload();
                }
              }, 
              child: PositiveText(text: sortByLikeUidCountText(context: context)),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(innerContext);
                if (sortState != SortState.byNewestFirst) {
                  sortState = SortState.byNewestFirst;
                  await onReload();
                }
              }, 
              child: PositiveText(text: sortByNewestFirstText(context: context)),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(innerContext);
                if (sortState != SortState.byOldestFirst) {
                  sortState = SortState.byOldestFirst;
                  await onReload();
                }
              }, 
              child: PositiveText(text: sortByOldestFirstText(context: context)),
            ),
            CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(innerContext),
              child: PositiveText(text: cancelText(context: context)),
            ),
          ],
        );
      }
    );
  } 

}