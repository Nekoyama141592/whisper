// material
import 'package:flutter/material.dart';
// packages
import 'package:just_audio/just_audio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/abstract_models/posts_model.dart';
// constants
import 'package:whisper/constants/enums.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/voids.dart' as voids;
// domain
import 'package:whisper/domain/post/post.dart';
// notifiers
import 'package:whisper/posts/notifiers/play_button_notifier.dart';
import 'package:whisper/posts/notifiers/progress_notifier.dart';
import 'package:whisper/posts/notifiers/repeat_button_notifier.dart';

final onePostProvider = ChangeNotifierProvider(
  (ref) => OnePostModel()
);

class OnePostModel extends PostsModel {
  
  final PostType postType = PostType.onePost;
  // post
  late DocumentSnapshot<Map<String,dynamic>> onePostDoc;
  List<DocumentSnapshot<Map<String,dynamic>>> onePostDocList = [];
  final currentWhisperPostNotifier = ValueNotifier<Post?>(null);
  String indexPostId = '';

  Future<bool> init({ required String postId, required DocumentReference<Map<String,dynamic>> postDocRef }) async {
    startLoading();
    if (indexPostId != postId) {
      onePostDocList = [];
      indexPostId = postId;
      onePostDoc = await postDocRef.get();
      onePostDocList.add(onePostDoc);
      final Post post = fromMapToPost(postMap: onePostDoc.data()! );
      Uri song = Uri.parse(post.audioURL);
      UriAudioSource audioSource = AudioSource.uri(song,tag: post );
      audioPlayer = AudioPlayer();
      await audioPlayer.setAudioSource(audioSource);
      super.listenForStates();
    }
    endLoading();
    return onePostDoc.exists;
  }
}