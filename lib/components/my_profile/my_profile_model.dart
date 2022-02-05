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
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/domain/post/post.dart';
import 'package:whisper/domain/whisper_user/whisper_user.dart';
// domain
import 'package:whisper/domain/whisper_link/whisper_link.dart';
// pages
import 'package:whisper/links/links_page.dart';
// notifiers
import 'package:whisper/posts/notifiers/play_button_notifier.dart';
import 'package:whisper/posts/notifiers/progress_notifier.dart';
import 'package:whisper/posts/notifiers/repeat_button_notifier.dart';
// model
import 'package:whisper/main_model.dart';
final myProfileProvider = ChangeNotifierProvider(
  (ref) => MyProfileModel()
);

class MyProfileModel extends ChangeNotifier {

  bool isLoading = false;
  late DocumentSnapshot<Map<String,dynamic>> currentUserDoc;
  Query<Map<String, dynamic>> getQuery() {
    final x = returnPostsColRef(postCreatorUid: currentUserDoc.id ).orderBy(createdAtFieldKey,descending: true).limit(oneTimeReadCount);
    return x;
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
  String description = '';
  final whisperLinksNotifier = ValueNotifier<List<WhisperLink>>([]);
  // post
  bool isCropped = false;
  XFile? xFile;
  File? croppedFile;
  // speed
  late SharedPreferences prefs;
  final speedNotifier = ValueNotifier<double>(1.0);
  // enums
  final PostType postType = PostType.myProfile;
  SortState sortState = SortState.byNewestFirst;

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


  Future getNewMyProfilePosts() async {
    await voids.processNewPosts(query: getQuery(), posts: posts, afterUris: afterUris, audioPlayer: audioPlayer, postType: postType, muteUids: [], blockUids: [], mutesPostIds: []);
  }

  Future getPosts() async {
    try {
      posts = [];
      await voids.processBasicPosts(query: getQuery(), posts: posts, afterUris: afterUris, audioPlayer: audioPlayer, postType: postType, muteUids: [], blockUids: [], mutePostIds: []);
    } catch(e) { print(e.toString()); }
  }

  Future<void> getOldMyProfilePosts() async {
    try {
      voids.processOldPosts(query: getQuery(), posts: posts, afterUris: afterUris, audioPlayer: audioPlayer, postType: postType, muteUids: [], blockUids: [], mutesPostIds: []);
    } catch(e) { print(e.toString()); }
  }

  void onEditButtonPressed() {
    isEditing = true;
    notifyListeners();
  }
  
  Future<void> onSaveButtonPressed({ required BuildContext context, required WhisperUser updateWhisperUser ,required MainModel mainModel,required List<WhisperLink> links }) async {
    if (userName.length <= maxSearchLength ) {
      startLoading();
      await voids.updateUserInfo(context: context,links: links, updateWhisperUser: updateWhisperUser, description: description, userName: userName ,mainModel: mainModel, croppedFile: croppedFile);
      isEditing = false;
      userName = '';
      description = '';
      whisperLinksNotifier.value = [];
      endLoading();
    } else {
      voids.maxSearchLengthAlert(context: context,isUserName: true);
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

  void initLinks({ required BuildContext context  ,required List<Map<String,dynamic>> linkMaps}) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => LinksPage(whisperLinksNotifier: whisperLinksNotifier, ) ));
    whisperLinksNotifier.value = [];
    whisperLinksNotifier.value = linkMaps.map((e) => fromMapToWhisperLink(whisperLink: e) ).toList();
    notifyListeners();
  }

}