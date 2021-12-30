// dart
import 'dart:async';
import 'dart:io';
// material
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// packages
import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_audio/just_audio.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whisper/constants/counts.dart';
// constants
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/constants/others.dart' as others;
import 'package:whisper/main_model.dart';
// notifiers
import 'package:whisper/posts/notifiers/progress_notifier.dart';
import 'package:whisper/posts/notifiers/play_button_notifier.dart';
import 'package:whisper/components/add_post/components/notifiers/add_post_state_notifier.dart';
// components
import 'package:whisper/details/rounded_button.dart';

final addPostProvider = ChangeNotifierProvider(
  (ref) => AddPostModel()
);


class AddPostModel extends ChangeNotifier {
  
  final postTitleNotifier = ValueNotifier<String>('');
  
  late AudioPlayer audioPlayer;
  String filePath = "";
  late File audioFile;
  late Record audioRecorder;

  // notifiers
  final progressNotifier = ProgressNotifier();
  final playButtonNotifier = PlayButtonNotifier();
  final addPostStateNotifier = AddPostStateNotifier();
  final isCroppedNotifier = ValueNotifier<bool>(false);
  // timer
  final stopWatchTimer = StopWatchTimer();
  // imagePicker
  XFile? xFile;
  File? croppedFile;
  // IP
  String ipv6 = '';
  // commentsState
  final commentsStateDisplayNameNotifier = ValueNotifier<String>('誰でもコメント可能');
  String commentsState = 'open';
  // link 
  String link = '';

  AddPostModel() {
    init();
  }

  void init() {
    audioPlayer = AudioPlayer();
  }

  void startLoading() {
    addPostStateNotifier.value = AddPostState.uploading;
  }

  void endLoading() {
    addPostStateNotifier.value = AddPostState.uploaded;
  }

  void reload() {
    notifyListeners();
  }

  Future showImagePicker() async {
    final ImagePicker _picker = ImagePicker();
    xFile = await _picker.pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      await cropImage();
    }
    notifyListeners();
  }

  Future cropImage() async {
    isCroppedNotifier.value = false;
    croppedFile = null;
    croppedFile = await others.returnCroppedFile(xFile: xFile);
    if (croppedFile != null) {
      isCroppedNotifier.value = true;
      notifyListeners();
    }
  }

  void startMeasure() {
    stopWatchTimer.onExecute.add(StopWatchExecute.start);
  }

  void stopMeasure() {
    stopWatchTimer.onExecute.add(StopWatchExecute.stop);
  }

  void resetMeasure() {
    stopWatchTimer.onExecute.add(StopWatchExecute.reset);
  }
  
  Future setAudio(String filepath) async {
    await audioPlayer.setFilePath(filePath);
  }

  void play() {
    audioPlayer.play();
    notifyListeners();
  }

  void pause() {
    audioPlayer.pause();
    notifyListeners();
  }

  void seek(Duration position) {
    audioPlayer.seek(position);
  }

  Future startRecording({ required BuildContext context, required MainModel mainModel }) async {
    audioRecorder = Record();
    bool hasRecordingPermission = await audioRecorder.hasPermission();
    if (hasRecordingPermission == true) {
      Directory directory = await getApplicationDocumentsDirectory();
      filePath = directory.path + '/' + mainModel.currentUserDoc['uid'] +  DateTime.now().microsecondsSinceEpoch.toString() + '.aac';
      await audioRecorder.start( path: filePath,);
      startMeasure();
      notifyListeners();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Center(child: Text('マイクの許可をお願いします')))); }
  }

  Future onRecordButtonPressed({ required BuildContext context, required MainModel mainModel }) async {
    if (!(addPostStateNotifier.value == AddPostState.recording)) {
      await startRecording(context: context,mainModel: mainModel);
      addPostStateNotifier.value = AddPostState.recording;
    } else {
      audioRecorder.stop();
      stopMeasure();
      await setAudio(filePath);
      audioFile = File(filePath);
      addPostStateNotifier.value = AddPostState.recorded;
      voids.listenForStatesForAddPostModel(audioPlayer: audioPlayer, playButtonNotifier: playButtonNotifier, progressNotifier: progressNotifier);
    }
  }

  Future<String> getPostUrl({ required BuildContext context, required String storagePostName ,required MainModel mainModel }) async {
    final Reference storageRef = others.postRef(mainModel: mainModel, storagePostName: storagePostName);
    await storageRef.putFile(audioFile);
    final String postDownloadURL = await storageRef.getDownloadURL();
    return postDownloadURL;
  }


  void onRecordAgainButtonPressed() {
    postTitleNotifier.value = '';
    addPostStateNotifier.value = AddPostState.initialValue;
  }

  Future onUploadButtonPressed({ required BuildContext context, required MainModel mainModel }) async {
    if (postTitleNotifier.value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('タイトルを入力してください')));
    } else {
      startLoading();
      Navigator.pop(context);
      final String microSecondsString = DateTime.now().microsecondsSinceEpoch.toString();
      if (ipv6.isEmpty) { ipv6 =  await Ipify.ipv64(); }
      // postImage
      final String storageImageName = 'postImage' + microSecondsString + '.jpg';
      final String imageURL = croppedFile == null ? '' : await getPostImageURL(postImageName: storageImageName, mainModel: mainModel);
      // post
      final String storagePostName = 'post' + microSecondsString + '.aac';
      final audioURL = await getPostUrl(context: context, storagePostName: storagePostName, mainModel: mainModel);
      // post firestore
      final String postId = 'post' + mainModel.currentUserDoc['uid'] + microSecondsString;
      await addPostToFirebase(context: context, mainModel: mainModel, imageURL: imageURL, audioURL: audioURL, storageImageName: storageImageName, storagePostName: storagePostName, postId: postId);
      postTitleNotifier.value = '';
      endLoading();
    }
  }

  Future<String> getPostImageURL({ required String postImageName , required MainModel mainModel}) async {
    final Reference storageRef = others.postImageRef(mainModel: mainModel, postImageName: postImageName);
    await storageRef.putFile(croppedFile!);
    final String downloadURL = await storageRef.getDownloadURL();
    return downloadURL;
  }

  
  Future addPostToFirebase({ required BuildContext context, required MainModel mainModel, required String imageURL, required String audioURL, required String storageImageName, required  String storagePostName,required String postId }) async {
    final currentUserDoc = mainModel.currentUserDoc;
      try {
        await FirebaseFirestore.instance.collection('posts')
        .doc(postId)
        .set({
          'audioURL': audioURL,
          'bookmarks':[],
          'bookmarksCount': 0,
          'commentsCount': 0,
          'commentsState': commentsState,
          'createdAt': Timestamp.now(),
          'country': '',
          'description': '',
          'genre': '',
          'hashTags': [],
          'imageURL': imageURL,
          'impression': 0,
          'ipv6': ipv6,
          'isDelete': false,
          'isNFTicon': currentUserDoc['isNFTicon'],
          'isOfficial': currentUserDoc['isOfficial'],
          'isPinned': false,
          'isPlayedCount': 0,
          'likes':[],
          'likesCount': 0,
          'link': link,
          'negativeScore': 0,
          'noDisplayWords': currentUserDoc['noDisplayWords'],
          'noDisplayIpv6AndUids': currentUserDoc['blocksIpv6AndUids'],
          'otherLinks': [],
          'postId': postId,
          'positiveScore': 0,
          'score': defaultScore,
          'storageImageName': storageImageName,
          'storagePostName': storagePostName,
          'tagUids': [],
          'title': postTitleNotifier.value,
          'uid': currentUserDoc['uid'],
          'updatedAt': Timestamp.now(),
          'userImageURL': currentUserDoc['imageURL'],
          'userName': currentUserDoc['userName'],
        });
        addPostStateNotifier.value = AddPostState.uploaded;
      } catch(e) {
        print(e.toString());
      }
  }

    void showAddLinkDialogue(BuildContext context, TextEditingController linkEditingController) {
    showDialog(
      context: context, 
      builder: (_) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(16.0)
            )
          ),
          child: AlertDialog(
            title: Text('リンクを追加'),
            content: TextField(
              controller: linkEditingController,
              keyboardType: TextInputType.url,
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'https://'
              ),
    
              onChanged: (text) {
                link = text;
              },
            ),
            actions: [
              TextButton(
                onPressed: () {
                  link = '';
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Theme.of(context).focusColor,
                    fontWeight: FontWeight.bold
                  ),
                )
              ),
              RoundedButton(
                text: 'OK', 
                widthRate: 0.25, 
                verticalPadding: 12.0, 
                horizontalPadding: 0.0, 
                press: () { Navigator.pop(context); }, 
                textColor: Colors.white, 
                buttonColor: Theme.of(context).highlightColor
              )
            ],
          ),
        );
      }
    );
  }

  void showCommentStatePopUp(BuildContext context) {
    showCupertinoModalPopup(
      context: context, 
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text('コメントの状態'),
          message: Text('コメントの状態を設定します'),
          actions: [
            CupertinoActionSheetAction(
              child: Text(
                '誰でもコメント可能',
                style: TextStyle(
                  color: Theme.of(context).highlightColor,
                  fontWeight: FontWeight.bold
                ),
              ),
              onPressed: () {
                commentsState = 'open';
                commentsStateDisplayNameNotifier.value = '誰でもコメント可能';
                Navigator.pop(context);
              },
            ),
            CupertinoActionSheetAction(
              child: Text(
                '自分以外コメント不可能',
                style: TextStyle(
                  color: Theme.of(context).highlightColor,
                  fontWeight: FontWeight.bold
                ),
              ),
              onPressed: () {
                commentsState = 'isLocked';
                commentsStateDisplayNameNotifier.value = '自分以外コメント不可能';
                Navigator.pop(context);
              },
            ),
          ],
        );
      }
    );
  }
}