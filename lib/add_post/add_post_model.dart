import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

final addPostProvider = ChangeNotifierProvider(
  (ref) => AddPostModel()
);

class AddPostModel extends ChangeNotifier {
  String postTitle = "";
  bool isLoading = false;
  late bool isUploading;
  late bool isRecorded;
  late bool isRecording;
  late AudioPlayer audioPlayer;
  late String filePath;
  late File audioFile;
  late FlutterAudioRecorder2 audioRecorder;
  Recording? current;
  User? currentUser;
  late QuerySnapshot<Map<String, dynamic>> userDocument;
  
  AddPostModel() {
    init();
  }

  void init() {
    isUploading = false;
    isRecorded = false;
    isRecording = false;
    audioPlayer = AudioPlayer();
    setCurrentUser();
  }

  startLoading() {
    isLoading = true;
    notifyListeners();
  }

  endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future startRecording(BuildContext context) async {
    final bool? hasRecordingPermission =
    await FlutterAudioRecorder2.hasPermissions;
    if (hasRecordingPermission == true) {
      Directory directory = await getApplicationDocumentsDirectory();
      String setFilePath = directory.path + '/'
      + currentUser!.uid
      +  DateTime.now().millisecondsSinceEpoch.toString() 
      + '.aac';
      audioRecorder = FlutterAudioRecorder2(setFilePath, audioFormat: AudioFormat.AAC);
      await audioRecorder.initialized;
      audioRecorder.start();
      current = await audioRecorder.current(channel: 0);
      filePath = setFilePath;
      audioFile = File(filePath);
      notifyListeners();
    } else {
      ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Center(child: Text('Please enable recording permission'))));
    }
  }

  void onRecordButtonPressed(context) async {
    if (!isRecording) {
      isRecorded = false;
      isRecording = true;
      notifyListeners();
      await startRecording(context);
      
    } else {
      audioRecorder.stop();
      isRecording = false;
      isRecorded = true;
      notifyListeners();
    }
  }

  Future<String> onFileUploadButtonPressed(context) async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    isUploading = true;
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
    isRecorded = false;
    notifyListeners();
  }
  
  void onAddButtonPressed(context) async {
    startLoading();
    await addPostToFirebase(context);
    endLoading();
  }

  Future setCurrentUser() async {
    currentUser = FirebaseAuth.instance.currentUser;
  }

  
  Future addPostToFirebase(context) async {
    if (postTitle.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('postTitle is Empty'))
      );
    } else {
      try {
        
        final audioURL = await onFileUploadButtonPressed(context);
        await FirebaseFirestore.instance.collection('posts')
        .add({
          'imageURL': '',
          'ImageExist': false,
          'audioURL': audioURL,
          'uid': currentUser!.uid,
          'createdAt': Timestamp.now(),
          'updatedAt': Timestamp.now(),
          'score': 0,
          'likes': 0,
          'preservations': 0,
          'title': postTitle,
        });
        isUploading = false;
        notifyListeners();
      } catch(e) {
        print(e.toString());
      }
    }
  }
}