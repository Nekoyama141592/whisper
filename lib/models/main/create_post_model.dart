// dart
import 'dart:async';
import 'dart:io';
// material
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// packages
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:whisper/details/positive_text.dart';
import 'package:whisper/l10n/l10n.dart';
// constants
import 'package:whisper/main_model.dart';
import 'package:whisper/constants/ints.dart';
import 'package:whisper/constants/maps.dart';
import 'package:whisper/constants/lists.dart';
import 'package:whisper/constants/enums.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/doubles.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/voids.dart' as voids;
// domain
import 'package:whisper/domain/post/post.dart';
import 'package:whisper/domain/whisper_user/whisper_user.dart';
import 'package:whisper/domain/whisper_link/whisper_link.dart';
// notifiers
import 'package:whisper/posts/notifiers/progress_notifier.dart';
import 'package:whisper/posts/notifiers/play_button_notifier.dart';
import 'package:whisper/notifiers/create_post_state_notifier.dart';
// pages
import 'package:whisper/views/post_links/links_page.dart';

final addPostProvider = ChangeNotifierProvider(
  (ref) => CreatePostModel()
);


class CreatePostModel extends ChangeNotifier {
  
  final postTitleNotifier = ValueNotifier<String>('');
  late AudioPlayer audioPlayer;
  String filePath = "";
  late File audioFile;
  late Record audioRecorder;

  // notifiers
  final progressNotifier = ProgressNotifier();
  final playButtonNotifier = PlayButtonNotifier();
  final addPostStateNotifier = CreatePostStateNotifier();
  final isCroppedNotifier = ValueNotifier<bool>(false);
  // timer
  final stopWatchTimer = StopWatchTimer();
  // imagePicker
  XFile? xFile;
  File? croppedFile;
  // commentsState
  final commentsStateDisplayNameNotifier = ValueNotifier<String>('');
  CommentsState commentsState = CommentsState.isOpen;
  // link 
  final whisperLinksNotifier = ValueNotifier<List<WhisperLink>>([]);
  CreatePostModel() {
    init();
  }

  void init() => audioPlayer = AudioPlayer();

  void startLoading() => addPostStateNotifier.value = CreatePostState.uploading;

  void endLoading() => addPostStateNotifier.value = CreatePostState.uploaded;

  Future<void> showImagePicker() async {
    final ImagePicker _picker = ImagePicker();
    xFile = await _picker.pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      await cropImage();
    }
    notifyListeners();
  }

  Future<void> cropImage() async {
    isCroppedNotifier.value = false;
    croppedFile = null;
    croppedFile = await returnCroppedFile(xFile: xFile);
    if (croppedFile != null) {
      isCroppedNotifier.value = true;
      notifyListeners();
    }
  }

  void startMeasure() => stopWatchTimer.onExecute.add(StopWatchExecute.start);

  void stopMeasure() => stopWatchTimer.onExecute.add(StopWatchExecute.stop);

  void resetMeasure() => stopWatchTimer.onExecute.add(StopWatchExecute.reset);
  
  Future setAudio({ required String filePath}) async => await audioPlayer.setFilePath(filePath);

  void play() {
    audioPlayer.play();
    notifyListeners();
  }

  void pause() {
    audioPlayer.pause();
    notifyListeners();
  }

  void seek(Duration position) => audioPlayer.seek(position);

  Future<void> startRecording({ required BuildContext context, required MainModel mainModel }) async {
    audioRecorder = Record();
    bool hasRecordingPermission = await audioRecorder.hasPermission();
    if (hasRecordingPermission == true) {
      Directory directory = await getApplicationDocumentsDirectory();
      filePath = directory.path + '/' + returnStoragePostName();
      await audioRecorder.start( path: filePath, encoder: AudioEncoder.AAC);
      startMeasure();
      notifyListeners();
    }
  }

  Future<void> onRecordButtonPressed({ required BuildContext context, required MainModel mainModel }) async {
    if (!(addPostStateNotifier.value == CreatePostState.recording)) {
      await startRecording(context: context,mainModel: mainModel);
      addPostStateNotifier.value = CreatePostState.recording;
    } else {
      audioRecorder.stop();
      stopMeasure();
      await setAudio( filePath:filePath);
      audioFile = File(filePath);
      addPostStateNotifier.value = CreatePostState.recorded;
      voids.listenForStatesForAddPostModel(audioPlayer: audioPlayer, playButtonNotifier: playButtonNotifier, progressNotifier: progressNotifier);
    }
  }

  Future<String> getPostUrl({ required BuildContext context, required String storagePostName ,required MainModel mainModel,required String postId }) async {
    final Reference storageRef = returnPostChildRef(mainModel: mainModel, storagePostName: storagePostName);
    await voids.putPost(postRef: storageRef, postFile: audioFile );
    final String postDownloadURL = await storageRef.getDownloadURL();
    return postDownloadURL;
  }


  void onRecordAgainButtonPressed() {
    postTitleNotifier.value = '';
    addPostStateNotifier.value = CreatePostState.initialValue;
  }

  Future<void> onUploadButtonPressed({ required BuildContext context, required MainModel mainModel }) async {
    if (postTitleNotifier.value.isEmpty) {
      voids.showBasicFlutterToast(context: context, msg: pleaseInputTitleMsg(context: context) );
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
      final String storagePostName = returnStoragePostName();
      final audioURL = await getPostUrl(context: context, storagePostName: storagePostName, mainModel: mainModel, postId: postId);
      await voids.createUserMetaUpdateLog(mainModel: mainModel);
      // なぜかRuleに引っかかるけど、正常に作成される。これより下にFirebaseの処理は入れないこと。
      await createPost(context: context, mainModel: mainModel, imageURL: imageURL, audioURL: audioURL, postId: postId,storagePostName: storagePostName );
      postTitleNotifier.value = '';
      croppedFile = null;
      isCroppedNotifier.value = false;
      endLoading();
    }
  }

  Future<String> getPostImageURL({ required String postImageName , required MainModel mainModel,required String postId }) async {
    final Reference storageRef = returnPostImageChildRef(mainModel: mainModel, postImageName: postImageName, postId: postId);
    await voids.putImage(imageRef: storageRef, file: croppedFile! );
    final String downloadURL = await storageRef.getDownloadURL();
    return downloadURL;
  }
  
  Future<void> createPost({ required BuildContext context, required MainModel mainModel, required String imageURL, required String audioURL,required String postId,required String storagePostName}) async {
    // process set
    final WhisperUser currentWhisperUser = mainModel.currentWhisperUser;
    final Timestamp now = Timestamp.now();
    final String title = postTitleNotifier.value;
    final List<String> searchWords = returnSearchWords(searchTerm: title);

    Map<String,dynamic> postMap = Post(
      accountName: currentWhisperUser.accountName,
      audioURL: audioURL, 
      bookmarkCount: initialCount,
      commentsState: returnCommentsStateString(commentsState: commentsState), 
      country: '', 
      createdAt: now,
      description: '', 
      descriptionLanguageCode: '',
      descriptionNegativeScore: initialNegativeScore,
      descriptionPositiveScore: initialPositiveScore,
      descriptionSentiment: '',
      genre: '', 
      hashTags: [],
      imageURLs: [imageURL], 
      impressionCount: initialCount,
      isNFTicon: currentWhisperUser.isNFTicon,
      isOfficial: currentWhisperUser.isOfficial,
      isPinned: false,
      likeCount: initialCount,
      links: whisperLinksNotifier.value.map((e) => e.toJson() ).toList(), 
      mainWalletAddress: currentWhisperUser.mainWalletAddress,
      muteCount: initialCount,
      nftIconInfo: {},
      playCount: initialCount,
      postId: postId, 
      postState: returnPostStateString(postState: PostState.basic ),
      postCommentCount: initialCount,
      reportCount: initialCount,
      score: defaultScore.toDouble(),
      storagePostName: storagePostName,
      tagAccountNames: [],
      recommendState: currentWhisperUser.recommendState,
      searchToken: returnSearchToken(searchWords: searchWords),
      title: title,
      titleLanguageCode: '',
      titleNegativeScore: initialNegativeScore,
      titlePositiveScore: initialPositiveScore,
      titleSentiment: '',
      uid: currentWhisperUser.uid,
      updatedAt: now,
      userImageURL: currentWhisperUser.userImageURL,
      userImageNegativeScore: initialNegativeScore,
      userName: currentWhisperUser.userName,
      userNameLanguageCode: currentWhisperUser.userNameLanguageCode,
      userNameNegativeScore: currentWhisperUser.userNameNegativeScore,
      userNamePositiveScore: currentWhisperUser.userNamePositiveScore,
      userNameSentiment: currentWhisperUser.userNameSentiment
      ).toJson();
      // process UI
      mainModel.currentWhisperUser.postCount += plusOne;
      await returnPostDocRef(postCreatorUid: currentWhisperUser.uid, postId: postId).set(postMap);
      addPostStateNotifier.value = CreatePostState.uploaded;
      await returnUserDocRef(uid: mainModel.currentWhisperUser.uid).update({ postCountFieldKey: mainModel.currentWhisperUser.postCount, });
  }

  void showCommentStatePopUp({ required BuildContext context}) {
    showCupertinoModalPopup(
      context: context, 
      builder: (BuildContext innerContext) {
        return CupertinoActionSheet(
          title: PositiveText(text: commentsStateText(context: context)),
          message: PositiveText(text: configCommentsStateText(context: context)),
          actions: [
            CupertinoActionSheetAction(
              child: Text(
                commentsStateIsOpenText(context: context),
                style: TextStyle(
                  color: Theme.of(innerContext).highlightColor,
                  fontWeight: FontWeight.bold
                ),
              ),
              onPressed: () {
                commentsState = CommentsState.isOpen;
                commentsStateDisplayNameNotifier.value = commentsStateIsOpenText(context: context);
                Navigator.pop(innerContext);
              },
            ),
            CupertinoActionSheetAction(
              child: Text(
                commentsStateIsLockedText(context: context),
                style: TextStyle(
                  color: Theme.of(innerContext).highlightColor,
                  fontWeight: FontWeight.bold
                ),
              ),
              onPressed: () {
                commentsState = CommentsState.isLocked;
                commentsStateDisplayNameNotifier.value = commentsStateIsLockedText(context: context);
                Navigator.pop(innerContext);
              },
            ),
          ],
        );
      }
    );
  }

  void initLinks({ required BuildContext context }) {
    final L10n l10n = returnL10n(context: context)!;
    Navigator.push(context, MaterialPageRoute(builder: (context) => LinksPage(whisperLinksNotifier: whisperLinksNotifier,roundedButtonText: l10n.decide,onRoundedButtonPressed: () => Navigator.pop(context), ) ));
    whisperLinksNotifier.value = [];
    notifyListeners();
  }

}