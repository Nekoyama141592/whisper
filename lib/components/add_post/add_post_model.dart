// dart
import 'dart:async';
import 'dart:io';
// material
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_audio/just_audio.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whisper/constants/ints.dart';
import 'package:whisper/constants/nums.dart';
import 'package:whisper/constants/strings.dart';
// constants
import 'package:whisper/constants/lists.dart';
import 'package:whisper/constants/maps.dart';
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/constants/others.dart' as others;
import 'package:whisper/domain/whisper_link/whisper_link.dart';
import 'package:whisper/main_model.dart';
// domain
import 'package:whisper/domain/post/post.dart';
import 'package:whisper/domain/whisper_user/whisper_user.dart';
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
      filePath = directory.path + '/' + returnStoragePostName;
      await audioRecorder.start( path: filePath, encoder: AudioEncoder.AAC);
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

  Future<String> getPostUrl({ required BuildContext context, required String storagePostName ,required MainModel mainModel,required String postId }) async {
    final Reference storageRef = others.returnPostChildRef(mainModel: mainModel, storagePostName: storagePostName);
    await voids.putPost(postRef: storageRef, postFile: audioFile );
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
    } else if (postTitleNotifier.value.length > maxSearchLength ) {
      voids.maxSearchLengthAlert(context: context, isUserName: false );
    } else {
      startLoading();
      Navigator.pop(context);
      final String postId = returnPostId(userMeta: mainModel.userMeta);
      // postImage
      final String storageImageName = (croppedFile == null) ? '' : returnStoragePostImageName();
      final String imageURL = (croppedFile == null) ? '' : await getPostImageURL(postImageName: storageImageName, mainModel: mainModel,postId: postId);
      // post
      final String storagePostName = returnStoragePostName;
      final audioURL = await getPostUrl(context: context, storagePostName: storagePostName, mainModel: mainModel, postId: postId);
      // post firestore
      await addPostToFirebase(context: context, mainModel: mainModel, imageURL: imageURL, audioURL: audioURL, postId: postId);
      postTitleNotifier.value = '';
      endLoading();
    }
  }

  Future<String> getPostImageURL({ required String postImageName , required MainModel mainModel,required String postId }) async {
    final Reference storageRef = others.returnPostImageChildRef(mainModel: mainModel, postImageName: postImageName, postId: postId);
    await voids.putImage(imageRef: storageRef, file: croppedFile! );
    final String downloadURL = await storageRef.getDownloadURL();
    return downloadURL;
  }

  
  Future addPostToFirebase({ required BuildContext context, required MainModel mainModel, required String imageURL, required String audioURL,required String postId }) async {
    final WhisperUser currentWhiseprUser = mainModel.currentWhisperUser;
    final Timestamp now = Timestamp.now();
    final String title = postTitleNotifier.value;
    final List<String> searchWords = returnSearchWords(searchTerm: title);
    final WhisperLink whisperLink = WhisperLink(description: '', imageURL: imageURL, label: '', link: link, );
    Map<String,dynamic> postMap = Post(
      accountName: currentWhiseprUser.accountName,
      audioURL: audioURL, 
      bookmarkCount: 0,
      commentCount: 0,
      commentsState: commentsState, 
      country: '', 
      createdAt: now,
      description: '', 
      genre: '', 
      hashTags: [],
      imageURLs: [imageURL], 
      impression: 0,
      isDelete: false,
      isNFTicon: currentWhiseprUser.isNFTicon,
      isOfficial: currentWhiseprUser.isOfficial,
      isPinned: false,
      likeCount: 0,
      links: [whisperLink.toJson()], 
      negativeScore: 0,
      playCount: 0,
      postId: postId, 
      positiveScore: 0,
      score: defaultScore.toDouble(),
      tagAccountNames: [],
      searchToken: returnSearchToken(searchWords: searchWords),
      title: title,
      uid: currentWhiseprUser.uid,
      updatedAt: now,
      userImageURL: currentWhiseprUser.imageURL,
      userName: currentWhiseprUser.userName
      ).toJson();
      try {
        // await FirebaseFirestore.instance.collection(postsFieldKey).doc(postId).set(postMap);
        await others.returnPostDocRef(postCreatorUid: currentWhiseprUser.uid, postId: postId).set(postMap);
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