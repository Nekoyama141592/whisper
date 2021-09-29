import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_audio/just_audio.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:whisper/constants/colors.dart';

import 'package:whisper/posts/audio_controll/notifiers/play_button_notifier.dart';
import 'package:whisper/posts/audio_controll/notifiers/progress_notifier.dart';

final addPostProvider = ChangeNotifierProvider(
  (ref) => AddPostModel()
);

enum AddPostState {
  initialValue,
  recording,
  recorded,
  uploading,
  uploaded
}

class AddPostModel extends ChangeNotifier {
  
  final postTitleNotifier = ValueNotifier<String>('');
  // bool isUploading = false;
  // bool isRecording = false;
  // bool isRecorded = false;
  // bool isUploaded = false;
  AddPostState addPostState = AddPostState.initialValue;
  late AudioPlayer audioPlayer;
  String recordFilePath = '';
  String filePath = "";
  late File audioFile;
  late Record audioRecorder;
  User? currentUser;

  // notifiers
  final progressNotifier = ProgressNotifier();
  final playButtonNotifier = PlayButtonNotifier();

  // timer
  final stopWatchTimer = StopWatchTimer();
  // imagePicker
  XFile? xfile;
  File? imageFile;

  AddPostModel() {
    init();
  }

  void init() {
    audioPlayer = AudioPlayer();
    setCurrentUser();
  }

  void startLoading() {
    addPostState = AddPostState.uploading;
    notifyListeners();
  }

  void endLoading() {
    addPostState = AddPostState.uploaded;
    notifyListeners();
  }

  void reload() {
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
    File? croppedFile = await ImageCropper.cropImage(
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
      imageFile = croppedFile;
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

  play() {
    audioPlayer.play();
    notifyListeners();
  }

  pause() {
    audioPlayer.pause();
    notifyListeners();
  }

  seek(Duration position) {
    audioPlayer.seek(position);
  }

  Future startRecording(BuildContext context) async {
    audioRecorder = Record();
    bool hasRecordingPermission = await audioRecorder.hasPermission();

    if (hasRecordingPermission == true) {
      Directory directory = await getApplicationDocumentsDirectory();
      recordFilePath = directory.path + '/'
      + currentUser!.uid
      +  DateTime.now().microsecondsSinceEpoch.toString() 
      + '.aac';
      filePath = recordFilePath;
      await audioRecorder.start(
        path: filePath,
      );

      startMeasure();
      notifyListeners();
    } else {
      ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Center(child: Text('マイクの許可をお願いします！！'))));
    }
  }

  Future onRecordButtonPressed(context) async {
    if (!(addPostState == AddPostState.recording)) {
      addPostState = AddPostState.recording;
      notifyListeners();
      await startRecording(context);
      // startTimer
    } else {
      audioRecorder.stop();
      stopMeasure();
      await setAudio(filePath);
      audioFile = File(filePath);
      addPostState = AddPostState.recorded;
      listenForStates();
      notifyListeners();
    }
  }

  Future<String> getPostUrl(context) async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    try {
      await firebaseStorage
      .ref('posts')
      .child(
        filePath.substring(
          filePath.lastIndexOf('/'),
          filePath.length
        )
      )
      
      .putFile(audioFile);
    } catch(e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error occured while uploading')
        )
      );
    }
    final String downloadURL = await firebaseStorage
    .ref('posts')
    .child(
      filePath.substring(
          filePath.lastIndexOf('/'),
          filePath.length
      )
    )
    .getDownloadURL();
    
    return downloadURL;
  }


  void onRecordAgainButtonPressed() {
    addPostState = AddPostState.initialValue;
    postTitleNotifier.value = '';
    notifyListeners();
  }
  
  Future onUploadButtonPressed(context) async {
    startLoading();
    await addPostToFirebase(context);
    endLoading();
    
  }

  Future setCurrentUser() async {
    currentUser = FirebaseAuth.instance.currentUser;
  }

  
  Future addPostToFirebase(context) async {
    if (postTitleNotifier.value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('postTitle is Empty'))
      );
    } else {
      try {
        
        final audioURL = await getPostUrl(context);
        await FirebaseFirestore.instance.collection('posts')
        .add({
          'ImageExist': false,
          'audioURL': audioURL,
          'comments': [],
          'createdAt': Timestamp.now(),
          'likesCount': 0,
          'postId': currentUser!.uid + DateTime.now().microsecondsSinceEpoch.toString(),
          'preservationsCount': 0,
          'score': 0,
          'title': postTitleNotifier.value,
          'imageURL': '',
          'uid': currentUser!.uid,
          'updatedAt': Timestamp.now(),
          'userImageURL': '',
        });
        
      } catch(e) {
        print(e.toString());
      }
    }
  }

  void listenForStates() {
    listenForChangesInPlayerState();
    listenForChangesInPlayerPosition();
    listenForChangesInBufferedPosition();
    listenForChangesInTotalDuration();
  }
  void listenForChangesInPlayerState() {
    audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        playButtonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        playButtonNotifier.value = ButtonState.paused;
      } else if (processingState != ProcessingState.completed) {
        playButtonNotifier.value = ButtonState.playing;
      } else {
        audioPlayer.seek(Duration.zero);
        audioPlayer.pause();
      }
    });
  }

  void listenForChangesInPlayerPosition() {
    audioPlayer.positionStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });
  }

  void listenForChangesInBufferedPosition() {
    audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });
  }

  void listenForChangesInTotalDuration() {
    audioPlayer.durationStream.listen((totalDuration) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );
    });
  }

  
}