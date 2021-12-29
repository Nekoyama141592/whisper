// dart
import 'dart:io';
// material
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
// constants
import 'package:whisper/constants/colors.dart';
import 'package:whisper/constants/counts.dart';
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/constants/routes.dart' as routes;
// notifiers
import 'package:whisper/posts/notifiers/play_button_notifier.dart';
import 'package:whisper/posts/notifiers/progress_notifier.dart';
import 'package:whisper/posts/notifiers/repeat_button_notifier.dart';
// states
import 'package:whisper/constants/states.dart';
// models
import 'package:whisper/main_model.dart';

final userShowProvider = ChangeNotifierProvider(
  (ref) => UserShowModel()
);

class UserShowModel extends ChangeNotifier {

  late DocumentSnapshot passiveUserDoc;
  String passiveUid = '';
  bool isLoading = false;
  // notifiers
  final currentSongMapNotifier = ValueNotifier<Map<String,dynamic>>({});
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
  List<DocumentSnapshot> userShowDocs = [];
  // refresh
  late RefreshController refreshController;
  // Edit profile
  bool isEditing = false;
  String userName = '';
  String description = '';
  String link = '';
  // post
  String downloadURL = '';
  bool isCropped = false;
  XFile? xfile;
  File? croppedFile;
  // speed
  late SharedPreferences prefs;
  final speedNotifier = ValueNotifier<double>(1.0);
  // states
  SortState sortState = SortState.byNewestFirst;

  Future<void> init(DocumentSnapshot givePassiveUserDoc,SharedPreferences givePrefs) async {
    startLoading();
    audioPlayer = AudioPlayer();
    refreshController = RefreshController(initialRefresh: false);
    passiveUserDoc = givePassiveUserDoc;
    passiveUid = givePassiveUserDoc['uid'];
    prefs = givePrefs;
    await getPosts();
    await voids.setSpeed(audioPlayer: audioPlayer,prefs: prefs,speedNotifier: speedNotifier);
    voids.listenForStates(audioPlayer: audioPlayer, playButtonNotifier: playButtonNotifier, progressNotifier: progressNotifier, currentSongMapNotifier: currentSongMapNotifier, isShuffleModeEnabledNotifier: isShuffleModeEnabledNotifier, isFirstSongNotifier: isFirstSongNotifier, isLastSongNotifier: isLastSongNotifier);
    endLoading();
  }

  void theSameUserIcon(BuildContext context,MainModel mainModel) {
    audioPlayer = AudioPlayer();
    refreshController = RefreshController(initialRefresh: false);
    routes.toUserShowPage(context, passiveUserDoc, mainModel);
  }

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
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
                userShowDocs = [];
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
                userShowDocs = [];
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
                userShowDocs = [];
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

  void reload() {
    notifyListeners();
  }

  Future initAudioPlayer(int i) async {
    ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: afterUris);
    await audioPlayer.setAudioSource(playlist,initialIndex: i);
  }

  Future mutePost(List<String> mutesPostIds,SharedPreferences prefs,int i,Map<String,dynamic> post) async {
    // Abstractions in post_futures.dart cause Range errors.
    final postId = post['postId'];
    mutesPostIds.add(postId);
    userShowDocs.removeWhere((result) => result['postId'] == postId);
    await voids.resetAudioPlayer(afterUris: afterUris, audioPlayer: audioPlayer, i: i);
    notifyListeners();
    await prefs.setStringList('mutesPostIds', mutesPostIds);
  }

  Future muteUser(List<dynamic> mutesUids,SharedPreferences prefs,int i,DocumentSnapshot currentUserDoc,List<dynamic> mutesIpv6AndUids,Map<String,dynamic> post) async {
    // Abstractions in post_futures.dart cause Range errors.
    final String uid = post['uid'];
    await removeTheUsersPost(uid, i);
    mutesUids.add(uid);
    mutesIpv6AndUids.add({
      'ipv6': post['ipv6'],
      'uid': uid,
    });
    notifyListeners();
    await FirebaseFirestore.instance.collection('users').doc(currentUserDoc.id)
    .update({
      'mutesIpv6AndUids': mutesIpv6AndUids,
    }); 
  }

  Future blockUser(DocumentSnapshot currentUserDoc,List<dynamic> blockingUids,int i,List<dynamic> mutesIpv6AndUids,Map<String,dynamic> post) async {
    // Abstractions in post_futures.dart cause Range errors.
    final String uid = post['uid'];
    await removeTheUsersPost(uid, i);
    blockingUids.add(uid);
    mutesIpv6AndUids.add({
      'ipv6': post['ipv6'],
      'uid': uid,
    });
    notifyListeners();
    await FirebaseFirestore.instance
    .collection('users')
    .doc(currentUserDoc.id)
    .update({
      'blockingUids': blockingUids,
      'mutesIpv6AndUids': mutesIpv6AndUids,
    }); 
  }

  Future removeTheUsersPost(String uid,int i) async {
    userShowDocs.removeWhere((result) => result['uid'] == uid);
    await voids.resetAudioPlayer(afterUris: afterUris, audioPlayer: audioPlayer, i: i);
  }

  Future onRefresh() async {
    await getNewUserShowPosts();
    notifyListeners();
    refreshController.refreshCompleted();
  }

  Future getNewUserShowPosts() async {
    QuerySnapshot<Map<String, dynamic>> newSnapshots = await FirebaseFirestore.instance
    .collection('posts')
    .where('uid',isEqualTo: passiveUserDoc['uid'])
    .orderBy('createdAt',descending: true)
    .endBeforeDocument(userShowDocs[0])
    .limit(oneTimeReadCount)
    .get();
    // Sort by oldest first
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = newSnapshots.docs;
    docs.sort((a,b) => a['createdAt'].compareTo(b['createdAt']));
    // Insert at the top
    docs.forEach((DocumentSnapshot? doc) {
      userShowDocs.insert(0, doc!);
      Uri song = Uri.parse(doc['audioURL']);
      UriAudioSource source = AudioSource.uri(song, tag: doc);
      afterUris.insert(0, source);
    });
    if (afterUris.isNotEmpty) {
      ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: afterUris);
      await audioPlayer.setAudioSource(playlist);
    }
  }

  Future onLoading() async {
    await getOldUserShowPosts();
    refreshController.loadComplete();
    notifyListeners();
  }

  Future getPosts() async {
    try {
      userShowDocs = [];
      await FirebaseFirestore.instance
      .collection('posts')
      .where('uid',isEqualTo: passiveUserDoc['uid'])
      .orderBy('createdAt',descending: true)
      .limit(oneTimeReadCount)
      .get()
      .then((qshot) {
        List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = qshot.docs;
        docs.sort((a,b) => b['createdAt'].compareTo(a['createdAt']));
        docs.forEach((DocumentSnapshot? doc) {
          userShowDocs.add(doc!);
          Uri song = Uri.parse(doc['audioURL']);
          UriAudioSource source = AudioSource.uri(song, tag: doc);
          afterUris.add(source);
        });
      });
      if (afterUris.isNotEmpty) {
        ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: afterUris);
        await audioPlayer.setAudioSource(playlist);
      }
    } catch(e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future<void> getOldUserShowPosts() async {
    try {
      await FirebaseFirestore.instance
      .collection('posts')
      .where('uid',isEqualTo: passiveUserDoc['uid'])
      .orderBy('createdAt',descending: true)
      .startAfterDocument(userShowDocs.last)
      .limit(oneTimeReadCount)
      .get()
      .then((qshot) async {
        final lastIndex = userShowDocs.lastIndexOf(userShowDocs.last);
        List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = qshot.docs;
        docs.sort((a,b) => b['createdAt'].compareTo(a['createdAt']));
        docs.forEach((DocumentSnapshot? doc) {
          userShowDocs.add(doc!);
          Uri song = Uri.parse(doc['audioURL']);
          UriAudioSource source = AudioSource.uri(song, tag: doc);
          afterUris.add(source);
        });
        if (afterUris.isNotEmpty) {
          ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: afterUris);
          await audioPlayer.setAudioSource(playlist,initialIndex: lastIndex);
        }
      });
    } catch(e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future showImagePicker() async {
    final ImagePicker _picker = ImagePicker();
    xfile = await _picker.pickImage(source: ImageSource.gallery);
    if (xfile != null) {
      await cropImage();
    }
    notifyListeners();
  }

  Future cropImage() async {
    isCropped = false;
    croppedFile = null;
    croppedFile = await ImageCropper.cropImage(
      sourcePath: xfile!.path,
      aspectRatioPresets: Platform.isAndroid ?
      [
        CropAspectRatioPreset.square,
      ]
      : [
        // CropAspectRatioPreset.original,
        CropAspectRatioPreset.square,
      ],
      androidUiSettings: const AndroidUiSettings(
        toolbarTitle: 'Cropper',
        toolbarColor: kPrimaryColor,
        toolbarWidgetColor: Colors.white,
        // initAspectRatio: CropAspectRatioPreset.original,
        initAspectRatio: CropAspectRatioPreset.square,
        lockAspectRatio: false
      ),
      iosUiSettings: const IOSUiSettings(
        title: 'Cropper',
      )
    );
    if (croppedFile != null) {
      isCropped = true;
    }
    notifyListeners();
  }

  Future<String> uploadImage(DocumentSnapshot currentUserDoc) async {
    final String dateTime = DateTime.now().microsecondsSinceEpoch.toString();
    if (userName.isEmpty) {
      print('userNameを入力してください');
    }
    try {
      await FirebaseStorage.instance
      .ref()
      .child('users')
      .child(currentUserDoc['uid'] + dateTime + '.jpg')
      .putFile(croppedFile!);
      downloadURL = await FirebaseStorage.instance
      .ref()
      .child('users')
      .child(currentUserDoc['uid'] + dateTime + '.jpg')
      .getDownloadURL();
    } catch(e) {
      print(e.toString());
    }
    return downloadURL;
  }

  void seek(Duration position) {
    audioPlayer.seek(position);
  }

  void onEditButtonPressed(DocumentSnapshot currentUserDoc) {
    userName = currentUserDoc['userName'];
    description = currentUserDoc['description'];
    link = currentUserDoc['link'];
    isEditing = true;
    notifyListeners();
  }

  Future updateUserInfo(BuildContext context,DocumentSnapshot currentUserDoc) async {

    final String downloadURL = croppedFile == null ? currentUserDoc['imageURL'] : await uploadImage(currentUserDoc);
    if (downloadURL.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('エラーが発生。もう一度待ってからお試しください')));
    } else {
      try {
      await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserDoc.id)
        .update({
          'description': description,
          'link': link,
          'updatedAt': Timestamp.now(),
          'userName': userName,
        });
        notifyListeners();
      } catch(e) {
        print(e.toString());
      }
    }
  }

  Future onSaveButtonPressed(BuildContext context,DocumentSnapshot currentUserDoc) async {
    await updateUserInfo(context,currentUserDoc);
    isEditing = false;
  }


}